/**
 * Trigger: Scheduled via pg_cron (e.g. every 3–5 minutes)
 * Purpose: Checks open incidents against per-hop escalation timeouts.
 * If current level is unanswered after timeout, advances escalation level to next priority caregiver.
 */

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.38.0";

const SUPABASE_URL = Deno.env.get("SUPABASE_URL") ?? "";
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "";
const PER_HOP_TIMEOUT_MINUTES = 5;

serve(async (req) => {
  const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);

  try {
    const { data: openIncidents, error: incErr } = await supabase
      .from("incidents")
      .select("id, senior_id, created_at")
      .eq("status", "open");

    if (incErr) throw incErr;

    const summary = [];

    for (const incident of openIncidents || []) {
      // Get latest escalation entry
      const { data: lastEsc } = await supabase
        .from("incident_escalations")
        .select("*")
        .eq("incident_id", incident.id)
        .order("escalation_level", { ascending: false })
        .limit(1)
        .maybeSingle();

      const currentLevel = lastEsc ? lastEsc.escalation_level : 0;
      const lastNotifiedAt = lastEsc ? new Date(lastEsc.notified_at).getTime() : new Date(incident.created_at).getTime();
      const elapsedMinutes = (Date.now() - lastNotifiedAt) / (1000 * 60);

      if (elapsedMinutes >= PER_HOP_TIMEOUT_MINUTES && (!lastEsc || !lastEsc.responded_at)) {
        const nextLevel = currentLevel + 1;

        // Find caregiver for next priority
        const { data: link } = await supabase
          .from("caregiver_links")
          .select("caregiver_id")
          .eq("senior_id", incident.senior_id)
          .eq("priority_order", nextLevel)
          .maybeSingle();

        if (link) {
          await supabase.from("incident_escalations").insert({
            incident_id: incident.id,
            escalation_level: nextLevel,
            contact_id: link.caregiver_id,
            notified_at: new Date().toISOString(),
          });

          // Insert notification
          await supabase.from("notifications").insert({
            user_id: link.caregiver_id,
            type: "incident_escalation",
            payload: { incident_id: incident.id, level: nextLevel },
          });

          summary.push({ incident_id: incident.id, escalated_to_level: nextLevel });
        }
      }
    }

    return new Response(JSON.stringify({ success: true, summary }), {
      headers: { "Content-Type": "application/json" },
    });
  } catch (err) {
    return new Response(JSON.stringify({ error: err.message }), { status: 500 });
  }
});
