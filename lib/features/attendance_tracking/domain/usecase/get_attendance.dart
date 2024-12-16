import 'package:classroom_manangement/core/error/failure.dart';
import 'package:classroom_manangement/features/attendance_tracking/domain/entities/attendance.dart';
import 'package:classroom_manangement/features/attendance_tracking/domain/repositories/attendance_repo.dart';
import 'package:dartz/dartz.dart';

class GetAttendanceByDate {
  final AttendanceRepository attendanceRepository;

  GetAttendanceByDate(this.attendanceRepository);

  Future<Either<Failure, List<Attendance>>> call(DateTime date) async =>
    await attendanceRepository.getAttendanceByDate(date);
}
