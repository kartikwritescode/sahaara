/**
 * Trigger: DB Trigger on `incidents` table insert
 * Purpose: Assembles contributing signals and calls Gemini/Claude LLM API to generate a natural-language
 * incident summary for caregiver notifications.
 */

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.38.0";

const SUPABASE_URL = Deno.env.get("SUPABASE_URL") ?? "";
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "";
// TODO: wire up LLM API key (GEMINI_API_KEY or ANTHROPIC_API_KEY)
const GEMINI_API_KEY = Deno.env.get("GEMINI_API_KEY") ?? "";

serve(async (req) => {
  const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);

  try {
    const payload = await req.json();
    const incident = payload.record;

    if (!incident || !incident.id) {
      return new Response(JSON.stringify({ error: "No incident record found in payload" }), { status: 400 });
    }

    // Fetch risk score details
    let summaryText = "Incident detected: Senior elevated risk level triggered automatic verification.";

    if (incident.risk_score_id) {
      const { data: risk } = await supabase
        .from("risk_scores")
        .select("*")
        .eq("id", incident.risk_score_id)
        .maybeSingle();

      if (risk) {
        const factorSummary = (risk.factors || []).map((f: any) => f.label).join(", ");
        summaryText = `Elevated Risk Score ${risk.score}/100 (${risk.level.toUpperCase()}). Contributing factors: ${factorSummary || "Unusual pattern"}. Recommended immediate caregiver verification.`;
      }
    }

    // If Gemini key is set, call Gemini API
    if (GEMINI_API_KEY) {
      try {
        const geminiRes = await fetch(
          `https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=${GEMINI_API_KEY}`,
          {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({
              contents: [
                {
                  parts: [
                    {
                      text: `Summarize this elderly safety incident for a family caregiver in 2 concise sentences: ${summaryText}`,
                    },
                  ],
                },
              ],
            }),
          }
        );
        const geminiData = await geminiRes.json();
        const generated = geminiData.candidates?.[0]?.content?.parts?.[0]?.text;
        if (generated) summaryText = generated.trim();
      } catch (llmErr) {
        console.error("Gemini API call failed, falling back to rule summary:", llmErr);
      }
    }

    // Update incident record with AI summary
    await supabase.from("incidents").update({ ai_summary: summaryText }).eq("id", incident.id);

    return new Response(JSON.stringify({ success: true, ai_summary: summaryText }), {
      headers: { "Content-Type": "application/json" },
    });
  } catch (err) {
    return new Response(JSON.stringify({ error: err.message }), { status: 500 });
  }
});
