import 'package:classroom_manangement/core/error/failure.dart';
import 'package:classroom_manangement/features/student_management/domain/entities/student.dart';
import 'package:dartz/dartz.dart';

abstract class StudentRepository {
  Future<Either<Failure, void>> addStudent(Student student);
  Future<Either<Failure, Student?>> getStudentById(String id);
  Future<Either<Failure, List<Student>>> getAllStudents();
  Future<Either<Failure, void>> updateStudent(Student student);
  Future<Either<Failure, void>> deleteStudent(String id);
}
