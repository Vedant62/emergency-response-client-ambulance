import 'dart:ffi';

class EmergencyCase {
  const EmergencyCase({required this.patientInfo, required this.severity, required this.vitals});

  final PatientInfo patientInfo;
  final Severity severity;
  final Vitals vitals;

  Map<String, dynamic> toMap() {
    return {
      'patientInfo': patientInfo.toMap(),
      'severity': severity.toString().split('.').last,
      'vitals': vitals.toMap(),
    };
  }

  factory EmergencyCase.fromMap(Map<String, dynamic> map) {
    return EmergencyCase(
      patientInfo: PatientInfo.fromMap(map['patientInfo']),
      severity: (map['severity'] as String).toSeverity(),
      vitals: Vitals.fromMap(map['vitals']),
    );
  }
}

class PatientInfo {
  const PatientInfo({required this.age, required this.condition, required this.gender, required this.symptoms});
  final String condition;
  final int age;
  final Gender gender;
  final List<String> symptoms;

  Map<String, dynamic> toMap() {
    return {
      'condition': condition,
      'age': age,
      'gender': gender.toString().split('.').last, // Convert enum to string
      'symptoms': symptoms,
    };
  }

  factory PatientInfo.fromMap(Map<String, dynamic> map) {
    return PatientInfo(
      condition: map['condition'] as String,
      age: map['age'] as int,
      gender: (map['gender'] as String).toGender(), // Convert string back to enum
      symptoms: List<String>.from(map['symptoms']), // Properly cast List
    );
  }
}

extension GenderExtension on String {
  Gender toGender() {
    return Gender.values.firstWhere(
          (e) => e.toString().split('.').last == this,
      orElse: () => Gender.male,
    );
  }
}

extension SeverityExtension on String {
  Severity toSeverity() {
    return Severity.values.firstWhere(
          (e) => e.toString().split('.').last == this,
      orElse: () => Severity.moderate,
    );
  }
}

enum Gender {
  male,
  female
}

enum Severity {
  minor,
  moderate,
  critical
}

class Vitals {
  const Vitals({required this.bloodPressure, required this.heartRate, required this.oxygenSaturation});
  final dynamic heartRate;
  final dynamic bloodPressure;
  final dynamic oxygenSaturation;

  Map<String, dynamic> toMap() {
    return {
      'heartRate': heartRate,
      'bloodPressure': bloodPressure,
      'oxygenSaturation': oxygenSaturation,
    };
  }

  factory Vitals.fromMap(Map<String, dynamic> map) {
    return Vitals(
      heartRate: map['heartRate'],
      bloodPressure: map['bloodPressure'],
      oxygenSaturation: map['oxygenSaturation'],
    );
  }
}