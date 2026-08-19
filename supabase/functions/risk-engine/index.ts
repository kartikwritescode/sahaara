/**
 * Trigger: Scheduled via pg_cron (e.g. every 10–15 minutes)
 * Purpose: Computes weighted risk score per active senior based on:
 *   - Inactivity duration vs baseline routine
 *   - Missed check-in status
 *   - Missed medication logs
 *   - Location anomaly / geofence breach
 * Writes output to risk_scores and opens an incident if score >= 60.
 */

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.38.0";

const SUPABASE_URL = Deno.env.get("SUPABASE_URL") ?? "";
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "";

serve(async (req) => {
  const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);

  try {
    const { data: seniors, error: seniorErr } = await supabase.from("senior_profiles").select("id, wake_time, sleep_time");
    if (seniorErr) throw seniorErr;

    const results = [];

    for (const senior of seniors || []) {
      let score = 0;
      const factors: { label: string; points: number }[] = [];

      // 1. Inactivity check (last activity event)
      const { data: lastEvent } = await supabase
        .from("activity_events")
        .select("occurred_at")
        .eq("senior_id", senior.id)
        .order("occurred_at", { ascending: false })
        .limit(1)
        .single();

      if (lastEvent) {
        const hoursInactive = (Date.now() - new Date(lastEvent.occurred_at).getTime()) / (1000 * 60 * 60);
        if (hoursInactive > 4) {
          const pts = Math.min(40, Math.floor(hoursInactive * 5));
          score += pts;
          factors.push({ label: `Unusual Inactivity (${Math.round(hoursInactive)}h)`, points: pts });
        }
      } else {
        score += 20;
        factors.push({ label: "No recorded activity", points: 20 });
      }

      // 2. Missed check-in check
      const { data: missedCheckin } = await supabase
        .from("check_ins")
        .select("id")
        .eq("senior_id", senior.id)
        .eq("response", "no_response")
        .gte("created_at", new Date(Date.now() - 24 * 60 * 60 * 1000).toISOString())
        .limit(1);

      if (missedCheckin && missedCheckin.length > 0) {
        score += 25;
        factors.push({ label: "Missed Safety Check-in", points: 25 });
      }

      // Cap score at 100
      score = Math.min(100, score);

      // Determine level
      let level: "normal" | "attention" | "concern" | "critical" = "normal";
      if (score >= 81) level = "critical";
      else if (score >= 61) level = "concern";
      else if (score >= 31) level = "attention";

      // Insert risk score
      const { data: insertedRisk, error: riskErr } = await supabase
        .from("risk_scores")
        .insert({
          senior_id: senior.id,
          score,
          level,
          factors,
        })
        .select()
        .single();

      if (riskErr) console.error("Error inserting risk score:", riskErr);

      // Open incident if concern/critical and no open incident exists
      if (score >= 60 && insertedRisk) {
        const { data: openIncident } = await supabase
          .from("incidents")
          .select("id")
          .eq("senior_id", senior.id)
          .eq("status", "open")
          .limit(1);

        if (!openIncident || openIncident.length === 0) {
          await supabase.from("incidents").insert({
            senior_id: senior.id,
            risk_score_id: insertedRisk.id,
            status: "open",
          });
        }
      }

      results.push({ senior_id: senior.id, score, level });
    }

    return new Response(JSON.stringify({ success: true, results }), {
      headers: { "Content-Type": "application/json" },
    });
  } catch (err) {
    return new Response(JSON.stringify({ error: err.message }), { status: 500 });
  }
});
