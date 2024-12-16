part of 'attendance_cubit.dart';

abstract class AttendanceState extends Equatable {
  const AttendanceState();

  @override
  List<Object?> get props => [];
}

class AttendanceInitial extends AttendanceState {}

class AttendanceLoading extends AttendanceState {}

class AttendanceLoaded extends AttendanceState {
  final List<Attendance> attendances;
  const AttendanceLoaded(this.attendances);

  @override
  List<Object?> get props => [attendances];
}

class AttendanceError extends AttendanceState {
  final String message;
  const AttendanceError(this.message);

  @override
  List<Object?> get props => [message];
}

class AttendanceAdded extends AttendanceState {}

class AttendanceUpdated extends AttendanceState {
  final Attendance newAttendance;
  const AttendanceUpdated(this.newAttendance);

  @override
  List<Object?> get props => [newAttendance];
}

class AttendanceMarked extends AttendanceState {
  final Attendance attendance;
  const AttendanceMarked(this.attendance);

  @override
  List<Object?> get props => [attendance];
}

class AttendanceDeleted extends AttendanceState {}
