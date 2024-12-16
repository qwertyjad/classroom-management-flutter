import 'package:classroom_manangement/core/error/failure.dart';
import 'package:classroom_manangement/features/student_management/domain/entities/student.dart';
import 'package:classroom_manangement/features/student_management/domain/repositories/student_repository.dart';
import 'package:dartz/dartz.dart';

class GetAllStudents {
  final StudentRepository studentRepository;

  GetAllStudents( this.studentRepository);

  Future<Either<Failure, List<Student>>> call() async =>
      await studentRepository.getAllStudents();
  
}
