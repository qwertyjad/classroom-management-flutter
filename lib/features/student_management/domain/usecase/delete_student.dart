import 'package:classroom_manangement/core/error/failure.dart';
import 'package:classroom_manangement/features/student_management/domain/repositories/student_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteStudent {
  final StudentRepository studentRepository;

  DeleteStudent( this.studentRepository);

  Future<Either<Failure, void>> call(String id)  async => 
    await studentRepository.deleteStudent(id);
}
