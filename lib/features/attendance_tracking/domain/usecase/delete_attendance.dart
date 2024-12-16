import 'package:classroom_manangement/core/error/failure.dart';
import 'package:classroom_manangement/features/attendance_tracking/domain/repositories/attendance_repo.dart';
import 'package:dartz/dartz.dart';

class DeleteAttendance {
  final AttendanceRepository attendanceRepository;

  DeleteAttendance(this.attendanceRepository);

  Future<Either<Failure, void>> call(String studentId) async =>
    await attendanceRepository.deleteAttendance(studentId);
  
}
