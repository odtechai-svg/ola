import { NextResponse } from "next/server";

export async function POST(req: Request) {
  try {
    const body = await req.json();
    const { category, message, email, name } = body ?? {};

    if (!message || typeof message !== "string" || message.trim().length === 0) {
      return NextResponse.json(
        { error: "Mensagem é obrigatória." },
        { status: 400 }
      );
    }

    const payload = {
      timestamp: new Date().toISOString(),
      recipient: "contato@odtechai.com",
      project: "OLAlíngua (ola.odtechai.com / olalingua.com)",
      category: category || "geral",
      message: message.trim(),
      email: email ? email.trim() : "Anônimo",
      name: name ? name.trim() : "Usuário OLA",
      userAgent: req.headers.get("user-agent") || "desconhecido",
    };

    // Structured server log for Coolify/Hostinger logs
    console.log("[OLA FEEDBACK RECEIVED]", JSON.stringify(payload, null, 2));

    // Optional webhook or external email dispatch if CONSU_WEBHOOK_URL or SMTP is configured
    if (process.env.FEEDBACK_WEBHOOK_URL) {
      try {
        await fetch(process.env.FEEDBACK_WEBHOOK_URL, {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify(payload),
        });
      } catch (err) {
        console.error("[OLA FEEDBACK WEBHOOK ERROR]", err);
      }
    }

    return NextResponse.json({
      success: true,
      message: "Feedback recebido com sucesso! Obrigado por colaborar.",
    });
  } catch (error: any) {
    console.error("[OLA FEEDBACK API ERROR]", error);
    return NextResponse.json(
      { error: "Erro ao processar o feedback. Tente novamente." },
      { status: 500 }
    );
  }
}
