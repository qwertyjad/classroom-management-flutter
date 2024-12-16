import 'package:classroom_manangement/core/services/injection_container.dart';
import 'package:classroom_manangement/features/student_management/domain/entities/student.dart';
import 'package:classroom_manangement/features/student_management/presentation/add_edit_student.dart';
import 'package:classroom_manangement/features/student_management/presentation/cubit/student_cubit.dart';
import 'package:classroom_manangement/features/student_management/presentation/view_students_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewStudentsPage extends StatefulWidget {
  final Student student;

  const ViewStudentsPage({super.key, required this.student});

  @override
  State<ViewStudentsPage> createState() => _ViewStudentsPageState();
}

class _ViewStudentsPageState extends State<ViewStudentsPage> {
  late Student _currentStudent;

  @override
  void initState() {
    super.initState();
    _currentStudent = widget.student;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<StudentCubit, StudentState>(
      listener: (context, state) {
      if (state is StudentDeleted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        Navigator.pop(context, "Student Deleted");
      }
      else if (state is StudentError) {
            final snackBar = SnackBar(
            content: Text(state.message),
            duration: const Duration(seconds: 5),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_currentStudent.name),
          actions: [
            IconButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => serviceLocator<StudentCubit>(),
                      child: AddEditStudentPage(
                        student: _currentStudent,
                      ),
                    ),
                  ),
                );
                if (result.runtimeType == Student) {
                  setState(() {
                    _currentStudent = result;
                  });
                }
              },
              icon: const Icon(Icons.edit),
            ),
            IconButton(
                onPressed: () {
                  const snackBar = SnackBar(
                    content: Text('Deleting Students.....'),
                    duration: Duration(seconds: 10),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  context.read<StudentCubit>().deleteStudent(widget.student.id);
                },
                icon: const Icon(Icons.delete))
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            LabelValueRow(label: 'Name', value: _currentStudent.name),
            LabelValueRow(
                label: 'Contact Info', value: _currentStudent.contactInfo),
            LabelValueRow(
                label: 'Grade Level', value: _currentStudent.gradeLevel),
            LabelValueRow(label: 'Notes', value: _currentStudent.notes),
          ],
        ),
      ),
    );
  }
}
