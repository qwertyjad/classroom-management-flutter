import 'package:equatable/equatable.dart';

class Attendance extends Equatable {
  final String studentId; // The student ID related to the attendance record
  final DateTime date; // The date of attendance
  final bool isPresent; // Whether the student was present

  const Attendance({
    required this.studentId,
    required this.date,
    required this.isPresent,
  });

  // Convert the Attendance object to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'date': date.toIso8601String(), // Convert DateTime to string
      'isPresent': isPresent,
    };
  }

  // Convert Firestore document to an Attendance object
  factory Attendance.fromMap(Map<String, dynamic> map) {
    return Attendance(
      studentId: map['studentId'],
      date: DateTime.parse(map['date']), // Convert string back to DateTime
      isPresent: map['isPresent'],
    );
  }

  @override
  List<Object?> get props => [studentId];
}
