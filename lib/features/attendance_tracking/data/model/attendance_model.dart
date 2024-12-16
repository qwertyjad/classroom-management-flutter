import 'package:classroom_manangement/features/attendance_tracking/domain/entities/attendance.dart';
import 'dart:convert';

// Data layer model class
class AttendanceModel extends Attendance {
  const AttendanceModel({
    required String studentId,
    required DateTime date,
    required bool isPresent,
  }) : super(
          studentId: studentId,
          date: date,
          isPresent: isPresent,
        );

  // Factory constructor to create an AttendanceModel from a Map
  factory AttendanceModel.fromMap(Map<String, dynamic> map) {
    return AttendanceModel(
      studentId: map['studentId'] as String,
      date: DateTime.parse(map['date'] as String),
      isPresent: map['isPresent'] as bool,
    );
  }

  // Factory constructor to create an AttendanceModel from a JSON string
  factory AttendanceModel.fromJson(String source) =>
      AttendanceModel.fromMap(json.decode(source));

  // Method to convert AttendanceModel to a Map
  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'date': date.toIso8601String(),
      'isPresent': isPresent,
    };
  }

  // Method to convert AttendanceModel to a JSON string
  String toJson() => json.encode(toMap());
}
