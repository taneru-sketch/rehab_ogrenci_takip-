enum UserRole {
  none,
  teacher, // Egitimci (Ortak sifre)
  admin, // Kurum Yoneticisi
}

class Institution {
  final String institutionCode;
  final String institutionName;
  final String adminPassword;
  final String teacherPassword;

  Institution({
    required this.institutionCode,
    required this.institutionName,
    required this.adminPassword,
    required this.teacherPassword,
  });

  Institution copyWith({
    String? institutionCode,
    String? institutionName,
    String? adminPassword,
    String? teacherPassword,
  }) {
    return Institution(
      institutionCode: institutionCode ?? this.institutionCode,
      institutionName: institutionName ?? this.institutionName,
      adminPassword: adminPassword ?? this.adminPassword,
      teacherPassword: teacherPassword ?? this.teacherPassword,
    );
  }

  Map<String, dynamic> toJson() => {
        'institutionCode': institutionCode,
        'institutionName': institutionName,
        'adminPassword': adminPassword,
        'teacherPassword': teacherPassword,
      };

  factory Institution.fromJson(Map<String, dynamic> json) => Institution(
        institutionCode: json['institutionCode'] ?? '',
        institutionName: json['institutionName'] ?? '',
        adminPassword: json['adminPassword'] ?? '',
        teacherPassword: json['teacherPassword'] ?? '',
      );
}
