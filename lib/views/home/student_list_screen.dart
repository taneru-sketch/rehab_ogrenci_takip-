import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../models/student_model.dart';
import '../../services/app_state.dart';
import '../../theme/app_colors.dart';
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
    final students = appState.filteredStudents;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Gradient Header
          _buildHeader(context, appState),

          // Arama & Filtreler
          _buildSearchAndFilters(context, appState),

          // Öğrenci Listesi
          Expanded(
            child: students.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      return _buildStudentCard(context, students[index], index)
                          .animate(delay: (index * 60).ms)
                          .fadeIn()
                          .slideY(begin: 0.2, end: 0, curve: Curves.easeOut);
                    },
                  ),
          ),

          // AdMob
          const AdBannerWidget(),
        ],
      ),
      floatingActionButton: appState.isAdmin
          ? FloatingActionButton.extended(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const StudentFormScreen()),
              ),
              backgroundColor: AppColors.accent,
              foregroundColor: Colors.white,
              icon: const Text('➕', style: TextStyle(fontSize: 18)),
              label: Text(
                'Yeni Öğrenci',
                style: GoogleFonts.nunito(fontWeight: FontWeight.w700),
              ),
              elevation: 4,
            )
          : null,
    );
  }

  Widget _buildHeader(BuildContext context, AppState appState) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 12, 20),
          child: Row(
            children: [
              const Text('🌟', style: TextStyle(fontSize: 28)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appState.institution.institutionName,
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        appState.isAdmin ? '👑 Yönetici Modu' : '👩‍🏫 Eğitimci Modu',
                        style: GoogleFonts.nunito(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (appState.isAdmin)
                IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text('⚙️', style: TextStyle(fontSize: 18)),
                  ),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AdminSettingsScreen()),
                  ),
                ),
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text('🚪', style: TextStyle(fontSize: 18)),
                ),
                onPressed: () {
                  appState.logout();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchAndFilters(BuildContext context, AppState appState) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        children: [
          // Arama
          TextField(
            onChanged: appState.setSearchQuery,
            decoration: InputDecoration(
              hintText: '🔍  Öğrenci adı veya tanı ara...',
              hintStyle: GoogleFonts.nunito(fontSize: 14, color: Colors.grey.shade400),
              prefixIcon: null,
              suffixIcon: appState.searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded, size: 18),
                      onPressed: () => appState.setSearchQuery(''),
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 10),
          // Filtre Chipleri
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _filterChip(context, appState, 'Tümü', '📋'),
                _filterChip(context, appState, 'Şeker Hassasiyeti', '🍬'),
                _filterChip(context, appState, 'Tuvalet Desteği', '🚻'),
                _filterChip(context, appState, 'Okula Gidenler', '🏫'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(BuildContext context, AppState appState, String label, String emoji) {
    final isSelected = appState.selectedFilter == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () => appState.setSelectedFilter(label),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? AppColors.primary : const Color(0xFFE5E0FF),
              width: 1.5,
            ),
            boxShadow: isSelected
                ? [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 2))]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 14)),
              const SizedBox(width: 5),
              Text(
                label,
                style: GoogleFonts.nunito(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.white : Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStudentCard(BuildContext context, Student student, int index) {
    final avatarColor = AppColors.avatarColors[index % AppColors.avatarColors.length];

    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => StudentDetailScreen(studentId: student.id)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Üst: Avatar + Bilgiler
              Row(
                children: [
                  // Renkli Gradient Avatar
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [avatarColor, avatarColor.withOpacity(0.7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: avatarColor.withOpacity(0.35),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        student.fullName.isNotEmpty
                            ? student.fullName.substring(0, 1).toUpperCase()
                            : '?',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
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
                          style: GoogleFonts.nunito(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF1E1B4B),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${student.age} yaş  •  ${student.diagnosis}',
                          style: GoogleFonts.nunito(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded, color: Colors.grey.shade300, size: 26),
                ],
              ),

              // Kritik Durum Rozetleri
              if (student.health.hasSugarRestriction ||
                  student.toilet.status != ToiletStatus.independent ||
                  student.health.medications.isNotEmpty ||
                  student.school.attendsSchool) ...[
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  runSpacing: 5,
                  children: [
                    if (student.health.hasSugarRestriction)
                      _badge('🍬 Şeker Yasak!', const Color(0xFFFF6B6B), const Color(0xFFFFF1F2)),
                    if (student.toilet.status == ToiletStatus.diaper)
                      _badge('🚼 Bez Kullanıyor', const Color(0xFF38BDF8), const Color(0xFFE0F2FE)),
                    if (student.toilet.status == ToiletStatus.withAssistance)
                      _badge('🚻 Destekle', const Color(0xFFF59E0B), const Color(0xFFFFFBEB)),
                    if (student.health.medications.isNotEmpty)
                      _badge('💊 İlaç Takibi', const Color(0xFF10B981), const Color(0xFFECFDF5)),
                    if (student.school.attendsSchool)
                      _badge('🏫 Okula Gidiyor', AppColors.primary, AppColors.surfaceLight),
                  ],
                ),
              ],

              // Son Not
              if (student.notes.isNotEmpty) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9F7FF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Text('📝', style: TextStyle(fontSize: 13)),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          '${student.notes.first.authorName}: "${student.notes.first.note}"',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.nunito(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w600,
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

  Widget _badge(String label, Color textColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: textColor.withOpacity(0.3), width: 1),
      ),
      child: Text(
        label,
        style: GoogleFonts.nunito(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🔍', style: TextStyle(fontSize: 64))
              .animate(onPlay: (c) => c.repeat())
              .shimmer(duration: 2000.ms),
          const SizedBox(height: 16),
          Text(
            'Eşleşen öğrenci bulunamadı.',
            style: GoogleFonts.nunito(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}
