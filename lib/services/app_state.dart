import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/institution_model.dart';
import '../models/student_model.dart';
import 'mock_data.dart';

class AppState extends ChangeNotifier {
  Institution _institution = MockData.sampleInstitution;
  UserRole _currentUserRole = UserRole.none;
  List<Student> _students = List.from(MockData.sampleStudents);
  String _searchQuery = '';
  String _selectedFilter = 'Tumu';

  Institution get institution => _institution;
  UserRole get currentUserRole => _currentUserRole;
  bool get isLoggedIn => _currentUserRole != UserRole.none;
  bool get isAdmin => _currentUserRole == UserRole.admin;
  bool get isTeacher => _currentUserRole == UserRole.teacher;

  String get searchQuery => _searchQuery;
  String get selectedFilter => _selectedFilter;

  // Filtrelenmiş ve aranmış öğrenci listesi
  List<Student> get filteredStudents {
    return _students.where((student) {
      final matchesSearch = student.fullName
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          student.diagnosis.toLowerCase().contains(_searchQuery.toLowerCase());

      if (!matchesSearch) return false;

      if (_selectedFilter == 'Seker Hassasiyeti') {
        return student.health.hasSugarRestriction;
      } else if (_selectedFilter == 'Tuvalet Desteği') {
        return student.toilet.status != ToiletStatus.independent;
      } else if (_selectedFilter == 'Okula Gidenler') {
        return student.school.attendsSchool;
      }

      return true;
    }).toList();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSelectedFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  // Giriş Doğrulama
  // Kurum Kodu + Şifre ile otomatik rol belirleme
  String? login({
    required String institutionCode,
    required String password,
  }) {
    final cleanCode = institutionCode.trim().toUpperCase();
    final cleanPass = password.trim();

    if (cleanCode != _institution.institutionCode.toUpperCase()) {
      return 'Gecersiz Kurum Kodu! Lutfen kurum yoneticinizden aldiginiz kodu giriniz.';
    }

    if (cleanPass == _institution.adminPassword) {
      _currentUserRole = UserRole.admin;
      notifyListeners();
      return null;
    } else if (cleanPass == _institution.teacherPassword) {
      _currentUserRole = UserRole.teacher;
      notifyListeners();
      return null;
    } else {
      return 'Gecersiz Sifre! Egitimci veya Yonetici sifrenizi kontrol ediniz.';
    }
  }

  void logout() {
    _currentUserRole = UserRole.none;
    _searchQuery = '';
    _selectedFilter = 'Tumu';
    notifyListeners();
  }

  // Şifreleri Güncelleme (Yönetici)
  bool updatePasswords({
    required String newTeacherPassword,
    required String newAdminPassword,
    String? newInstitutionName,
  }) {
    if (!isAdmin) return false;

    _institution = _institution.copyWith(
      teacherPassword: newTeacherPassword,
      adminPassword: newAdminPassword,
      institutionName: newInstitutionName ?? _institution.institutionName,
    );
    notifyListeners();
    return true;
  }

  // Öğrenci Ekleme (Yönetici)
  void addStudent(Student student) {
    if (!isAdmin) return;
    _students.insert(0, student);
    notifyListeners();
  }

  // Öğrenci Güncelleme (Yönetici)
  void updateStudent(Student updatedStudent) {
    if (!isAdmin) return;
    final index = _students.indexWhere((s) => s.id == updatedStudent.id);
    if (index != -1) {
      _students[index] = updatedStudent;
      notifyListeners();
    }
  }

  // Öğrenci Silme (Yönetici)
  void deleteStudent(String studentId) {
    if (!isAdmin) return;
    _students.removeWhere((s) => s.id == studentId);
    notifyListeners();
  }

  // Seans / Gözlem Notu Ekleme (Hem Eğitmen hem Yönetici yapabilir)
  void addObservationNote({
    required String studentId,
    required String authorName,
    required String noteText,
  }) {
    final studentIndex = _students.indexWhere((s) => s.id == studentId);
    if (studentIndex != -1) {
      final newNote = ObservationNote(
        id: const Uuid().v4(),
        authorName: authorName.trim().isEmpty ? 'Egitimci' : authorName.trim(),
        note: noteText.trim(),
        timestamp: DateTime.now(),
      );

      final updatedNotes = List<ObservationNote>.from(_students[studentIndex].notes)
        ..insert(0, newNote);

      _students[studentIndex] = _students[studentIndex].copyWith(notes: updatedNotes);
      notifyListeners();
    }
  }

  Student? getStudentById(String id) {
    try {
      return _students.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }
}
