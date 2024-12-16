part of 'student_cubit.dart';

abstract class StudentState extends Equatable {
  const StudentState();

  @override
  List<Object> get props => [];

  // To be used for error messages in specific states
  get message => null;
}

class StudentInitial extends StudentState {}

class StudentLoading extends StudentState {}

class StudentLoaded extends StudentState {
  final List<Student> students;

  const StudentLoaded(this.students);

  @override
  List<Object> get props => [students];
}

class StudentAdded extends StudentState {}

class StudentDeleted extends StudentState {}

class StudentUpdated extends StudentState {
  final Student newStudent;

  const StudentUpdated(this.newStudent);

  @override
  List<Object> get props => [newStudent];
}

class StudentError extends StudentState {
  @override
  final String message;

  const StudentError(this.message);

  @override
  List<Object> get props => [message];
}
