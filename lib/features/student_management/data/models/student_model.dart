import 'package:classroom_manangement/features/student_management/domain/entities/student.dart';
import 'dart:convert';
// Data layer model class
class StudentModel extends Student {
  const StudentModel({
    required super.id,
    required super.name,
    required super.contactInfo,
    required super.gradeLevel,
    required super.notes,
  });

  // Factory constructor to create a StudentModel from a Map
  factory StudentModel.fromMap(Map<String, dynamic> map) {
    return StudentModel(
      id: map['id'] as String,
      name: map['name'] as String,
      contactInfo: map['contactInfo'] as String,
      gradeLevel: map['gradeLevel'] as String,
      notes: map['notes'] as String,
    );
  }

  // Factory constructor to create a StudentModel from a JSON string
  factory StudentModel.fromJson(String source) =>
      StudentModel.fromMap(json.decode(source));

  // Method to convert StudentModel to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'contactInfo': contactInfo,
      'gradeLevel': gradeLevel,
      'notes': notes,
    };
  }

  // Method to convert StudentModel to a JSON string
  String toJson() => json.encode(toMap());
}
