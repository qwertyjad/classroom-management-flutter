import 'package:classroom_manangement/core/services/injection_container.dart';
import 'package:classroom_manangement/features/attendance_tracking/domain/entities/attendance.dart';
import 'package:classroom_manangement/features/attendance_tracking/presentation/add_edit_attendance.dart';
import 'package:classroom_manangement/features/attendance_tracking/presentation/cubit/attendance_cubit.dart';
import 'package:classroom_manangement/features/attendance_tracking/presentation/view_attendance_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewAttendancePage extends StatefulWidget {
  final Attendance attendance;

  const ViewAttendancePage({super.key, required this.attendance});

  @override
  State<ViewAttendancePage> createState() => _ViewAttendancePageState();
}

class _ViewAttendancePageState extends State<ViewAttendancePage> {
  late Attendance _currentAttendance;

  @override
  void initState() {
    super.initState();
    _currentAttendance = widget.attendance;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AttendanceCubit, AttendanceState>(
      listener: (context, state) {
        if (state is AttendanceDeleted) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          Navigator.pop(context, "Attendance Record Deleted");
        } else if (state is AttendanceError) {
          final snackBar = SnackBar(
            content: Text(state.message),
            duration: const Duration(seconds: 5),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Attendance: ${_currentAttendance.studentId}'),
          actions: [
            IconButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => serviceLocator<AttendanceCubit>(),
                      child: AddEditAttendancePage(
                        attendance: _currentAttendance,
                      ),
                    ),
                  ),
                );
                if (result.runtimeType == Attendance) {
                  setState(() {
                    _currentAttendance = result;
                  });
                }
              },
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () {
                const snackBar = SnackBar(
                  content: Text('Deleting Attendance Record...'),
                  duration: Duration(seconds: 10),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                context.read<AttendanceCubit>().deleteAttendance(widget.attendance);
              },
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            LabelValueRow(label: 'Student ID', value: _currentAttendance.studentId),
            LabelValueRow(label: 'Date', value: _currentAttendance.date.toIso8601String()),
            LabelValueRow(label: 'Status', value: _currentAttendance.isPresent ? 'Present' : 'Absent'),
          ],
        ),
      ),
    );
  }
}
