import 'package:classroom_manangement/core/error/failure.dart';
import 'package:classroom_manangement/features/student_management/data/repository_impl/student_repo_impl.dart';
import 'package:classroom_manangement/features/student_management/domain/entities/student.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';

import 'student_remote_ds_test.dart'; 


void main() {
  late MockStudentRepositoryImplementation mockStudentRepository;
  late StudentRepositoryImplementation studentRepository;

  setUp(() {
    mockStudentRepository = MockStudentRepositoryImplementation();
    studentRepository = mockStudentRepository;
  });

  
    final student = Student(
      id: '123',
      name: 'John Doe',
      contactInfo: 'johndoe@example.com',
      gradeLevel: 'Grade 10',
      notes: 'Excellent performance',
    );
group('addStudent', () {
    test('should return void when adding a student succeeds', () async {
      // Arrange
      when(() => mockStudentRepository.addStudent(student))
          .thenAnswer((_) async => Right(null));

      // Act
      final result = await studentRepository.addStudent(student);

      // Assert
      expect(result, Right(null));
      verify(() => mockStudentRepository.addStudent(student)).called(1);
    });

    test('should return a Failure when adding a student fails', () async {
      // Arrange
      final failure = Failure(message: 'Failed to add student');
      when(() => mockStudentRepository.addStudent(student))
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await studentRepository.addStudent(student);

      // Assert
      expect(result, Left(failure));
      verify(() => mockStudentRepository.addStudent(student)).called(1);
    });

    test('should throw an exception when a dependency fails', () async {
      // Arrange
      when(() => mockStudentRepository.addStudent(student))
          .thenThrow(Exception('Unexpected error'));

      // Act
      expect(
        () async => await studentRepository.addStudent(student),
        throwsA(isA<Exception>()),
      );

      // Assert
      verify(() => mockStudentRepository.addStudent(student)).called(1);
    });
  });
}
