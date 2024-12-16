import 'package:classroom_manangement/core/error/failure.dart';
import 'package:classroom_manangement/features/attendance_tracking/domain/entities/attendance.dart';
import 'package:classroom_manangement/features/attendance_tracking/domain/repositories/attendance_repo.dart';
import 'package:dartz/dartz.dart';

class MarkAttendance {
  final AttendanceRepository repository;

  MarkAttendance( this.repository);

  Future<Either<Failure ,void>> call(Attendance attendance) async  =>
    await repository.markAttendance(attendance);
  
}
