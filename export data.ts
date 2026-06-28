import "jsr:@supabase/functions-js/edge-runtime.d.ts";

const ISRCTN_BASE_URL = "https://www.isrctn.com";

Deno.serve(async (req: Request) => {
  const url = new URL(req.url);
  const keyword = url.searchParams.get("keyword");
  const limit = url.searchParams.get("limit") ?? "5";

  if (!keyword) {
    return new Response(
      JSON.stringify({ error: "Provide a ?keyword= query parameter" }),
      { status: 400, headers: { "Content-Type": "application/json" } }
    );
  }

  const isrctnUrl =
    `${ISRCTN_BASE_URL}/api/query/format/default?q=${encodeURIComponent(keyword)}&limit=${limit}`;

  try {
    const response = await fetch(isrctnUrl);

    if (!response.ok) {
      throw new Error(`ISRCTN responded with status ${response.status}`);
    }

    const xmlText = await response.text();
    const trials = parseTrialsFromXml(xmlText);

    return new Response(
      JSON.stringify({ keyword, results: trials }),
      { status: 200, headers: { "Content-Type": "application/json" } }
    );
  } catch (error) {
    return new Response(
      JSON.stringify({
        error: "Could not reach ISRCTN API",
        detail: error instanceof Error ? error.message : String(error),
      }),
      { status: 502, headers: { "Content-Type": "application/json" } }
    );
  }
});

/**
 * Very small XML parser for the fields we need: title, ISRCTN ID, status.
 * NOTE: the exact tag names depend on ISRCTN's namespace - the first time
 * you run this for real, console.log(xmlText) to see the actual structure
 * and adjust the regex/tag names below if they don't match.
 */
function parseTrialsFromXml(xmlText: string): Array<{
  title: string | null;
  isrctnId: string | null;
  status: string | null;
}> {
  const trials: Array<{ title: string | null; isrctnId: string | null; status: string | null }> = [];

  const trialBlocks = xmlText.split(/<trial[\s>]/i).slice(1);

  for (const block of trialBlocks) {
    const title = extractTag(block, "title");
    const isrctnId = extractTag(block, "isrctn");
    const status = extractTag(block, "trialStatus");
    trials.push({ title, isrctnId, status });
  }

  return trials;
}

function extractTag(xml: string, tagName: string): string | null {
  const match = xml.match(new RegExp(`<${tagName}>([^<]*)</${tagName}>`, "i"));
  return match ? match[1].trim() : null;
}
