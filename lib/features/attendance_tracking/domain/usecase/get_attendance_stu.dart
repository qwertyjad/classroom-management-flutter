import 'package:classroom_manangement/core/error/failure.dart';
import 'package:classroom_manangement/features/attendance_tracking/domain/entities/attendance.dart';
import 'package:classroom_manangement/features/attendance_tracking/domain/repositories/attendance_repo.dart';
import 'package:dartz/dartz.dart';

class GetAttendanceForStudent {
  final AttendanceRepository attendanceRepository;

  GetAttendanceForStudent( this.attendanceRepository);

 Future<Either<Failure, List<Attendance>>>call() async =>
      attendanceRepository.getAttendanceForStudent();
  
}
