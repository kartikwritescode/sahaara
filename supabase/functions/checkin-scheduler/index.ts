/**
 * Trigger: Scheduled via pg_cron (e.g. hourly or at senior configured routine times)
 * Purpose: Generates pending check_ins records for seniors according to their configured routine times.
 */

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.38.0";

const SUPABASE_URL = Deno.env.get("SUPABASE_URL") ?? "";
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "";

serve(async (req) => {
  const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);

  try {
    const { data: seniors, error: seniorErr } = await supabase.from("senior_profiles").select("id");
    if (seniorErr) throw seniorErr;

    const scheduled = [];
    const now = new Date();

    for (const senior of seniors || []) {
      const { data: checkin, error: checkinErr } = await supabase
        .from("check_ins")
        .insert({
          senior_id: senior.id,
          scheduled_time: now.toISOString(),
          response: "no_response",
        })
        .select()
        .single();

      if (!checkinErr && checkin) {
        scheduled.push(checkin);
      }
    }

    return new Response(JSON.stringify({ success: true, count: scheduled.length }), {
      headers: { "Content-Type": "application/json" },
    });
  } catch (err) {
    return new Response(JSON.stringify({ error: err.message }), { status: 500 });
  }
});
