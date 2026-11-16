import 'package:intl/intl.dart';

enum ToiletStatus {
  independent, // Bağımsız
  withAssistance, // Destekle / Hatırlatmalı
  diaper, // Bez kullanıyor
}

extension ToiletStatusExtension on ToiletStatus {
  String get label {
    switch (this) {
      case ToiletStatus.independent:
        return 'Bağımsız (Var)';
      case ToiletStatus.withAssistance:
        return 'Destekle / Hatırlatmalı';
      case ToiletStatus.diaper:
        return 'Bez Kullanıyor / Eğitimi Yok';
    }
  }
}

class Medication {
  final String name;
  final String dosage;
  final String time;

  Medication({
    required this.name,
    required this.dosage,
    required this.time,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'dosage': dosage,
        'time': time,
      };

  factory Medication.fromJson(Map<String, dynamic> json) => Medication(
        name: json['name'] ?? '',
        dosage: json['dosage'] ?? '',
        time: json['time'] ?? '',
      );
}

class HealthInfo {
  final String sugarTolerance; // Şeker hassasiyeti / kuralı
  final bool hasSugarRestriction; // Şeker yasak mı?
  final List<String> allergies;
  final String chronicConditions; // Epilepsi, astım vb.
  final String emergencyContact; // Acil aranacak kişi & tel
  final List<Medication> medications;

  HealthInfo({
    required this.sugarTolerance,
    required this.hasSugarRestriction,
    required this.allergies,
    required this.chronicConditions,
    required this.emergencyContact,
    required this.medications,
  });

  Map<String, dynamic> toJson() => {
        'sugarTolerance': sugarTolerance,
        'hasSugarRestriction': hasSugarRestriction,
        'allergies': allergies,
        'chronicConditions': chronicConditions,
        'emergencyContact': emergencyContact,
        'medications': medications.map((m) => m.toJson()).toList(),
      };

  factory HealthInfo.fromJson(Map<String, dynamic> json) => HealthInfo(
        sugarTolerance: json['sugarTolerance'] ?? '',
        hasSugarRestriction: json['hasSugarRestriction'] ?? false,
        allergies: List<String>.from(json['allergies'] ?? []),
        chronicConditions: json['chronicConditions'] ?? '',
        emergencyContact: json['emergencyContact'] ?? '',
        medications: (json['medications'] as List<dynamic>?)
                ?.map((m) => Medication.fromJson(m))
                .toList() ??
            [],
      );
}

class ToiletInfo {
  final ToiletStatus status;
  final String communicationMethod; // İhtiyacı nasıl belirtiyor?
  final String notes;

  ToiletInfo({
    required this.status,
    required this.communicationMethod,
    required this.notes,
  });

  Map<String, dynamic> toJson() => {
        'status': status.name,
        'communicationMethod': communicationMethod,
        'notes': notes,
      };

  factory ToiletInfo.fromJson(Map<String, dynamic> json) => ToiletInfo(
        status: ToiletStatus.values.firstWhere(
          (e) => e.name == json['status'],
          orElse: () => ToiletStatus.withAssistance,
        ),
        communicationMethod: json['communicationMethod'] ?? '',
        notes: json['notes'] ?? '',
      );
}

class SchoolInfo {
  final bool attendsSchool;
  final String schoolName;
  final String grade; // Sınıf / Şube (örn: 2/B Kaynaştırma)
  final String ramReportExpiry; // RAM rapor bitiş tarihi

  SchoolInfo({
    required this.attendsSchool,
    required this.schoolName,
    required this.grade,
    required this.ramReportExpiry,
  });

  Map<String, dynamic> toJson() => {
        'attendsSchool': attendsSchool,
        'schoolName': schoolName,
        'grade': grade,
        'ramReportExpiry': ramReportExpiry,
      };

  factory SchoolInfo.fromJson(Map<String, dynamic> json) => SchoolInfo(
        attendsSchool: json['attendsSchool'] ?? false,
        schoolName: json['schoolName'] ?? '',
        grade: json['grade'] ?? '',
        ramReportExpiry: json['ramReportExpiry'] ?? '',
      );
}

class BehaviorInfo {
  final String verbalLevel; // Konuşma düzeyi
  final String triggers; // Kriz / öfke tetikleyicileri
  final String calmingTechniques; // Ne sakinleştirir?
  final String rewards; // Sevdiği şeyler / pekiştireçler

