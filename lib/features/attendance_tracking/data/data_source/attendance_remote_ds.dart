import 'package:classroom_manangement/features/attendance_tracking/domain/entities/attendance.dart';

abstract class AttendanceRemoteDataSource {
  Future<void> markAttendance(Attendance attendance);
  Future<List<Attendance>>getAttendanceByDate(DateTime date);
  Future<List<Attendance>>getAttendanceForStudent();
  Future<void> updateAttendance(Attendance attendance);
  Future<void> deleteAttendance(String studentId);
}
