import 'package:classroom_manangement/core/services/injection_container.dart';
import 'package:classroom_manangement/core/widget/empty_state.dart';
import 'package:classroom_manangement/core/widget/error_state.dart';
import 'package:classroom_manangement/core/widget/loading_state_shimmer.dart';
import 'package:classroom_manangement/features/student_management/presentation/add_edit_student.dart';
import 'package:classroom_manangement/features/student_management/presentation/cubit/student_cubit.dart';
import 'package:classroom_manangement/features/student_management/presentation/view_students.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewAllStudentPage extends StatefulWidget {
  const ViewAllStudentPage({super.key});

  @override
  State<ViewAllStudentPage> createState() => _ViewAllStudentPageState();
}

class _ViewAllStudentPageState extends State<ViewAllStudentPage> {
  @override
  void initState() {
    super.initState();
    context.read<StudentCubit>().getAllStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Students'),
      ),
      body: BlocBuilder<StudentCubit, StudentState>(
        builder: (context, state) {
          if (state is StudentLoading) {
            return const LoadingStateShimmerList();
          } else if (state is StudentLoaded) {
            if (state.students.isEmpty) {
              return const EmptyStateList(
                imageAssetName: 'assets/images/empty-box.png',
                title: 'Oops...There are no students here',
                description: "Tap '+' button to add a new student",
              );
            }

            return ListView.builder(
              itemCount: state.students.length,
              itemBuilder: (context, index) {
                final currentStudent = state.students[index];

                return Card(
                  child: ListTile(
                    title: Text("Name: ${currentStudent.name}"),
                    subtitle: Text("Grade Level : ${currentStudent.gradeLevel}"),
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) => serviceLocator<StudentCubit>(),
                            child: ViewStudentsPage(student: currentStudent),
                          ),
                        ),
                      );
                      context.read<StudentCubit>().getAllStudents(); // Refresh the page

                      if (result.runtimeType == String) {
                        final snackBar = SnackBar(content: Text(result as String));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                  ),
                );
              },
            );
          } else if (state is StudentError) {
            return ErrorStateList(
              imageAssetName: 'assets/images/error.png',
              errorMessage: state.message,
              onRetry: () {
                context.read<StudentCubit>().getAllStudents();
              },
            );
          } else {
            return const EmptyStateList(
              imageAssetName: 'assets/images/empty-box.png',
              title: 'Oops...There are no students here',
              description: "Tap '+' button to add a new student",
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'addStudentButton', // Unique tag for this FloatingActionButton
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => serviceLocator<StudentCubit>(),
                child: const AddEditStudentPage(),
              ),
            ),
          );

          context.read<StudentCubit>().getAllStudents(); // Refresh the page

          if (result.runtimeType == String) {
            final snackBar = SnackBar(content: Text(result as String));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
