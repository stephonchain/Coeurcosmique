const ANTHROPIC_API_URL = "https://api.anthropic.com/v1/messages";
const ANTHROPIC_VERSION = "2023-06-01";
const MODEL = "claude-haiku-4-5-20251001";

const SYSTEM_PROMPT = `Tu es l'Oracle du Lien Quantique, un guide spirituel et intuitif qui interprète les tirages \
de l'Oracle de l'Intrication Quantique dans l'application Cœur Cosmique.

Ton rôle est de fournir une synthèse unifiée d'un tirage en reliant :
1. Le sens profond de chaque carte tirée
2. La position de chaque carte dans le tirage (et ce que cette position représente)
3. La question ou intention du consultant (si elle est fournie)

Règles :
- Réponds en français, avec un ton bienveillant, poétique mais accessible.
- Tutoie le consultant.
- Fais le lien entre les cartes : montre comment elles dialoguent entre elles.
- Si une question est posée, ancre ton interprétation autour de cette question.
- Si aucune question n'est posée, offre une guidance générale.
- Utilise le vocabulaire quantique (intrication, superposition, fréquence, vibration, observateur) \
naturellement, sans forcer.
- Ne répète pas les informations mot pour mot, synthétise et enrichis.
- Termine par un conseil actionnable ou une invitation à la réflexion.
- Reste concis : 150 à 250 mots maximum.
- N'utilise pas d'émojis.`;

function buildUserPrompt(body) {
  const lines = [];

  lines.push(`Tirage : ${body.spread}`);
  if (body.question) {
    lines.push(`Question : ${body.question}`);
  }
  lines.push("");

  for (const card of body.cards) {
    lines.push(`--- ${card.position} ---`);
    lines.push(`Carte : ${card.name}`);
    lines.push(`Famille : ${card.family}`);
    lines.push(`Essence : ${card.essence.join(", ")}`);
    lines.push(`Message profond : ${card.messageProfond}`);
    lines.push(`Interprétation positionnelle : ${card.spreadInterpretation}`);
    lines.push("");
  }

  lines.push("Fournis une synthèse unifiée de ce tirage.");
  return lines.join("\n");
}

export default async function handler(req, res) {
  // CORS preflight
  if (req.method === "OPTIONS") {
    return res.status(200).end();
  }

  if (req.method !== "POST") {
    return res.status(405).json({ error: "Method not allowed" });
  }

  // Validate bearer token
  const authHeader = req.headers.authorization;
  const expectedToken = process.env.APP_SECRET_TOKEN;
  if (expectedToken && authHeader !== `Bearer ${expectedToken}`) {
    return res.status(401).json({ error: "Unauthorized" });
  }

  const apiKey = process.env.ANTHROPIC_API_KEY;
  if (!apiKey) {
    return res.status(500).json({ error: "API key not configured" });
  }

  try {
    const body = req.body;

    if (!body.spread || !Array.isArray(body.cards) || body.cards.length === 0) {
      return res.status(400).json({ error: "Invalid request: spread and cards required" });
    }

    const userPrompt = buildUserPrompt(body);

    const anthropicResponse = await fetch(ANTHROPIC_API_URL, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "x-api-key": apiKey,
        "anthropic-version": ANTHROPIC_VERSION,
      },
      body: JSON.stringify({
        model: MODEL,
        max_tokens: 1024,
        system: SYSTEM_PROMPT,
        messages: [{ role: "user", content: userPrompt }],
      }),
    });

    if (!anthropicResponse.ok) {
      const errorText = await anthropicResponse.text();
      console.error("Anthropic API error:", anthropicResponse.status, errorText);
      return res.status(502).json({ error: "AI service error" });
    }

    const data = await anthropicResponse.json();
    const textBlock = data.content?.find((b) => b.type === "text");

    if (!textBlock?.text) {
      return res.status(502).json({ error: "Empty AI response" });
    }

    return res.status(200).json({ interpretation: textBlock.text });
  } catch (err) {
    console.error("Proxy error:", err);
    return res.status(500).json({ error: "Internal server error" });
  }
}
