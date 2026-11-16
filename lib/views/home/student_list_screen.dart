import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/student_model.dart';
import '../../services/app_state.dart';
import '../../widgets/ad_banner_widget.dart';
import '../admin/admin_settings_screen.dart';
import '../admin/student_form_screen.dart';
import '../auth/login_screen.dart';
import '../student_detail/student_detail_screen.dart';

class StudentListScreen extends StatelessWidget {
  const StudentListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final theme = Theme.of(context);
    final students = appState.filteredStudents;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              appState.institution.institutionName,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: appState.isAdmin
                        ? Colors.amber.shade100
                        : Colors.green.shade100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    appState.isAdmin ? 'Yonetici (Admin)' : 'Egitimci Modu',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: appState.isAdmin
                          ? Colors.amber.shade900
                          : Colors.green.shade900,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'Kod: ${appState.institution.institutionCode}',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                ),
              ],
            ),
          ],
        ),
        actions: [
          if (appState.isAdmin)
            IconButton(
              icon: const Icon(Icons.settings_outlined, color: Colors.blueGrey),
              tooltip: 'Kurum & Sifre Ayarlari',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const AdminSettingsScreen(),
                  ),
                );
              },
            ),
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
            tooltip: 'Cikis Yap',
            onPressed: () {
              appState.logout();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Arama & Filtreleme Barı
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Column(
              children: [
                TextField(
                  onChanged: (val) => appState.setSearchQuery(val),
                  decoration: InputDecoration(
                    hintText: 'Ogrenci adi veya tani ara (Orn: Ali, Otizm)...',
                    prefixIcon: const Icon(Icons.search, size: 20),
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip(context, 'Tumu'),
                      _buildFilterChip(context, 'Seker Hassasiyeti'),
                      _buildFilterChip(context, 'Tuvalet Desteği'),
                      _buildFilterChip(context, 'Okula Gidenler'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Öğrenci Listesi
          Expanded(
            child: students.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off_rounded,
                            size: 64, color: Colors.grey.shade400),
                        const SizedBox(height: 12),
                        Text(
                          'Eslesen ogrenci bulunamadi.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      final student = students[index];
                      return _buildStudentCard(context, student, appState);
                    },
                  ),
          ),

          // Sabit Google Ads Reklam Alanı
          const AdBannerWidget(),
        ],
      ),
      floatingActionButton: appState.isAdmin
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const StudentFormScreen(),
                  ),
                );
              },
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.person_add_rounded),
              label: const Text('Yeni Ogrenci'),
            )
          : null,
    );
  }

  Widget _buildFilterChip(BuildContext context, String filterName) {
    final appState = Provider.of<AppState>(context);
    final isSelected = appState.selectedFilter == filterName;

    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: FilterChip(
        label: Text(filterName),
        selected: isSelected,
        onSelected: (_) => appState.setSelectedFilter(filterName),
        selectedColor: Theme.of(context).colorScheme.primaryContainer,
        labelStyle: TextStyle(
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.grey.shade700,
        ),
        backgroundColor: Colors.grey.shade100,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      ),
    );
  }

  Widget _buildStudentCard(
      BuildContext context, Student student, AppState appState) {
    final lastNote =
        student.notes.isNotEmpty ? student.notes.first : null;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => StudentDetailScreen(studentId: student.id),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Üst Satır: Avatar + İsim + Tanı + Yaş
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.blue.shade100,
                    child: Text(
                      student.fullName.isNotEmpty
                          ? student.fullName.substring(0, 1).toUpperCase()
                          : '?',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          student.fullName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${student.age} Yas • ${student.diagnosis}',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded,
                      size: 16, color: Colors.blueGrey),
                ],
              ),
              const SizedBox(height: 10),

              // Kritik Hızlı Bilgi Etiketleri (Öğretmenin 2 saniyede görmesi gereken durumlar)
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: [
                  // Şeker Uyarısı
                  if (student.health.hasSugarRestriction)
                    _buildStatusBadge(
                      label: '🚨 Seker Yasak/Hassas',
                      bgColor: Colors.red.shade50,
                      textColor: Colors.red.shade800,
                      borderColor: Colors.red.shade200,
                    ),

                  // Tuvalet Durumu
                  if (student.toilet.status == ToiletStatus.diaper)
                    _buildStatusBadge(
                      label: '🚻 Bez Kullaniyor',
                      bgColor: Colors.blue.shade50,
                      textColor: Colors.blue.shade800,
                      borderColor: Colors.blue.shade200,
                    )
                  else if (student.toilet.status == ToiletStatus.withAssistance)
                    _buildStatusBadge(
                      label: '🚻 Destekle / Hatirlatmali',
                      bgColor: Colors.orange.shade50,
                      textColor: Colors.orange.shade800,
                      borderColor: Colors.orange.shade200,
                    ),

                  // İlaç Takibi
                  if (student.health.medications.isNotEmpty)
                    _buildStatusBadge(
                      label: '💊 Ilac Listesi Var',
                      bgColor: Colors.teal.shade50,
                      textColor: Colors.teal.shade800,
                      borderColor: Colors.teal.shade200,
                    ),

                  // Okul Durumu
                  if (student.school.attendsSchool)
                    _buildStatusBadge(
                      label: '🏫 Okula Gidiyor',
                      bgColor: Colors.purple.shade50,
                      textColor: Colors.purple.shade800,
                      borderColor: Colors.purple.shade200,
                    ),
                ],
              ),

              // Son Eklenen Not Önizlemesi
              if (lastNote != null) ...[
                const SizedBox(height: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.speaker_notes_outlined,
                          size: 15, color: Colors.blueGrey.shade400),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          '${lastNote.authorName}: "${lastNote.note}"',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blueGrey.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge({
    required String label,
    required Color bgColor,
    required Color textColor,
    required Color borderColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: borderColor, width: 0.8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}
