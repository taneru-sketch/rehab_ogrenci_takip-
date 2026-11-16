# RehberÖzel - Özel Eğitim & Rehabilitasyon Öğrenci Bilgi Havuzu

Özel eğitim ve rehabilitasyon merkezlerinde, farklı öğretmen ve terapistlerin girdiği seanslarda öğrencinin hayati ve gelişimsel özelliklerini (sağlık, şeker/gıda hassasiyeti, tuvalet eğitimi, okul, ilaçlar vb.) anında görebileceği, Google Play için optimize edilmiş ve Google AdMob reklam alanı içeren Flutter mobil uygulaması.

---

## 🎯 Çözülen Problem
Rehabilitasyon merkezlerinde bir çocuğun seansına farklı günlerde fizyoterapist, özel eğitim öğretmeni, dil terapisti veya nöbetçi öğretmenler girebilir. Çocukla ilk kez derse giren bir öğretmen; öğrencinin şeker yiyip yiyemeyeceğini, tuvalet eğitiminin olup olmadığını, kriz anında neyin sakinleştireceğini bilmeyebilir. Özel gereksinimli çocuklar bunu her zaman kendileri ifade edemez.

**RehberÖzel**, tüm eğitimcilerin seansa girmeden önce 10 saniye içinde öğrencinin en kritik ihtiyaçlarını görmesini ve seans sonrasında ortak havuza gözlem notu eklemesini sağlar.

---

## 🔑 Giriş Sistemi (Kurum Kodu + Çift Şifre)

Her merkez tek bir **Kurum Kodu** ile çalışır. Bireysel e-posta kaydı gerektirmez:

| Rol | Giriş Bilgisi | Yetkiler |
| :--- | :--- | :--- |
| **Eğitimci / Öğretmen** | Kurum Kodu + Ortak Öğretmen Şifresi (`123`) | Öğrenci listesini ve kritik kartları inceleme, seans notu ekleme. |
| **Yönetici (Admin)** | Kurum Kodu + Yönetici Şifresi (`admin`) | Yeni öğrenci ekleme, düzenleme, silme ve kurum şifrelerini değiştirme. |

> **Test Giriş Bilgileri:**  
> • **Kurum Kodu:** `REHAB01`  
> • **Eğitimci Şifresi:** `123`  
> • **Yönetici Şifresi:** `admin`

---

## 📱 Ekranlar ve Kritik Kartlar

1. **🚨 Kritik Sağlık & Şeker Kartı:** Şeker tüketim kuralı, alerjiler, epilepsi vb. kronik durumlar ve acil telefon.
2. **🚻 Tuvalet & Özbakım:** Tuvalet eğitimi durumu (Bağımsız / Destekli / Bez), ihtiyacı nasıl belirttiği (Sözel, PECS kartı, hareket).
3. **💊 İlaç Takip Kartı:** Düzenli kullanılan ilaçlar ve saatleri.
4. **🏫 Okul & RAM Bilgisi:** Okula gidiyor mu, sınıfı (Kaynaştırma/Özel Eğitim), RAM raporu bitiş tarihi.
5. **🗣️ İletişim & Sakinleştirme Yöntemleri:** Kriz anında ne sakinleştirir? Tetikleyiciler ve sevdiği pekiştireçler.
6. **📝 Eğitimci Ortak Not Havuzu:** Tarihli ve öğretmen isimli seans gözlemleri.
7. **📢 Sabit AdMob Reklam Alanı:** Ekranın altında sabit Google Ads banner alanı.

---

## 🚀 APK Nasıl Derlenir?

### Yöntem A: Bulutta Otomatik APK Üretme (En Kolay Yol - Kurulum Gerektirmez)
Projeye hazır eklenen `.github/workflows/build_apk.yml` sayesinde:
1. Bu proje klasörünü bir GitHub deposuna yükleyin (push edin).
2. GitHub Actions birkaç dakika içinde otomatik olarak `app-release.apk` dosyasını derler.
3. GitHub Actions sekmesinden doğrudan telefonunuza indirip kurabilirsiniz.

### Yöntem B: Bilgisayarınızda Yerel Olarak Derleme
Bilgisayarınızda Flutter ve Android SDK kuruluysa terminalden proje dizininde şu komutları çalıştırın:

```bash
cd rehab_ogrenci_takip
flutter pub get
flutter build apk --release
```
Derlenen dosya konumu: `build/app/outputs/flutter-apk/app-release.apk`

---

## 🏪 Google Play Store Yayın Hazırlığı

Google Play Store'a yüklerken APK yerine `.aab` (Android App Bundle) formatı istenir:

```bash
flutter build appbundle --release
```
Dosya konumu: `build/app/outputs/bundle/release/app-release.aab`

**Yayından Önce:**
1. `android/app/src/main/AndroidManifest.xml` içindeki `APPLICATION_ID` değerini kendi Google AdMob hesabınızdan aldığınız gerçek Uygulama Kimliği ile değiştiriniz.
2. `lib/services/admob_service.dart` içindeki test banner kimliğini gerçek Banner Reklam Birimi Kimliğiniz ile değiştiriniz.
