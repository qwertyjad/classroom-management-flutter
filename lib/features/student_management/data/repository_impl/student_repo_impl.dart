import 'package:classroom_manangement/core/error/exceptions.dart';
import 'package:classroom_manangement/core/error/failure.dart';
import 'package:classroom_manangement/features/student_management/data/data_source/student_remote_ds.dart';
import 'package:classroom_manangement/features/student_management/domain/entities/student.dart';
import 'package:classroom_manangement/features/student_management/domain/repositories/student_repository.dart';
import 'package:dartz/dartz.dart';

class StudentRepositoryImplementation implements StudentRepository {
  final StudentRemoteDataSource _remoteDataSource;

  const StudentRepositoryImplementation(this._remoteDataSource);

  @override
  Future<Either<Failure, void>> addStudent(Student student) async {
    try {
      return Right(await _remoteDataSource.addStudent(student)); // Return success (void)
    } on APIException catch (e) {
      return Left(APIFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, void>> deleteStudent(String id) async {
    try {
      return Right(await _remoteDataSource.deleteStudent(id)); // Return success (void)
    } on APIException catch (e) {
      return Left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch (e) {
      return Left(GeneralFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Student>>> getAllStudents() async {
    try {
      return Right(await _remoteDataSource.getAllStudents()); // Return the list of students
    } on APIException catch (e) {
      return Left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch (e) {
      return Left(GeneralFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Student?>> getStudentById(String id) async {
    try {
      return Right(await _remoteDataSource.getStudentById(id)); // Return the student if found
    } on APIException catch (e) {
      return Left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch (e) {
      return Left(GeneralFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateStudent(Student student) async {
    try {
      return Right(await _remoteDataSource.updateStudent(student)); // Return success (void)
    } on APIException catch (e) {
      return Left(APIFailure(message: e.message, statusCode: e.statusCode));
    } on Exception catch (e) {
      return Left(GeneralFailure(message: e.toString()));
    }
  }
}