  BehaviorInfo({
    required this.verbalLevel,
    required this.triggers,
    required this.calmingTechniques,
    required this.rewards,
  });

  Map<String, dynamic> toJson() => {
        'verbalLevel': verbalLevel,
        'triggers': triggers,
        'calmingTechniques': calmingTechniques,
        'rewards': rewards,
      };

  factory BehaviorInfo.fromJson(Map<String, dynamic> json) => BehaviorInfo(
        verbalLevel: json['verbalLevel'] ?? '',
        triggers: json['triggers'] ?? '',
        calmingTechniques: json['calmingTechniques'] ?? '',
        rewards: json['rewards'] ?? '',
      );
}

class ObservationNote {
  final String id;
  final String authorName; // Notu yazan öğretmen
  final String note;
  final DateTime timestamp;

  ObservationNote({
    required this.id,
    required this.authorName,
    required this.note,
    required this.timestamp,
  });

  String get formattedDate {
    return DateFormat('dd.MM.yyyy HH:mm').format(timestamp);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'authorName': authorName,
        'note': note,
        'timestamp': timestamp.toIso8601String(),
      };

  factory ObservationNote.fromJson(Map<String, dynamic> json) =>
      ObservationNote(
        id: json['id'] ?? '',
        authorName: json['authorName'] ?? '',
        note: json['note'] ?? '',
        timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
      );
}

class Student {
  final String id;
  final String institutionCode;
  final String fullName;
  final DateTime birthDate;
  final String diagnosis; // Tanı (Otizm, Down, Zihinsel vb.)
  final String? photoUrl;
  final HealthInfo health;
  final ToiletInfo toilet;
  final SchoolInfo school;
  final BehaviorInfo behavior;
  final List<ObservationNote> notes;

  Student({
    required this.id,
    required this.institutionCode,
    required this.fullName,
    required this.birthDate,
    required this.diagnosis,
    this.photoUrl,
    required this.health,
    required this.toilet,
    required this.school,
    required this.behavior,
    required this.notes,
  });

  int get age {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  Student copyWith({
    String? id,
    String? institutionCode,
    String? fullName,
    DateTime? birthDate,
    String? diagnosis,
    String? photoUrl,
    HealthInfo? health,
    ToiletInfo? toilet,
    SchoolInfo? school,
    BehaviorInfo? behavior,
    List<ObservationNote>? notes,
  }) {
    return Student(
      id: id ?? this.id,
      institutionCode: institutionCode ?? this.institutionCode,
      fullName: fullName ?? this.fullName,
      birthDate: birthDate ?? this.birthDate,
      diagnosis: diagnosis ?? this.diagnosis,
      photoUrl: photoUrl ?? this.photoUrl,
      health: health ?? this.health,
      toilet: toilet ?? this.toilet,
      school: school ?? this.school,
      behavior: behavior ?? this.behavior,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'institutionCode': institutionCode,
        'fullName': fullName,
        'birthDate': birthDate.toIso8601String(),
        'diagnosis': diagnosis,
        'photoUrl': photoUrl,
        'health': health.toJson(),
        'toilet': toilet.toJson(),
        'school': school.toJson(),
        'behavior': behavior.toJson(),
        'notes': notes.map((n) => n.toJson()).toList(),
      };

  factory Student.fromJson(Map<String, dynamic> json) => Student(
        id: json['id'] ?? '',
        institutionCode: json['institutionCode'] ?? '',
        fullName: json['fullName'] ?? '',
        birthDate:
            DateTime.tryParse(json['birthDate'] ?? '') ?? DateTime(2018, 1, 1),
        diagnosis: json['diagnosis'] ?? '',
        photoUrl: json['photoUrl'],
        health: HealthInfo.fromJson(json['health'] ?? {}),
        toilet: ToiletInfo.fromJson(json['toilet'] ?? {}),
        school: SchoolInfo.fromJson(json['school'] ?? {}),
        behavior: BehaviorInfo.fromJson(json['behavior'] ?? {}),
        notes: (json['notes'] as List<dynamic>?)
                ?.map((n) => ObservationNote.fromJson(n))
                .toList() ??
            [],
      );
}
