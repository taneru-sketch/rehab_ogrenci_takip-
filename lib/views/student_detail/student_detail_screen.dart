import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/student_model.dart';
import '../../services/app_state.dart';
import '../../widgets/ad_banner_widget.dart';
import '../admin/student_form_screen.dart';
import 'add_note_dialog.dart';

class StudentDetailScreen extends StatelessWidget {
  final String studentId;

  const StudentDetailScreen({super.key, required this.studentId});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final student = appState.getStudentById(studentId);

    if (student == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Ogrenci Bulunamadi')),
        body: const Center(child: Text('Bu ogrenci kaydi silinmis olabilir.')),
      );
    }

    final dateFormat = DateFormat('dd.MM.yyyy');

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: Text(
          student.fullName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          if (appState.isAdmin)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              tooltip: 'Ogrenciyi Duzenle',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => StudentFormScreen(studentToEdit: student),
                  ),
                );
              },
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. ÖĞRENCİ BAŞLIK BİLGİ KARTI
                  _buildHeaderCard(context, student, dateFormat),
                  const SizedBox(height: 12),

                  // 2. 🚨 KRİTİK SAĞLIK & ŞEKER UYARI KARTI (En Üstte - Kırmızı Vurgulu)
                  _buildHealthCriticalCard(context, student.health),
                  const SizedBox(height: 12),

                  // 3. 🚻 TUVALET VE ÖZBAKIM KARTI (Mavi Vurgulu)
                  _buildToiletCard(context, student.toilet),
                  const SizedBox(height: 12),

                  // 4. 💊 DÜZENLİ İLAÇ TAKİBİ (Yeşil/Teal Vurgulu)
                  _buildMedicationCard(context, student.health.medications),
                  const SizedBox(height: 12),

                  // 5. 🏫 OKUL VE RAM DURUMU (Mor Vurgulu)
                  _buildSchoolCard(context, student.school),
                  const SizedBox(height: 12),

                  // 6. 🗣️ İLETİŞİM & SAKİNLEŞTİRME YÖNTEMLERİ (Sarı/Amber Vurgulu)
                  _buildBehaviorCard(context, student.behavior),
                  const SizedBox(height: 16),

                  // 7. 📝 EĞİTİMCİ ORTAK GÖZLEM & SEANS NOTLARI
                  _buildObservationNotesSection(context, student),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Sabit Google Ads Banner Reklamı
          const AdBannerWidget(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => AddNoteDialog(studentId: student.id),
          );
        },
        icon: const Icon(Icons.add_comment_rounded),
        label: const Text('Seans Notu Ekle'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
    );
  }

  // --- KART 1: ÖĞRENCİ KİMLİK KARTI ---
  Widget _buildHeaderCard(
      BuildContext context, Student student, DateFormat dateFormat) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blue.shade100,
              child: Text(
                student.fullName.isNotEmpty
                    ? student.fullName.substring(0, 1).toUpperCase()
                    : '?',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    student.fullName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      student.diagnosis,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue.shade900,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${student.age} Yas (D.Tarihi: ${dateFormat.format(student.birthDate)})',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- KART 2: 🚨 KRİTİK SAĞLIK VE ŞEKER HASSASİYETİ ---
  Widget _buildHealthCriticalCard(BuildContext context, HealthInfo health) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: health.hasSugarRestriction
              ? Colors.red.shade400
              : Colors.orange.shade300,
          width: 1.5,
        ),
      ),
      color: health.hasSugarRestriction
          ? const Color(0xFFFFF1F2)
          : const Color(0xFFFFFBEB),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: health.hasSugarRestriction
                      ? Colors.red.shade700
                      : Colors.orange.shade800,
                  size: 22,
                ),
                const SizedBox(width: 8),
                Text(
                  'KRITIK SAGLIK & SEKER DURUMU',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                    color: health.hasSugarRestriction
                        ? Colors.red.shade900
                        : Colors.orange.shade900,
                  ),
                ),
              ],
            ),
            const Divider(height: 20),

            // Şeker Durumu
            _buildDetailRow(
              title: 'Seker Hassasiyeti / Durumu:',
              value: health.sugarTolerance.isNotEmpty
                  ? health.sugarTolerance
                  : 'Belirtilmemis',
              valueColor: health.hasSugarRestriction
                  ? Colors.red.shade900
                  : Colors.black87,
              isBold: true,
            ),
            const SizedBox(height: 8),

            // Alerjiler
            _buildDetailRow(
              title: 'Alerjiler:',
              value: health.allergies.isNotEmpty
                  ? health.allergies.join(', ')
                  : 'Bilinen bir alerjisi yok',
              valueColor: health.allergies.isNotEmpty
                  ? Colors.red.shade800
                  : Colors.grey.shade700,
            ),
            const SizedBox(height: 8),

            // Kronik Rahatsızlık (Epilepsi vb.)
            _buildDetailRow(
              title: 'Kronik Durumlar / Nobet Gecmisi:',
              value: health.chronicConditions.isNotEmpty
                  ? health.chronicConditions
                  : 'Yok',
            ),
            const SizedBox(height: 8),

            // Acil Durum İletişimi
            _buildDetailRow(
              title: 'Acil Durumda Aranacak Kisi:',
              value: health.emergencyContact.isNotEmpty
                  ? health.emergencyContact
                  : 'Belirtilmemis',
              isBold: true,
            ),
          ],
        ),
      ),
    );
  }

  // --- KART 3: 🚻 TUVALET VE ÖZBAKIM DURUMU ---
  Widget _buildToiletCard(BuildContext context, ToiletInfo toilet) {
    Color statusColor;
    IconData statusIcon;

    switch (toilet.status) {
      case ToiletStatus.independent:
        statusColor = Colors.green.shade700;
        statusIcon = Icons.check_circle_outline_rounded;
        break;
      case ToiletStatus.withAssistance:
        statusColor = Colors.orange.shade700;
        statusIcon = Icons.help_outline_rounded;
        break;
      case ToiletStatus.diaper:
        statusColor = Colors.blue.shade700;
        statusIcon = Icons.baby_changing_station_rounded;
        break;
    }

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.wc_rounded, color: Colors.blue.shade700, size: 22),
                const SizedBox(width: 8),
                const Text(
                  'Tuvalet & Ozbakim Durumu',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            Row(
              children: [
                Icon(statusIcon, color: statusColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Egitim Durumu: ',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700),
                ),
                Text(
                  toilet.status.label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildDetailRow(
              title: 'Ihtiyacini Nasil Belirtir?:',
              value: toilet.communicationMethod.isNotEmpty
                  ? toilet.communicationMethod
                  : 'Belirtilmemis',
            ),
            if (toilet.notes.isNotEmpty) ...[
              const SizedBox(height: 8),
              _buildDetailRow(
                title: 'Egitimci Notu:',
                value: toilet.notes,
              ),
            ],
          ],
        ),
      ),
    );
  }

  // --- KART 4: 💊 İLAÇ TAKİBİ ---
  Widget _buildMedicationCard(
      BuildContext context, List<Medication> medications) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.medication_liquid_rounded,
                    color: Colors.teal.shade700, size: 22),
                const SizedBox(width: 8),
                const Text(
                  'Duzenli Kullanilan Ilaclar',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            if (medications.isEmpty)
              Text(
                'Kayitli duzenli ilac bulunmamaktadir.',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              )
            else
              ...medications.map(
                (med) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.teal.shade100),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check, size: 16, color: Colors.teal.shade800),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${med.name} (${med.dosage})',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal.shade900,
                          ),
                        ),
                      ),
                      Text(
                        med.time,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.teal.shade800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // --- KART 5: 🏫 OKUL VE RAM BİLGİSİ ---
  Widget _buildSchoolCard(BuildContext context, SchoolInfo school) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.school_rounded,
                    color: Colors.purple.shade700, size: 22),
                const SizedBox(width: 8),
                const Text(
                  'Okul & RAM Rapor Bilgisi',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            _buildDetailRow(
              title: 'Okula Gidiyor mu?:',
              value: school.attendsSchool ? 'Evet' : 'Hayir (Okula gitmiyor)',
              valueColor: school.attendsSchool
                  ? Colors.purple.shade900
                  : Colors.grey.shade700,
              isBold: true,
            ),
            if (school.attendsSchool) ...[
              const SizedBox(height: 8),
              _buildDetailRow(
                title: 'Okul Adi:',
                value: school.schoolName,
              ),
              const SizedBox(height: 8),
              _buildDetailRow(
                title: 'Sinif / Kademe:',
                value: school.grade,
              ),
            ],
            const SizedBox(height: 8),
            _buildDetailRow(
              title: 'RAM Rapor Bitis Tarihi:',
              value: school.ramReportExpiry.isNotEmpty
                  ? school.ramReportExpiry
                  : 'Belirtilmemis',
            ),
          ],
        ),
      ),
    );
  }

  // --- KART 6: 🗣️ İLETİŞİM & SAKİNLEŞTİRME YÖNTEMLERİ ---
  Widget _buildBehaviorCard(BuildContext context, BehaviorInfo behavior) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.psychology_rounded,
                    color: Colors.amber.shade800, size: 22),
                const SizedBox(width: 8),
                const Text(
                  'Iletisim & Sakinlestirme Yontemleri',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            _buildDetailRow(
              title: 'Konusma Duzeyi:',
              value: behavior.verbalLevel,
            ),
            const SizedBox(height: 8),
            _buildDetailRow(
              title: 'Kriz / Ofke Tetikleyicileri (Dikkat!):',
              value: behavior.triggers,
              valueColor: Colors.red.shade800,
            ),
            const SizedBox(height: 8),
            _buildDetailRow(
              title: 'Ne Sakinlestirir? (Yontemler):',
              value: behavior.calmingTechniques,
              valueColor: Colors.green.shade800,
              isBold: true,
            ),
            const SizedBox(height: 8),
            _buildDetailRow(
              title: 'Sevdigi Seyler & Pekistirecler:',
              value: behavior.rewards,
            ),
          ],
        ),
      ),
    );
  }

  // --- KART 7: 📝 EĞİTİMCİ ORTAK GÖZLEM NOTLARI ---
  Widget _buildObservationNotesSection(BuildContext context, Student student) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.speaker_notes_rounded,
                        color: Colors.blueGrey.shade700, size: 22),
                    const SizedBox(width: 8),
                    const Text(
                      'Egitimci Ortak Not Havuzu',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
                Text(
                  '${student.notes.length} Not',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
            const Divider(height: 20),
            if (student.notes.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Center(
                  child: Text(
                    'Henuz bir seans notu eklenmemis.\nAsagidaki butondan ilk notu siz ekleyebilirsiniz.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                  ),
                ),
              )
            else
              ...student.notes.map(
                (note) => Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            note.authorName,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          Text(
                            note.formattedDate,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        note.note,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade800,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required String title,
    required String value,
    Color? valueColor,
    bool isBold = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: valueColor ?? const Color(0xFF1E293B),
            height: 1.3,
          ),
        ),
      ],
    );
  }
}
