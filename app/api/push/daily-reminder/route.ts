import { NextResponse } from "next/server";
import webpush from "web-push";
import { getAllSubscriptions, todayUTC } from "@/lib/push/store";

webpush.setVapidDetails(
  process.env.VAPID_CONTACT!,
  process.env.NEXT_PUBLIC_VAPID_PUBLIC_KEY!,
  process.env.VAPID_PRIVATE_KEY!
);

// Called automatically by Vercel Cron (vercel.json) every day at 20:00 UTC.
// Manual trigger: GET /api/push/daily-reminder?secret=YOUR_CRON_SECRET
export async function GET(request: Request) {
  const { searchParams } = new URL(request.url);
  const secret = searchParams.get("secret");
  const cronSecret = process.env.CRON_SECRET;
  if (cronSecret && secret !== cronSecret) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const allSubs = await getAllSubscriptions();
  if (allSubs.length === 0) {
    return NextResponse.json({ ok: true, sent: 0, skipped: 0, message: "No subscribers" });
  }

  const today = todayUTC();

  // Only notify users who have NOT trained today
  const pending  = allSubs.filter((s) => s.lastSessionDate !== today);
  const skipped  = allSubs.length - pending.length;

  if (pending.length === 0) {
    console.log(`[OLA Push] Everyone trained today — no notifications sent`);
    return NextResponse.json({ ok: true, sent: 0, skipped, message: "All users already trained today" });
  }

  const results = await Promise.allSettled(
    pending.map((s) => {
      const msg = getDailyMessage(s.sourceLang);
      return webpush.sendNotification(
        s.subscription as any,
        JSON.stringify({ title: msg.title, body: msg.body, data: { url: "/home" } })
      );
    })
  );

  const sent   = results.filter((r) => r.status === "fulfilled").length;
  const failed = results.filter((r) => r.status === "rejected").length;

  console.log(`[OLA Push] Daily reminder: ${sent} sent, ${skipped} skipped (already trained), ${failed} failed`);
  return NextResponse.json({ ok: true, sent, skipped, failed });
}

// 7 messages per language, rotated by day of week (0=Sun … 6=Sat)
function getDailyMessage(sourceLang: string): { title: string; body: string } {
  const day = new Date().getDay();
  const lang = normalizeLang(sourceLang);
  return MESSAGES[lang][day];
}

function normalizeLang(sourceLang: string): keyof typeof MESSAGES {
  if (sourceLang.startsWith("pt")) return "pt";
  if (sourceLang.startsWith("es")) return "es";
  if (sourceLang.startsWith("it")) return "it";
  if (sourceLang.startsWith("fr")) return "fr";
  if (sourceLang.startsWith("de")) return "de";
  return "en";
}

