import 'package:classroom_manangement/core/services/injection_container.dart';
import 'package:classroom_manangement/features/attendance_tracking/presentation/cubit/attendance_cubit.dart';
import 'package:classroom_manangement/features/attendance_tracking/presentation/view_all_attendance.dart';
import 'package:classroom_manangement/features/student_management/presentation/cubit/student_cubit.dart';
import 'package:classroom_manangement/features/student_management/presentation/view_all_student.dart';
import 'package:classroom_manangement/firebase_options.dart';
import 'package:classroom_manangement/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      themeMode: ThemeMode.light,
      theme: GlobalThemeData.lightThemeData,
      home: const MyHomePage(title: "Classroom Management"),
      debugShowCheckedModeBanner: false,
    );
  }
}
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          BlocProvider(
            create: (context) => serviceLocator<StudentCubit>(),
            child: ViewAllStudentPage(),
          ),
          BlocProvider(
            create: (context) => serviceLocator<AttendanceCubit>(),
            child: ViewAllAttendancePage(),
          ),
          const Center(
            child: Text('Insert Account Page'),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add),
            label: "Add Student",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fact_check),
            label: "Attendance",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.face),
            label: "Account",
          ),
        ],
      ),
    );
  }
}
