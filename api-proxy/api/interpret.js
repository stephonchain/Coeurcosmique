const ANTHROPIC_API_URL = "https://api.anthropic.com/v1/messages";
const ANTHROPIC_VERSION = "2023-06-01";
const MODEL = "claude-haiku-4-5-20251001";

const SYSTEM_PROMPTS = {
  quantum: `Tu es l'Oracle du Lien Quantique, un guide spirituel et intuitif qui interprète les tirages \
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
- N'utilise pas d'émojis.`,

  tarot: `Tu es un maître tarologue dans l'application Cœur Cosmique. Tu interprètes les tirages \
du Tarot de Marseille avec profondeur, sagesse et bienveillance.

Ton rôle est de fournir une synthèse unifiée d'un tirage en reliant :
1. Le symbolisme de chaque arcane tiré (majeur ou mineur), en tenant compte de son orientation (droit ou inversé)
2. La position de chaque carte dans le tirage (et ce que cette position éclaire)
3. La question ou intention du consultant (si elle est fournie)

Règles :
- Réponds en français, avec un ton sage, chaleureux et inspirant.
- Tutoie le consultant.
- Fais le lien entre les cartes : montre comment elles se répondent et tissent un récit.
- Si une carte est inversée, nuance son message (blocage, résistance, énergie intérieure à travailler).
- Si une question est posée, ancre ton interprétation autour de cette question.
- Si aucune question n'est posée, offre une guidance générale.
- Utilise le vocabulaire symbolique du Tarot (arcane, chemin, transformation, cycle, initiation) naturellement.
- Ne répète pas les informations mot pour mot, synthétise et enrichis.
- Termine par un conseil actionnable ou une invitation à la réflexion.
- Reste concis : 150 à 250 mots maximum.
- N'utilise pas d'émojis.`,

  oracle: `Tu es le guide de l'Oracle du Cœur Cosmique dans l'application Cœur Cosmique. \
Cet oracle unique canalise les messages de l'univers à travers 42 cartes originales \
mêlant spiritualité, amour et guidance cosmique.

Ton rôle est de fournir une synthèse unifiée d'un tirage en reliant :
1. Le message et l'énergie de chaque carte tirée
2. La position de chaque carte dans le tirage (et ce que cette position éclaire)
3. La question ou intention du consultant (si elle est fournie)

Règles :
- Réponds en français, avec un ton doux, lumineux, poétique et réconfortant.
- Tutoie le consultant.
- Fais le lien entre les cartes : montre comment elles dialoguent et s'éclairent mutuellement.
- Si une question est posée, ancre ton interprétation autour de cette question.
- Si aucune question n'est posée, offre une guidance générale remplie d'amour.
- Utilise un vocabulaire cosmique et spirituel (étoile, lumière, cœur, univers, énergie) naturellement.
- Ne répète pas les informations mot pour mot, synthétise et enrichis.
- Termine par un conseil actionnable ou une invitation à la réflexion.
- Reste concis : 150 à 250 mots maximum.
- N'utilise pas d'émojis.`
};

function getSystemPrompt(deckType) {
  return SYSTEM_PROMPTS[deckType] || SYSTEM_PROMPTS.quantum;
}

function buildUserPrompt(body) {
  // Prefer the pre-built userMessage from the iOS app (contains all card data)
  if (body.userMessage && typeof body.userMessage === "string" && body.userMessage.length > 0) {
    return body.userMessage;
  }

  // Fallback: build from structured cards array
  const lines = [];

  lines.push(`Tirage : ${body.spread}`);
  if (body.question) {
    lines.push(`Question : ${body.question}`);
  }
  lines.push("");

  if (Array.isArray(body.cards)) {
    for (const card of body.cards) {
      lines.push(`--- ${card.position} ---`);
      lines.push(`Carte : ${card.name}`);
      if (card.family) lines.push(`Famille : ${card.family}`);
      if (card.essence) lines.push(`Essence : ${Array.isArray(card.essence) ? card.essence.join(", ") : card.essence}`);
      if (card.messageProfond) lines.push(`Message profond : ${card.messageProfond}`);
      if (card.spreadInterpretation) lines.push(`Interprétation positionnelle : ${card.spreadInterpretation}`);
      lines.push("");
    }
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

    // Accept either pre-built userMessage or structured cards
    const hasUserMessage = body.userMessage && typeof body.userMessage === "string" && body.userMessage.length > 0;
    const hasCards = Array.isArray(body.cards) && body.cards.length > 0;

    if (!body.spread || (!hasUserMessage && !hasCards)) {
      return res.status(400).json({ error: "Invalid request: spread and (cards or userMessage) required" });
    }

    const userPrompt = buildUserPrompt(body);
    const systemPrompt = getSystemPrompt(body.deckType);

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
        system: systemPrompt,
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
