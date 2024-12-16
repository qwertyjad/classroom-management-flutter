import 'package:classroom_manangement/core/error/failure.dart';
import 'package:classroom_manangement/features/student_management/domain/entities/student.dart';
import 'package:classroom_manangement/features/student_management/domain/repositories/student_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateStudent {
  final StudentRepository studentRepository;

  UpdateStudent( this.studentRepository);

  Future<Either<Failure, void>>  call(Student student) async =>
    await studentRepository.updateStudent(student);
  
}
