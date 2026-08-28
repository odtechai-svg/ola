import { NextResponse } from "next/server";
import nodemailer from "nodemailer";

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

    const senderEmail = email ? email.trim() : "Anônimo (via OLA)";
    const senderName = name ? name.trim() : "Usuário OLA";
    const feedbackCategory = category || "geral";
    const categoryLabels: Record<string, string> = {
      bug: "🐛 Reportar Bug",
      suggestion: "💡 Sugestão",
      opinion: "💬 Opinião",
      feature: "🚀 Nova Função",
    };

    const formattedCategory = categoryLabels[feedbackCategory] || feedbackCategory;

    const payload = {
      timestamp: new Date().toLocaleString("pt-BR", { timeZone: "America/Sao_Paulo" }),
      recipients: ["contato@odtechai.com", "max@odtechai.com"],
      category: formattedCategory,
      message: message.trim(),
      email: senderEmail,
      name: senderName,
      userAgent: req.headers.get("user-agent") || "desconhecido",
    };

    // Structured server log for Coolify/Hostinger logs
    console.log("[OLA FEEDBACK RECEIVED]", JSON.stringify(payload, null, 2));

    // SMTP credentials from environment
    const smtpHost = process.env.SMTP_HOST || "smtp.hostinger.com";
    const smtpPort = Number(process.env.SMTP_PORT) || 465;
    const smtpUser = process.env.SMTP_USER || process.env.EMAIL_USER || "contato@odtechai.com";
    const smtpPass = process.env.SMTP_PASS || process.env.EMAIL_PASS || process.env.HOSTINGER_EMAIL_PASS;
    const recipients = process.env.SMTP_TO || "contato@odtechai.com, max@odtechai.com";

    if (smtpPass) {
      const transporter = nodemailer.createTransport({
        host: smtpHost,
        port: smtpPort,
        secure: smtpPort === 465, // true for 465, false for other ports
        auth: {
          user: smtpUser,
          pass: smtpPass,
        },
      });

      const emailHtml = `
        <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; background-color: #0b132b; color: #f1f5f9; padding: 30px; border-radius: 16px;">
          <h2 style="color: #38bdf8; margin-top: 0;">🎉 Novo Feedback Recebido — OLA</h2>
          <p style="color: #94a3b8; font-size: 14px;"><strong>Data/Hora:</strong> ${payload.timestamp}</p>
          
          <div style="background-color: #1e293b; padding: 20px; border-radius: 12px; margin: 20px 0; border: 1px solid #334155;">
            <p style="margin: 0 0 10px 0;"><strong>Categoria:</strong> <span style="color: #38bdf8; background: rgba(56, 189, 248, 0.1); padding: 4px 10px; border-radius: 20px;">${formattedCategory}</span></p>
            <p style="margin: 10px 0;"><strong>De:</strong> ${senderName} (&lt;${senderEmail}&gt;)</p>
            <hr style="border: 0; border-top: 1px solid #334155; margin: 15px 0;" />
            <p style="margin: 0; font-size: 16px; line-height: 1.6; white-space: pre-wrap;">${message.trim()}</p>
          </div>

          <p style="font-size: 12px; color: #64748b; margin-bottom: 0;">
            Mensagem enviada automaticamente pelo formulário de suporte do OLA (olalingua.com / ola.odtechai.com).
          </p>
        </div>
      `;

      await transporter.sendMail({
        from: `"OLA Feedback" <${smtpUser}>`,
        to: recipients,
        replyTo: senderEmail.includes("@") ? senderEmail : smtpUser,
        subject: `[OLA Feedback] ${formattedCategory} - de ${senderName}`,
        html: emailHtml,
        text: `Novo Feedback OLA\nCategoria: ${formattedCategory}\nDe: ${senderName} (${senderEmail})\nData: ${payload.timestamp}\n\nMensagem:\n${message.trim()}`,
      });

      console.log("[OLA FEEDBACK EMAIL SENT] Email enviado com sucesso para:", recipients);
    } else {
      console.warn("[OLA FEEDBACK EMAIL NOTICE] Nenhuma senha de SMTP (SMTP_PASS) configurada no .env.local/Coolify. O feedback foi registrado em log.");
    }

    // Optional webhook support if configured
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
