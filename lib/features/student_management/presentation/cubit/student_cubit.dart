import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:classroom_manangement/core/error/failure.dart';
import 'package:classroom_manangement/features/student_management/domain/entities/student.dart';
import 'package:classroom_manangement/features/student_management/domain/usecase/add_student.dart';
import 'package:classroom_manangement/features/student_management/domain/usecase/delete_student.dart';
import 'package:classroom_manangement/features/student_management/domain/usecase/get_all_student.dart';
import 'package:classroom_manangement/features/student_management/domain/usecase/get_student.dart';
import 'package:classroom_manangement/features/student_management/domain/usecase/update_student.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
part 'student_state.dart';

const String noInternetErrorMessage =
    "Sync failed: Changes saved on your device and will sync once you're back online.";

class StudentCubit extends Cubit<StudentState> {
  final AddStudent addStudentUseCase;
  final UpdateStudent updateStudentUseCase;
  final DeleteStudent deleteStudentUseCase;
  final GetAllStudents getAllStudentsUseCase;
  final GetStudentById getStudentByIdUseCase;

  StudentCubit(
     this.addStudentUseCase,
     this.updateStudentUseCase,
     this.deleteStudentUseCase,
     this.getAllStudentsUseCase,
     this.getStudentByIdUseCase,
  ) : super(StudentInitial());

  // Fetch all students
  Future<void> getAllStudents() async {
    emit(StudentLoading());

    try {
      final result = await getAllStudentsUseCase().timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw TimeoutException("Request timed out"));

      result.fold(
        (failure) => emit(StudentError(failure.getMessage())),
        (students) {
          emit(StudentLoaded(students));
        },
      );
    } on TimeoutException catch (_) {
      emit(StudentError("There seems to be a problem with your internet connection"));
    }
  }

  // Get student by ID
  Future<void> getStudentById(String studentId) async {
    emit(StudentLoading());

    try {
      final result = await getStudentByIdUseCase.call(studentId).timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw TimeoutException("Request timed out"));

      result.fold(
        (failure) => emit(StudentError(failure.message)),
        (students) {
          emit(StudentLoaded(students as List<Student>)); // Wrap single student in list
        },
      );
    } on TimeoutException catch (_) {
      emit(StudentError("There seems to be a problem with your internet connection"));
    }
  }

  // Add a new student
  Future<void> addStudent(Student student) async {
    emit(StudentLoading());

    try {
      final result = await addStudentUseCase.call(student).timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw TimeoutException("Request timed out"));

      result.fold(
        (failure) => emit(StudentError(failure.message)),
        (_) {
          emit(StudentAdded());
        },
      );
    } on TimeoutException catch (_) {
      emit(const StudentError("Failed to add student due to timeout"));
    }
  }

  // Update existing student
  Future<void> updateStudent(Student student) async {
    emit(StudentLoading());

    try {
      final Either<Failure, void> result = await updateStudentUseCase
      .call(student)
      .timeout(const Duration(seconds: 10),
          onTimeout: () => throw TimeoutException("Request timed out"));

      result.fold(
        (failure) => emit(StudentError(failure.message)),
        (_) {
          emit(StudentUpdated(student));
        },
      );
    } on TimeoutException catch (_) {
      emit(StudentError("Failed to update student due to timeout"));
    }
  }

  // Delete a student
  Future<void> deleteStudent(String student) async {
    emit(StudentLoading());

    try {
      final Either<Failure, void> result = await deleteStudentUseCase
         .call(student)
         .timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw TimeoutException("Request timed out"));

      result.fold(
        (failure) => emit(StudentError(failure.message)),
        (_) {
          emit(StudentDeleted());
        },
      );
    } on TimeoutException catch (_) {
      emit(StudentError("Failed to delete student due to timeout"));
    }
  }
}
