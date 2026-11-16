import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../models/student_model.dart';
import '../../services/app_state.dart';

class StudentFormScreen extends StatefulWidget {
  final Student? studentToEdit;

  const StudentFormScreen({super.key, this.studentToEdit});

  @override
  State<StudentFormScreen> createState() => _StudentFormScreenState();
}

class _StudentFormScreenState extends State<StudentFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _fullNameController;
  late TextEditingController _diagnosisController;
  late DateTime _birthDate;

  // Sağlık
  late TextEditingController _sugarToleranceController;
  late bool _hasSugarRestriction;
  late TextEditingController _allergiesController;
  late TextEditingController _chronicConditionsController;
  late TextEditingController _emergencyContactController;

  // Tuvalet
  late ToiletStatus _toiletStatus;
  late TextEditingController _toiletCommMethodController;
  late TextEditingController _toiletNotesController;

  // Okul
  late bool _attendsSchool;
  late TextEditingController _schoolNameController;
  late TextEditingController _gradeController;
  late TextEditingController _ramReportExpiryController;

  // Davranış
  late TextEditingController _verbalLevelController;
  late TextEditingController _triggersController;
  late TextEditingController _calmingTechniquesController;
  late TextEditingController _rewardsController;

  bool get isEditing => widget.studentToEdit != null;

  @override
  void initState() {
    super.initState();
    final s = widget.studentToEdit;

    _fullNameController = TextEditingController(text: s?.fullName ?? '');
    _diagnosisController = TextEditingController(text: s?.diagnosis ?? 'Otizm Spektrum Bozuklugu');
    _birthDate = s?.birthDate ?? DateTime(2018, 1, 1);

    _sugarToleranceController =
        TextEditingController(text: s?.health.sugarTolerance ?? '');
    _hasSugarRestriction = s?.health.hasSugarRestriction ?? true;
    _allergiesController =
        TextEditingController(text: s?.health.allergies.join(', ') ?? '');
    _chronicConditionsController =
        TextEditingController(text: s?.health.chronicConditions ?? '');
    _emergencyContactController =
        TextEditingController(text: s?.health.emergencyContact ?? '');

    _toiletStatus = s?.toilet.status ?? ToiletStatus.withAssistance;
    _toiletCommMethodController =
        TextEditingController(text: s?.toilet.communicationMethod ?? '');
    _toiletNotesController =
        TextEditingController(text: s?.toilet.notes ?? '');

    _attendsSchool = s?.school.attendsSchool ?? true;
    _schoolNameController =
        TextEditingController(text: s?.school.schoolName ?? '');
    _gradeController = TextEditingController(text: s?.school.grade ?? '');
    _ramReportExpiryController =
        TextEditingController(text: s?.school.ramReportExpiry ?? '30.06.2027');

    _verbalLevelController =
        TextEditingController(text: s?.behavior.verbalLevel ?? '');
    _triggersController =
        TextEditingController(text: s?.behavior.triggers ?? '');
    _calmingTechniquesController =
        TextEditingController(text: s?.behavior.calmingTechniques ?? '');
    _rewardsController =
        TextEditingController(text: s?.behavior.rewards ?? '');
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _diagnosisController.dispose();
    _sugarToleranceController.dispose();
    _allergiesController.dispose();
    _chronicConditionsController.dispose();
    _emergencyContactController.dispose();
    _toiletCommMethodController.dispose();
    _toiletNotesController.dispose();
    _schoolNameController.dispose();
    _gradeController.dispose();
    _ramReportExpiryController.dispose();
    _verbalLevelController.dispose();
    _triggersController.dispose();
    _calmingTechniquesController.dispose();
    _rewardsController.dispose();
    super.dispose();
  }

  void _saveStudent() {
    if (_formKey.currentState!.validate()) {
      final appState = Provider.of<AppState>(context, listen: false);

      final allergiesList = _allergiesController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      final student = Student(
        id: widget.studentToEdit?.id ?? const Uuid().v4(),
        institutionCode: appState.institution.institutionCode,
        fullName: _fullNameController.text.trim(),
        birthDate: _birthDate,
        diagnosis: _diagnosisController.text.trim(),
        health: HealthInfo(
          sugarTolerance: _sugarToleranceController.text.trim(),
          hasSugarRestriction: _hasSugarRestriction,
          allergies: allergiesList,
          chronicConditions: _chronicConditionsController.text.trim(),
          emergencyContact: _emergencyContactController.text.trim(),
          medications: widget.studentToEdit?.health.medications ?? [],
        ),
        toilet: ToiletInfo(
          status: _toiletStatus,
          communicationMethod: _toiletCommMethodController.text.trim(),
          notes: _toiletNotesController.text.trim(),
        ),
        school: SchoolInfo(
          attendsSchool: _attendsSchool,
          schoolName: _schoolNameController.text.trim(),
          grade: _gradeController.text.trim(),
          ramReportExpiry: _ramReportExpiryController.text.trim(),
        ),
        behavior: BehaviorInfo(
          verbalLevel: _verbalLevelController.text.trim(),
          triggers: _triggersController.text.trim(),
          calmingTechniques: _calmingTechniquesController.text.trim(),
          rewards: _rewardsController.text.trim(),
        ),
        notes: widget.studentToEdit?.notes ?? [],
      );

      if (isEditing) {
        appState.updateStudent(student);
      } else {
        appState.addStudent(student);
      }

      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEditing
                ? 'Ogrenci bilgileri guncellendi.'
                : 'Yeni ogrenci basariyla eklendi.',
          ),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ogrenciyi Sil'),
        content: Text(
          '${widget.studentToEdit!.fullName} isimli ogrencinin kaydini silmek istediginize emin misiniz? Bu islem geri alinamaz.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Iptal'),
          ),
          ElevatedButton(
            onPressed: () {
              final appState = Provider.of<AppState>(context, listen: false);
              appState.deleteStudent(widget.studentToEdit!.id);
              Navigator.of(ctx).pop();
              Navigator.of(context).pop(); // Formdan çık
              Navigator.of(context).pop(); // Detaydan da çık
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Ogrenci kaydi silindi.'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Sil', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(isEditing ? 'Ogrenciyi Duzenle' : 'Yeni Ogrenci Ekle'),
        actions: [
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              tooltip: 'Ogrenciyi Sil',
              onPressed: _confirmDelete,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. TEMEL BİLGİLER
              _buildSectionTitle('1. Temel Bilgiler', Icons.person_rounded),
              _buildTextField(
                controller: _fullNameController,
                label: 'Ogrenci Ad Soyad',
                required: true,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _diagnosisController,
                label: 'Tani / Engel Grubu (Orn: Otizm, Down Sendromu)',
                required: true,
              ),
              const SizedBox(height: 12),
              ListTile(
                tileColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
                leading: const Icon(Icons.cake_rounded, color: Colors.blue),
                title: const Text('Dogum Tarihi', style: TextStyle(fontSize: 13)),
                subtitle: Text(
                  DateFormat('dd.MM.yyyy').format(_birthDate),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: const Icon(Icons.edit_calendar_rounded),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _birthDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setState(() => _birthDate = picked);
                  }
                },
              ),
              const SizedBox(height: 20),

              // 2. 🚨 SAĞLIK & ŞEKER HASSASİYETİ
              _buildSectionTitle(
                  '2. Kritik Saglik & Seker', Icons.warning_amber_rounded,
                  color: Colors.red.shade800),
              SwitchListTile(
                tileColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
                title: const Text('Seker Kisitlamasi Var mi?'),
                subtitle: const Text('Evet ise ogretmenlere kirmizi uyari gosterilir.'),
                value: _hasSugarRestriction,
                onChanged: (val) => setState(() => _hasSugarRestriction = val),
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _sugarToleranceController,
                label: 'Seker / Gida Hassasiyeti Aciklamasi',
                hint: 'Orn: Seker kesinlikle verilmemeli, hiperaktiviteyi tetikliyor',
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _allergiesController,
                label: 'Alerjiler (Virgulle ayiriniz)',
                hint: 'Orn: Yumurta, Fistik, Cilek',
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _chronicConditionsController,
                label: 'Kronik Durumlar / Nobet Gecmisi',
                hint: 'Orn: Epilepsi gecmisi var',
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _emergencyContactController,
                label: 'Acil Durumda Aranacak Kisi & Telefon',
                hint: 'Orn: 0532 000 00 00 (Anne - Ayse Hanim)',
                required: true,
              ),
              const SizedBox(height: 20),

              // 3. 🚻 TUVALET & ÖZBAKIM
              _buildSectionTitle(
                  '3. Tuvalet & Ozbakim', Icons.wc_rounded,
                  color: Colors.blue.shade800),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<ToiletStatus>(
                    value: _toiletStatus,
                    isExpanded: true,
                    items: ToiletStatus.values.map((status) {
                      return DropdownMenuItem(
                        value: status,
                        child: Text(status.label),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _toiletStatus = val);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _toiletCommMethodController,
                label: 'Ihtiyacini Nasil Belirtir?',
                hint: 'Orn: Sozel soyluyor / PECS kartiyla / Egitmenin elini cekerek',
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _toiletNotesController,
                label: 'Tuvalet Ozel Notu',
                hint: 'Orn: 45 dakikada bir lavaboya yonlendirilmeli',
              ),
              const SizedBox(height: 20),

              // 4. 🏫 OKUL & RAM
              _buildSectionTitle(
                  '4. Okul & RAM Bilgisi', Icons.school_rounded,
                  color: Colors.purple.shade800),
              SwitchListTile(
                tileColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
                title: const Text('Okula Gidiyor mu?'),
                value: _attendsSchool,
                onChanged: (val) => setState(() => _attendsSchool = val),
              ),
              if (_attendsSchool) ...[
                const SizedBox(height: 12),
                _buildTextField(
                  controller: _schoolNameController,
                  label: 'Okul Adi',
                  hint: 'Orn: Ataturk Ilkokulu',
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  controller: _gradeController,
                  label: 'Sinif / Kademe',
                  hint: 'Orn: 2/A Kaynastirma veya OCEM',
                ),
              ],
              const SizedBox(height: 12),
              _buildTextField(
                controller: _ramReportExpiryController,
                label: 'RAM Rapor Bitis Tarihi',
                hint: 'Orn: 15.09.2027',
              ),
              const SizedBox(height: 20),

              // 5. 🗣️ İLETİŞİM & DAVRANIŞ
              _buildSectionTitle('5. Iletisim & Sakinlestirme',
                  Icons.psychology_rounded,
                  color: Colors.amber.shade900),
              _buildTextField(
                controller: _verbalLevelController,
                label: 'Konusma Duzeyi',
                hint: 'Orn: Sozel / Sinirli kelimeler / Non-verbal',
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _triggersController,
                label: 'Kriz / Ofke Tetikleyicileri (Dikkat!)',
                hint: 'Orn: Yuksek ses, zorlanma, dokunulma',
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _calmingTechniquesController,
                label: 'Ne Sakinlestirir? (Yontemler)',
                hint: 'Orn: Mavi stres topu, sakin ortama gecis, hafif sirt sivazlama',
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _rewardsController,
                label: 'Sevdigi Seyler & Pekistirecler',
                hint: 'Orn: Baloncuk, araba, yildiz cikartmasi',
              ),
              const SizedBox(height: 24),

              // Kaydet Butonu
              ElevatedButton.icon(
                onPressed: _saveStudent,
                icon: const Icon(Icons.check_circle_outline),
                label: Text(
                  isEditing ? 'Degisiklikleri Kaydet' : 'Ogrenciyi Havuza Ekle',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 20, color: color ?? Colors.blue.shade700),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: color ?? const Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    bool required = false,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      validator: required
          ? (val) {
              if (val == null || val.trim().isEmpty) {
                return 'Bu alan zorunludur';
              }
              return null;
            }
          : null,
    );
  }
}
