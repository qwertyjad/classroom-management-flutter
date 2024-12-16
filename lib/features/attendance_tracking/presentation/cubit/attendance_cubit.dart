
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:classroom_manangement/core/error/failure.dart';
import 'package:classroom_manangement/features/attendance_tracking/domain/entities/attendance.dart';
import 'package:classroom_manangement/features/attendance_tracking/domain/usecase/delete_attendance.dart';
import 'package:classroom_manangement/features/attendance_tracking/domain/usecase/get_attendance.dart';
import 'package:classroom_manangement/features/attendance_tracking/domain/usecase/get_attendance_stu.dart';
import 'package:classroom_manangement/features/attendance_tracking/domain/usecase/make_attendance.dart';
import 'package:classroom_manangement/features/attendance_tracking/domain/usecase/update_attendance.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

part 'attendance_state.dart';

const String noInternetErrorMessage =
    "Sync failed: Changes saved on your device and will sync once you're back online.";

class AttendanceCubit extends Cubit<AttendanceState> {
  final MarkAttendance markAttendanceUseCase;
  final DeleteAttendance deleteAttendanceUseCase;
  final GetAttendanceByDate getAttendanceByDateUseCase;
  final GetAttendanceForStudent getAllAttendanceForStudentUseCase;
  final UpdateAttendance updateAttendanceUseCase;

  AttendanceCubit(
    this.markAttendanceUseCase,
    this.deleteAttendanceUseCase,
    this.getAttendanceByDateUseCase,
    this.getAllAttendanceForStudentUseCase,
    this.updateAttendanceUseCase,
  ) : super(AttendanceInitial());

Future<void> getAllAttendance() async {
  emit(AttendanceLoading());

  try {
    // Ensure timeout is applied to the Future, not the result
    final result = await getAllAttendanceForStudentUseCase.call().timeout(
      const Duration(seconds: 10),
      onTimeout: () => throw TimeoutException("Request timed out"),
    );

    result.fold(
      (failure) => emit(AttendanceError(failure.getMessage())),
      (attendance) {
        emit(AttendanceLoaded(attendance));
      },
    );
  } on TimeoutException catch (_) {
    emit(AttendanceError("There seems to be a problem with your internet connection"));
  }
}




  // Add a new attendance record
  Future<void> addAttendance(Attendance newAttendance) async {
    emit(AttendanceLoading());

    try {
      final result = await markAttendanceUseCase.call(newAttendance).timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw TimeoutException("Request timed out"));

      result.fold(
        (failure) => emit(AttendanceError(failure.message)),
        (_) {
          emit(AttendanceAdded());
        },
      );
    } on TimeoutException catch (_) {
      emit(AttendanceError("Failed to add attendance due to timeout"));
    }
  }

  // Update an existing attendance record
  Future<void> updateAttendance(Attendance attendance) async {
    emit(AttendanceLoading());

    try {
      final Either<Failure, void> result = await updateAttendanceUseCase
          .call(attendance)
          .timeout(const Duration(seconds: 10),
              onTimeout: () => throw TimeoutException("Request timed out"));

      result.fold(
        (failure) => emit(AttendanceError(failure.message)),
        (_) {
          emit(AttendanceUpdated(attendance));
        },
      );
    } on TimeoutException catch (_) {
      emit(AttendanceError("Failed to update attendance due to timeout"));
    }
  }

  // Delete an attendance record
  Future<void> deleteAttendance(Attendance studentId) async {
    emit(AttendanceLoading());

    try {
      final Either<Failure, void> result = await deleteAttendanceUseCase
          .call(studentId as String)
          .timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw TimeoutException("Request timed out"));

      result.fold(
        (failure) => emit(AttendanceError(failure.message)),
        (_) {
          emit(AttendanceDeleted());
        },
      );
    } on TimeoutException catch (_) {
      emit(AttendanceError("Failed to delete attendance due to timeout"));
    }
  }

  // Mark attendance for a student
  Future<void> markAttendance(Attendance attendance) async {
    emit(AttendanceLoading());

    try {
      final result = await markAttendanceUseCase.call(attendance).timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw TimeoutException("Request timed out"));

      result.fold(
        (failure) => emit(AttendanceError(failure.message)),
        (_) {
          emit(AttendanceMarked(attendance));
        },
      );
    } on TimeoutException catch (_) {
      emit(AttendanceError("Failed to mark attendance due to timeout"));
    }
  }
}
