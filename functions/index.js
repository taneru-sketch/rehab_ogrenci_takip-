const { onCall, HttpsError } = require("firebase-functions/v2/https");
const { defineString } = require("firebase-functions/params");
const nodemailer = require("nodemailer");

// ============================================================
// Gmail Kimlik Bilgileri
// Firebase Console'da Environment Variables olarak tanımlayın:
//   firebase functions:secrets:set GMAIL_USER
//   firebase functions:secrets:set GMAIL_APP_PASSWORD
// ============================================================
const gmailUser = defineString("GMAIL_USER");
const gmailAppPassword = defineString("GMAIL_APP_PASSWORD");

/**
 * sendMail — Flutter uygulamasından çağrılan Cloud Function
 *
 * Flutter'dan gelen parametreler:
 *   - to: Alıcı e-posta adresi
 *   - subject: Konu
 *   - message: Mesaj içeriği
 */
exports.sendMail = onCall(
  {
    region: "us-central1",
    // Sadece kimlik doğrulanmış kullanıcılar çağırabilir (güvenlik için)
    // Kurum şifresiyle giriş yapan kullanıcılar bu fonksiyonu kullanabilir
    enforceAppCheck: false,
  },
  async (request) => {
    const { to, subject, message } = request.data;

    // ---- Basit Doğrulama ----
    if (!to || !subject || !message) {
      throw new HttpsError(
        "invalid-argument",
        "Alici, konu ve mesaj alanlari zorunludur."
      );
    }

    if (!to.includes("@")) {
      throw new HttpsError(
        "invalid-argument",
        "Gecerli bir e-posta adresi giriniz."
      );
    }

    // ---- Gmail SMTP Transporter oluştur ----
    const transporter = nodemailer.createTransport({
      service: "gmail",
      auth: {
        user: gmailUser.value(),         // Örn: rehab.merkez@gmail.com
        pass: gmailAppPassword.value(),  // Gmail Uygulama Şifresi (App Password)
      },
    });

    // ---- HTML Mail Şablonu ----
    const htmlBody = `
      <!DOCTYPE html>
      <html lang="tr">
      <head><meta charset="UTF-8"></head>
      <body style="font-family: Arial, sans-serif; background: #f1f5f9; padding: 20px;">
        <div style="max-width: 600px; margin: 0 auto; background: white; border-radius: 12px; overflow: hidden; box-shadow: 0 2px 10px rgba(0,0,0,0.1);">
          
          <!-- Başlık -->
          <div style="background: #0284c7; padding: 24px; text-align: center;">
            <h2 style="color: white; margin: 0; font-size: 20px;">
              🏥 RehberÖzel - Özel Eğitim Merkezi
            </h2>
          </div>

          <!-- İçerik -->
          <div style="padding: 28px;">
            <p style="color: #64748b; font-size: 14px; margin-bottom: 16px;">
              Sayın ilgili,
            </p>
            <div style="background: #f8fafc; border-left: 4px solid #0284c7; padding: 16px; border-radius: 0 8px 8px 0; margin-bottom: 24px;">
              <p style="color: #1e293b; font-size: 15px; line-height: 1.6; margin: 0; white-space: pre-line;">
                ${message}
              </p>
            </div>
            <p style="color: #94a3b8; font-size: 12px;">
              Bu mail, RehberÖzel Öğrenci Bilgi Sistemi üzerinden otomatik olarak gönderilmiştir.
            </p>
          </div>

          <!-- Footer -->
          <div style="background: #f1f5f9; padding: 16px; text-align: center;">
            <p style="color: #94a3b8; font-size: 11px; margin: 0;">
              RehberÖzel © ${new Date().getFullYear()} | Özel Eğitim ve Rehabilitasyon Yönetim Sistemi
            </p>
          </div>
        </div>
      </body>
      </html>
    `;

    const mailOptions = {
      from: `"RehberÖzel Merkezi" <${gmailUser.value()}>`,
      to: to,
      subject: `[RehberÖzel] ${subject}`,
      text: message,  // Düz metin yedek
      html: htmlBody, // HTML sürüm
    };

    try {
      await transporter.sendMail(mailOptions);
      console.log(`Mail gonderildi: ${to} | Konu: ${subject}`);
      return { success: true, message: "Mail basariyla gonderildi." };
    } catch (error) {
      console.error("Mail gonderilemedi:", error);
      throw new HttpsError("internal", `Mail gonderilemedi: ${error.message}`);
    }
  }
);
