import 'package:classroom_manangement/core/error/failure.dart';
import 'package:classroom_manangement/features/attendance_tracking/domain/entities/attendance.dart';
import 'package:dartz/dartz.dart';

abstract class AttendanceRepository {
  Future<Either<Failure, void>> markAttendance(Attendance attendance);
  Future<Either<Failure, List<Attendance>>>getAttendanceByDate(DateTime date);
  Future<Either<Failure, List<Attendance>>>getAttendanceForStudent();
  Future<Either<Failure, void>>  updateAttendance(Attendance attendance);
  Future<Either<Failure, void>> deleteAttendance(String studentId);
}