const MESSAGES = {
  pt: [
    { title: "OLA 🎯 Hora do treino!",              body: "Você tem 15 minutos? Seu bloco de hoje está esperando." },
    { title: "OLA 🧠 A língua é um músculo",         body: "Músculos que não são usados enfraquecem. Treine agora e mantenha a sequência!" },
    { title: "OLA ⚡ Sprint cognitivo",              body: "15 minutos de treino intenso valem mais do que 2h passivas. Vamos?" },
    { title: "OLA 📈 Você está progredindo",         body: "Cada bloco completo te aproxima da fluência real. Continue o seu ritmo!" },
    { title: "OLA 🗣️ Fale em voz alta",             body: "A diferença entre saber e falar é a prática. Seu treino começa agora." },
    { title: "OLA 🏋️ Treino de fim de semana",      body: "Os grandes atletas treinam nos fins de semana. Seja um atleta cognitivo hoje!" },
    { title: "OLA 🔥 Última chance da semana",       body: "Não deixe a semana passar sem treinar. 15 minutos agora fazem a diferença!" },
  ],
  en: [
    { title: "OLA 🎯 Time to train!",               body: "Got 15 minutes? Today's block is waiting for you." },
    { title: "OLA 🧠 Language is a muscle",          body: "Muscles that aren't used weaken. Train now and keep your streak!" },
    { title: "OLA ⚡ Cognitive sprint",              body: "15 minutes of focused training beats 2 hours of passive study. Let's go!" },
    { title: "OLA 📈 You're making progress",        body: "Every completed block brings you closer to real fluency. Keep your rhythm!" },
    { title: "OLA 🗣️ Speak out loud",               body: "The gap between knowing and speaking is practice. Today's training starts now." },
    { title: "OLA 🏋️ Weekend warrior",              body: "The greats train on weekends too. Be a cognitive athlete today!" },
    { title: "OLA 🔥 Last chance of the week",       body: "Don't let the week end without training. 15 minutes now makes all the difference!" },
  ],
  es: [
    { title: "OLA 🎯 ¡Hora de entrenar!",            body: "¿Tienes 15 minutos? Tu bloque de hoy te está esperando." },
    { title: "OLA 🧠 El idioma es un músculo",        body: "Los músculos que no se usan se debilitan. ¡Entrena ahora y mantén tu racha!" },
    { title: "OLA ⚡ Sprint cognitivo",               body: "15 minutos de entrenamiento intenso valen más que 2h pasivas. ¡Vamos!" },
    { title: "OLA 📈 Estás progresando",              body: "Cada bloque completado te acerca a la fluidez real. ¡Mantén tu ritmo!" },
    { title: "OLA 🗣️ Habla en voz alta",             body: "La diferencia entre saber y hablar es la práctica. Tu entrenamiento empieza ahora." },
    { title: "OLA 🏋️ ¡Entrena este fin de semana!", body: "Los grandes atletas entrenan los fines de semana. ¡Sé un atleta cognitivo hoy!" },
    { title: "OLA 🔥 Última oportunidad de la semana", body: "No dejes que pase la semana sin entrenar. ¡15 minutos ahora marcan la diferencia!" },
  ],
  it: [
    { title: "OLA 🎯 È ora di allenarsi!",            body: "Hai 15 minuti? Il tuo blocco di oggi ti sta aspettando." },
    { title: "OLA 🧠 La lingua è un muscolo",          body: "I muscoli che non vengono usati si indeboliscono. Allenati ora e mantieni la sequenza!" },
    { title: "OLA ⚡ Sprint cognitivo",                body: "15 minuti di allenamento intenso valgono più di 2h passive. Andiamo!" },
    { title: "OLA 📈 Stai progredendo",                body: "Ogni blocco completato ti avvicina alla vera fluenza. Continua con il tuo ritmo!" },
    { title: "OLA 🗣️ Parla ad alta voce",             body: "La differenza tra sapere e parlare è la pratica. Il tuo allenamento inizia adesso." },
    { title: "OLA 🏋️ Allenamento del weekend",        body: "I grandi atleti si allenano nel weekend. Sii un atleta cognitivo oggi!" },
    { title: "OLA 🔥 Ultima possibilità della settimana", body: "Non lasciare che la settimana finisca senza allenarti. 15 minuti ora fanno la differenza!" },
  ],
  fr: [
    { title: "OLA 🎯 C'est l'heure de s'entraîner !", body: "Tu as 15 minutes ? Ton bloc du jour t'attend." },
    { title: "OLA 🧠 La langue est un muscle",          body: "Les muscles qui ne sont pas utilisés s'affaiblissent. Entraîne-toi et garde ta série !" },
    { title: "OLA ⚡ Sprint cognitif",                  body: "15 minutes d'entraînement intense valent mieux que 2h passives. C'est parti !" },
    { title: "OLA 📈 Tu progresses !",                  body: "Chaque bloc complété te rapproche de la vraie fluidité. Continue sur ta lancée !" },
    { title: "OLA 🗣️ Parle à voix haute",              body: "La différence entre savoir et parler, c'est la pratique. Ton entraînement commence maintenant." },
    { title: "OLA 🏋️ Entraînement du week-end",        body: "Les grands athlètes s'entraînent aussi le week-end. Sois un athlète cognitif aujourd'hui !" },
    { title: "OLA 🔥 Dernière chance de la semaine",    body: "Ne laisse pas la semaine se terminer sans t'entraîner. 15 minutes maintenant font toute la différence !" },
  ],
  de: [
    { title: "OLA 🎯 Zeit zum Trainieren!",             body: "Hast du 15 Minuten? Dein heutiger Block wartet auf dich." },
    { title: "OLA 🧠 Sprache ist ein Muskel",            body: "Muskeln, die nicht benutzt werden, schwächen sich ab. Trainiere jetzt und halte deinen Streak!" },
    { title: "OLA ⚡ Kognitiver Sprint",                 body: "15 Minuten intensives Training schlagen 2 Stunden passives Lernen. Los geht's!" },
    { title: "OLA 📈 Du machst Fortschritte",            body: "Jeder abgeschlossene Block bringt dich echter Sprachkompetenz näher. Bleib dran!" },
    { title: "OLA 🗣️ Sprich laut",                     body: "Der Unterschied zwischen Wissen und Sprechen ist Übung. Dein heutiges Training beginnt jetzt." },
    { title: "OLA 🏋️ Wochenend-Training",              body: "Große Athleten trainieren auch am Wochenende. Sei heute ein kognitiver Athlet!" },
    { title: "OLA 🔥 Letzte Chance der Woche",           body: "Lass die Woche nicht ohne Training enden. 15 Minuten jetzt machen den Unterschied!" },
  ],
};
