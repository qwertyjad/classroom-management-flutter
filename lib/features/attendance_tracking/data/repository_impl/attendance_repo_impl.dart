import 'package:classroom_manangement/core/error/exceptions.dart';
import 'package:classroom_manangement/core/error/failure.dart';
import 'package:classroom_manangement/features/attendance_tracking/domain/entities/attendance.dart';
import 'package:classroom_manangement/features/attendance_tracking/domain/repositories/attendance_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:classroom_manangement/features/attendance_tracking/data/data_source/attendance_remote_ds.dart';

class AttendanceRepositoryImplementation implements AttendanceRepository {
  final AttendanceRemoteDataSource _remoteDataSource;

  const AttendanceRepositoryImplementation(this._remoteDataSource);

  @override
  Future<Either<Failure, void>> markAttendance(Attendance attendance) async {
    try {
      
      return Right(await _remoteDataSource.markAttendance(attendance)); // Return success (void)
    } on APIException catch (e) {
      return Left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch (e) {
      return Left(GeneralFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Attendance>>> getAttendanceByDate(DateTime date) async {
    try {
      
      return Right( await _remoteDataSource.getAttendanceByDate(date)); // Return list of attendance
    } on APIException catch (e) {
      return Left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch (e) {
      return Left(GeneralFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Attendance>>> getAttendanceForStudent() async {
    try {
      return Right(await _remoteDataSource.getAttendanceForStudent()); // Return list of attendance for student
    } on APIException catch (e) {
      return Left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch (e) {
      return Left(GeneralFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateAttendance(Attendance attendance) async {
    try {
     
      return Right( await _remoteDataSource.updateAttendance(attendance)); // Return success (void)
    } on APIException catch (e) {
      return Left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch (e) {
      return Left(GeneralFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAttendance(String studentId) async {
    try {
     
      return Right( await _remoteDataSource.deleteAttendance(studentId)); // Return success (void)
    } on APIException catch (e) {
      return Left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch (e) {
      return Left(GeneralFailure(message: e.toString()));
    }
  }
}
