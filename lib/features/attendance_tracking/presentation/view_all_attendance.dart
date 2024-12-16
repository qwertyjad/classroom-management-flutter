import 'package:classroom_manangement/core/services/injection_container.dart';
import 'package:classroom_manangement/core/widget/empty_state.dart';
import 'package:classroom_manangement/core/widget/error_state.dart';
import 'package:classroom_manangement/core/widget/loading_state_shimmer.dart';
import 'package:classroom_manangement/features/attendance_tracking/presentation/add_edit_attendance.dart';
import 'package:classroom_manangement/features/attendance_tracking/presentation/cubit/attendance_cubit.dart';
import 'package:classroom_manangement/features/attendance_tracking/presentation/view_attendance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewAllAttendancePage extends StatefulWidget {
  const ViewAllAttendancePage({super.key});

  @override
  State<ViewAllAttendancePage> createState() => _ViewAllAttendancePageState();
}

class _ViewAllAttendancePageState extends State<ViewAllAttendancePage> {
  @override
  void initState() {
    super.initState();
    context.read<AttendanceCubit>().getAllAttendanceForStudentUseCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance'),
      ),
      body: BlocBuilder<AttendanceCubit, AttendanceState>(
        builder: (context, state) {
          if (state is AttendanceLoading) {
            return const LoadingStateShimmerList();
          } else if (state is AttendanceLoaded) {
            if (state.attendances.isEmpty) {
              return const EmptyStateList(
                imageAssetName: 'assets/images/empty-box.png',
                title: 'Oops...There are no attendance records here',
                description: "Tap '+' button to add a new attendance record",
              );
            }

            return ListView.builder(
              itemCount: state.attendances.length,
              itemBuilder: (context, index) {
                final currentAttendance = state.attendances[index];

                return Card(
                  child: ListTile(
                    title: Text("Student ID: ${currentAttendance.studentId}"),
                    subtitle: Text(
                        "Date: ${currentAttendance.date.toIso8601String()}"),
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider.value(
                            value: context.read<AttendanceCubit>(), // Use the existing cubit
                            child: ViewAttendancePage(attendance: currentAttendance),
                          ),
                        ),
                      );

                      context.read<AttendanceCubit>().getAllAttendance(); // Refresh the list

                      if (result is String) {
                        final snackBar = SnackBar(content: Text(result));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                  ),
                );
              },
            );
          } else if (state is AttendanceError) {
            return ErrorStateList(
              imageAssetName: 'assets/images/error.png',
              errorMessage: state.message,
              onRetry: () {
                context.read<AttendanceCubit>().getAllAttendance();
              },
            );
          } else {
            return const EmptyStateList(
              imageAssetName: 'assets/images/empty-box.png',
              title: 'Oops...There are no attendance records here',
              description: "Tap '+' button to add a new attendance record",
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Attendance',
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider.value(
                value: context.read<AttendanceCubit>(), // Use the existing cubit
                child: const AddEditAttendancePage(),
              ),
            ),
          );

          context.read<AttendanceCubit>().getAllAttendance(); // Refresh the list

          if (result is String) {
            final snackBar = SnackBar(content: Text(result));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}