import '../models/institution_model.dart';
import '../models/student_model.dart';

class MockData {
  static Institution sampleInstitution = Institution(
    institutionCode: 'REHAB01',
    institutionName: 'Umut Ozel Egitim ve Rehabilitasyon Merkezi',
    adminPassword: 'admin',
    teacherPassword: '123',
  );

  static List<Student> sampleStudents = [
    Student(
      id: 'st_01',
      institutionCode: 'REHAB01',
      fullName: 'Ali Demir',
      birthDate: DateTime(2019, 4, 15),
      diagnosis: 'Otizm Spektrum Bozuklugu (OSB)',
      health: HealthInfo(
        sugarTolerance:
            'SEKER KESINLIKLE VERILMEMELI! Seker tuketimi asiri hiperaktivite, ofke krizi ve kendine vurma davranisini tetikler.',
        hasSugarRestriction: true,
        allergies: ['Yumurta', 'Cilek'],
        chronicConditions: 'Epilepsi gecmisi var. Nobet aninda basi yumusak zeminde tutulmali.',
        emergencyContact: '0532 111 22 33 (Anne - Zeynep Hanim)',
        medications: [
          Medication(
            name: 'Risperdal',
            dosage: '0.5 mg',
            time: 'Aksam 20:00 (Evde alinir)',
          ),
        ],
      ),
      toilet: ToiletInfo(
        status: ToiletStatus.withAssistance,
        communicationMethod:
            'PECS karti gostererek veya egitmenin elini lavaboya dogru cekerek haber verir.',
        notes: 'Her 45 dakikada bir lavaboya yonlendirilmeli. Kendi basina haber vermeyi bazen unutabilir.',
      ),
      school: SchoolInfo(
        attendsSchool: true,
        schoolName: 'Cumhuriyet Ilkokulu',
        grade: '1. Sinif OCEM / Ozel Egitim Sinifi',
        ramReportExpiry: '15.09.2027',
      ),
      behavior: BehaviorInfo(
        verbalLevel: 'Sinirli kelimeler (su, ver, git). Ekolali gozlemlenir.',
        triggers: 'Ani yuksek sesler, kalabalik ortam ve plansiz mekan degisimi.',
        calmingTechniques:
            'Mavi stres topunu sikmak, sirtina ritmik hafif baski uygulamak ve sessiz alana gecmek.',
        rewards: 'Baloncuk ufleme, araba oyuncaklari, yildiz cikartmasi.',
      ),
      notes: [
        ObservationNote(
          id: 'note_01',
          authorName: 'Merve Ogretmen (Ozel Egitim)',
          note:
              'Bugun ders basinda cok sakindi. Tuvalet kartini 1 kez kendiliginden kullandi. Cok basarili bir seansti.',
          timestamp: DateTime.now().subtract(const Duration(hours: 4)),
        ),
        ObservationNote(
          id: 'note_02',
          authorName: 'Baris Hoca (Fizyoterapist)',
          note:
              'Denge tahtasinda calisirken aniden koridordan gelen sesten urktu, mavi stres topuyla hemen sakinlestirdik.',
          timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
        ),
      ],
    ),
    Student(
      id: 'st_02',
      institutionCode: 'REHAB01',
      fullName: 'Zeynep Kaya',
      birthDate: DateTime(2017, 8, 22),
      diagnosis: 'Down Sendromu',
      health: HealthInfo(
        sugarTolerance:
            'Kilo kontrolu ve diyabet yatkinligi sebebiyle paketli seker/cikolata verilmemeli. Odul olarak kuru meyve verilebilir.',
        hasSugarRestriction: true,
        allergies: [],
        chronicConditions: 'Hafif kalp ufurumu takibi var. Asiri efor sarf ettirilmemeli.',
        emergencyContact: '0544 555 66 77 (Baba - Murat Bey)',
        medications: [
          Medication(
            name: 'Euthyrox',
            dosage: '25 mcg',
            time: 'Sabah ac karnina (Evde)',
          ),
        ],
      ),
      toilet: ToiletInfo(
        status: ToiletStatus.independent,
        communicationMethod: 'Sozel olarak "Tuvalete gidebilir miyim?" der.',
        notes: 'Bagimsiz gidebiliyor, sadece muslugu kapatmayi unutabiliyor.',
      ),
      school: SchoolInfo(
        attendsSchool: true,
        schoolName: 'Ataturk Ilkokulu',
        grade: '3/C Kaynastirma Ogrencisi',
        ramReportExpiry: '20.02.2027',
      ),
      behavior: BehaviorInfo(
        verbalLevel: 'Akici ve iletisime cok acik. Sosyal iletisimi guclu.',
        triggers: 'Gorevi yapamayacagini hissettiginde inatlasabilir veya kusebilir.',
        calmingTechniques: 'Muzik acip tempo tutmak, sarilmak ve takdir etmek.',
        rewards: 'Resim boyama, el baskisi, sarki dinleme.',
      ),
      notes: [
        ObservationNote(
          id: 'note_03',
          authorName: 'Selin Hoca (Dil ve Konusma)',
          note:
              'K ve T sesleri uzerinde calistik. Kelime tamamlama oyunlarina cok istekli katildi.',
          timestamp: DateTime.now().subtract(const Duration(hours: 6)),
        ),
      ],
    ),
    Student(
      id: 'st_03',
      institutionCode: 'REHAB01',
      fullName: 'Kerem Yildiz',
      birthDate: DateTime(2021, 11, 05),
      diagnosis: 'Gelisimsel Gerilik / Atipik Otizm',
      health: HealthInfo(
        sugarTolerance: 'Seker kisitlamasi yok, fakat ders icerisinde tuketilmemesi onerilir.',
        hasSugarRestriction: false,
        allergies: ['Fistik (Ciddi Alerji - Nefes darligi yapar)'],
        chronicConditions: 'Yok',
        emergencyContact: '0505 888 99 00 (Anne - Fatma Hanim)',
        medications: [],
      ),
      toilet: ToiletInfo(
        status: ToiletStatus.diaper,
        communicationMethod: 'Ihtiyacini ifade edemiyor. Bez takibi yapilmali.',
        notes: 'Alt degisimi seans oncesi ve sonrasi kontrol edilmeli.',
      ),
      school: SchoolInfo(
        attendsSchool: false,
        schoolName: '-',
        grade: 'Okula gitmiyor (Okul Oncesi)',
        ramReportExpiry: '10.12.2026',
      ),
      behavior: BehaviorInfo(
        verbalLevel: 'Non-verbal (Konusmuyor). Anlamli sesler ve jestlerle iletisim kurar.',
        triggers: 'Elinin tutulmasi ve zorla sandalye oturtulmasi.',
        calmingTechniques: 'Isikli duyusal materyaller ve salincakta sallanma.',
        rewards: 'Isikli muzik kutusu, balonlar.',
      ),
      notes: [
        ObservationNote(
          id: 'note_04',
          authorName: 'Emre Ogretmen (Ergoterapi)',
          note:
              'Duyusal entegrasyon odasinda dokunma hassasiyetini calistik. Pirinc havuzunda elini 5 dakika tutabildi.',
          timestamp: DateTime.now().subtract(const Duration(days: 2)),
        ),
      ],
    ),
  ];
}
