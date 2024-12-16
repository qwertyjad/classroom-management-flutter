import 'package:classroom_manangement/features/student_management/domain/entities/student.dart';

abstract class StudentRemoteDataSource {
  Future<void> addStudent(Student student);
  Future<Student?> getStudentById(String id);
  Future<List<Student>>getAllStudents();
  Future<void>updateStudent(Student student);
  Future<void>  deleteStudent(String id);
}
