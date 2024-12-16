import 'package:classroom_manangement/core/error/failure.dart';
import 'package:classroom_manangement/features/student_management/domain/entities/student.dart';
import 'package:classroom_manangement/features/student_management/domain/repositories/student_repository.dart';
import 'package:dartz/dartz.dart';

class GetStudentById {
  final StudentRepository studentRepository;

  GetStudentById(this.studentRepository);

  Future<Either<Failure, Student?>> call(String id) async {
    return await studentRepository.getStudentById(id);
  }
}
