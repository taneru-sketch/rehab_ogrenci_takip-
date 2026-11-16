import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../services/app_state.dart';

class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _teacherPassController;
  late TextEditingController _adminPassController;

  @override
  void initState() {
    super.initState();
    final inst = Provider.of<AppState>(context, listen: false).institution;
    _nameController = TextEditingController(text: inst.institutionName);
    _teacherPassController = TextEditingController(text: inst.teacherPassword);
    _adminPassController = TextEditingController(text: inst.adminPassword);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _teacherPassController.dispose();
    _adminPassController.dispose();
    super.dispose();
  }

  void _saveSettings() {
    if (_formKey.currentState!.validate()) {
      final appState = Provider.of<AppState>(context, listen: false);
      final success = appState.updatePasswords(
        newTeacherPassword: _teacherPassController.text.trim(),
        newAdminPassword: _adminPassController.text.trim(),
        newInstitutionName: _nameController.text.trim(),
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Kurum bilgileri ve sifreler basariyla guncellendi.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final inst = Provider.of<AppState>(context).institution;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Kurum ve Sifre Ayarlari'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Kurum Kodu Kartı (Salt Okunur)
              Card(
                elevation: 0,
                color: Colors.blue.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.blue.shade200),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Kurum Kodu (Sabit)',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            inst.institutionCode,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade900,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy_rounded, color: Colors.blue),
                        tooltip: 'Kodu Kopyala',
                        onPressed: () {
                          Clipboard.setData(
                              ClipboardData(text: inst.institutionCode));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Kurum kodu panoya kopyalandi.'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Kurum Adı
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Kurum Adi',
                  prefixIcon: const Icon(Icons.business_rounded),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Kurum adi bos birakilamaz';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Ortak Öğretmen Şifresi
              TextFormField(
                controller: _teacherPassController,
                decoration: InputDecoration(
                  labelText: 'Ortak Egitimci / Ogretmen Sifresi',
                  helperText:
                      'Kurumdaki tum egitimciler bu tek sifreyle giris yapar.',
                  prefixIcon: const Icon(Icons.group_outlined),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Egitimci sifresi bos birakilamaz';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Yönetici (Admin) Şifresi
              TextFormField(
                controller: _adminPassController,
                decoration: InputDecoration(
                  labelText: 'Yonetici (Admin) Sifresi',
                  helperText:
                      'Ogrenci ekleme/duzenleme ve ayarlar icin yonetici sifresi.',
                  prefixIcon: const Icon(Icons.admin_panel_settings_outlined),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Yonetici sifresi bos birakilamaz';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              ElevatedButton.icon(
                onPressed: _saveSettings,
                icon: const Icon(Icons.save_rounded),
                label: const Text(
                  'Ayarlari Kaydet',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
