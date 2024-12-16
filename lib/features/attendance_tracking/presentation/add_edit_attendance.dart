import 'package:classroom_manangement/features/attendance_tracking/domain/entities/attendance.dart';
import 'package:classroom_manangement/features/attendance_tracking/presentation/cubit/attendance_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class AddEditAttendancePage extends StatefulWidget {
  final Attendance? attendance;

  const AddEditAttendancePage({
    super.key,
    this.attendance,
  });

  @override
  State<AddEditAttendancePage> createState() => _AddEditAttendancePageState();
}

class _AddEditAttendancePageState extends State<AddEditAttendancePage> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isPerforming = false;

  @override
  Widget build(BuildContext context) {
    String appBarTitle = widget.attendance == null ? 'Add New Attendance' : 'Edit Attendance';
    String buttonLabel = widget.attendance == null ? 'Add Attendance' : 'Update Attendance';
    final initialValues = {
      'studentId': widget.attendance?.studentId,
      'date': widget.attendance?.date?.toIso8601String(),
      'isPresent': widget.attendance?.isPresent,
    };

    return BlocListener<AttendanceCubit, AttendanceState>(
      listener: (context, state) {
        if (state is AttendanceAdded) {
          Navigator.pop(context, "Attendance Created");
        } else if (state is AttendanceError) {
          final snackBar = SnackBar(
            content: Text(state.message),
            duration: const Duration(seconds: 5),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          setState(() {
            _isPerforming = false;
          });
        } else if (state is AttendanceUpdated) {
          Navigator.pop(context, state.newAttendance);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle),
        ),
        body: Column(
          children: [
            Expanded(
              child: FormBuilder(
                key: _formKey,
                initialValue: initialValues,
                child: ListView(
                  padding: const EdgeInsets.all(8.0),
                  children: [
                    FormBuilderTextField(
                      name: 'studentId',
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Student ID',
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                      ]),
                    ),
                    const SizedBox(height: 16),
                    FormBuilderDateTimePicker(
                      name: 'date',
                      inputType: InputType.date,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Date',
                      ),
                      validator: FormBuilderValidators.required(),
                    ),
                    const SizedBox(height: 16),
                    FormBuilderCheckbox(
                      name: 'isPresent',
                      title: const Text('Present'),
                      initialValue: widget.attendance?.isPresent ?? false,
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel"),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isPerforming
                          ? null
                          : () {
                              bool isValid = _formKey.currentState!.validate();
                              final inputs = _formKey.currentState!.value;

                              if (isValid) {
                                setState(() {
                                  _isPerforming = true;
                                });

                                final newAttendance = Attendance(
                                  studentId: inputs['studentId'],
                                  date: inputs['date'],
                                  isPresent: inputs['isPresent'] ?? false,
                                );

                                if (widget.attendance == null) {
                                  context.read<AttendanceCubit>().addAttendance(newAttendance);
                                } else {
                                  context.read<AttendanceCubit>().updateAttendance(newAttendance);
                                }
                              }
                            },
                      child: _isPerforming
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(buttonLabel),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
