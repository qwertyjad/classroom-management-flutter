
import 'package:classroom_manangement/features/attendance_tracking/data/data_source/attendance_remote_ds.dart';
import 'package:classroom_manangement/features/attendance_tracking/data/data_source/firebase_remote_data_source.dart';
import 'package:classroom_manangement/features/attendance_tracking/data/repository_impl/attendance_repo_impl.dart';
import 'package:classroom_manangement/features/attendance_tracking/domain/repositories/attendance_repo.dart';
import 'package:classroom_manangement/features/attendance_tracking/domain/usecase/delete_attendance.dart';
import 'package:classroom_manangement/features/attendance_tracking/domain/usecase/get_attendance.dart';
import 'package:classroom_manangement/features/attendance_tracking/domain/usecase/get_attendance_stu.dart';
import 'package:classroom_manangement/features/attendance_tracking/domain/usecase/make_attendance.dart';
import 'package:classroom_manangement/features/attendance_tracking/domain/usecase/update_attendance.dart';
import 'package:classroom_manangement/features/attendance_tracking/presentation/cubit/attendance_cubit.dart';
import 'package:classroom_manangement/features/student_management/data/data_source/firebase_remote_datasource.dart';
import 'package:classroom_manangement/features/student_management/data/data_source/student_remote_ds.dart';
import 'package:classroom_manangement/features/student_management/data/repository_impl/student_repo_impl.dart';
import 'package:classroom_manangement/features/student_management/domain/repositories/student_repository.dart';
import 'package:classroom_manangement/features/student_management/domain/usecase/add_student.dart';
import 'package:classroom_manangement/features/student_management/domain/usecase/delete_student.dart';
import 'package:classroom_manangement/features/student_management/domain/usecase/get_all_student.dart';
import 'package:classroom_manangement/features/student_management/domain/usecase/get_student.dart';
import 'package:classroom_manangement/features/student_management/domain/usecase/update_student.dart';
import 'package:classroom_manangement/features/student_management/presentation/cubit/student_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

final serviceLocator = GetIt.instance;

//manage dependencies

Future<void> init() async {
  //feature #1 service_planning
  // Presentation Layer
  serviceLocator.registerFactory(() => StudentCubit(serviceLocator(),
      serviceLocator(), serviceLocator(), serviceLocator(), serviceLocator()));
 
 serviceLocator.registerLazySingleton(() => AddStudent(serviceLocator()));
 serviceLocator.registerLazySingleton(() => DeleteStudent(serviceLocator()));
 serviceLocator.registerLazySingleton(() => GetAllStudents(serviceLocator()));
 serviceLocator.registerLazySingleton(() => GetStudentById(serviceLocator()));
  serviceLocator.registerLazySingleton(() => UpdateStudent(serviceLocator()));

   serviceLocator.registerLazySingleton<StudentRepository>(
      () => StudentRepositoryImplementation(serviceLocator()));
  serviceLocator.registerLazySingleton<StudentRemoteDataSource>(
      () => StudentFirebaseDataSource(serviceLocator()));
  serviceLocator.registerLazySingleton(() => FirebaseFirestore.instance);


//feature 2
serviceLocator.registerFactory(() => AttendanceCubit(serviceLocator(), 
serviceLocator(), serviceLocator(), serviceLocator(), serviceLocator()));

serviceLocator.registerLazySingleton(() => MarkAttendance(serviceLocator()));
serviceLocator.registerLazySingleton(() => DeleteAttendance(serviceLocator()));
serviceLocator.registerLazySingleton(() => GetAttendanceByDate(serviceLocator()));
serviceLocator.registerLazySingleton(() => GetAttendanceForStudent(serviceLocator()));
serviceLocator.registerLazySingleton(() => UpdateAttendance(serviceLocator()));


serviceLocator.registerLazySingleton<AttendanceRepository>(
      () => AttendanceRepositoryImplementation(serviceLocator()));
  serviceLocator.registerLazySingleton<AttendanceRemoteDataSource>(
      () => AttendanceFirebaseRemoteDataSource(serviceLocator()));
}