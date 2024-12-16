import 'package:classroom_manangement/features/student_management/domain/entities/student.dart';
import 'package:classroom_manangement/features/student_management/presentation/cubit/student_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class AddEditStudentPage extends StatefulWidget {
  final Student? student;

  const AddEditStudentPage({
    super.key,
    this.student,
  });

  @override
  State<AddEditStudentPage> createState() => _AddEditStudentPageState();
}

class _AddEditStudentPageState extends State<AddEditStudentPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isPerforming = false;

  @override
  Widget build(BuildContext context) {
    String appBarTitle = widget.student == null ? 'Add New Student' : 'Edit Student';
    String buttonLabel = widget.student == null ? 'Add Student' : 'Update Student';
    final initialValues = {
      'name': widget.student?.name,
      'contactInfo': widget.student?.contactInfo,
      'gradeLevel': widget.student?.gradeLevel,
      'notes': widget.student?.notes,
    };

    return BlocListener<StudentCubit, StudentState>(
      listener: (context, state) {
        if (state is StudentAdded) {
          Navigator.pop(context, "Student Created");
        } else if (state is StudentError) {
          final snackBar = SnackBar(
            content: Text(state.message),
            duration: const Duration(seconds: 5),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          setState(() {
            _isPerforming = false;
          });
        } else if (state is StudentUpdated) {
          Navigator.pop(context, state.newStudent);
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
                      name: 'name',
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Name',
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                      ]),
                    ),
                    const SizedBox(height: 16),
                    FormBuilderTextField(
                      name: 'contactInfo',
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Contact Info',
                      ),
                      keyboardType: TextInputType.phone,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.minLength(10, errorText: 'Enter a valid contact number'),
                      ]),
                    ),
                    const SizedBox(height: 16),
                    FormBuilderDropdown(
                      name: 'gradeLevel',
                      items: List.generate(12, (index) => (index + 1).toString())
                          .map((grade) => DropdownMenuItem(
                                value: grade,
                                child: Text('Grade $grade'),
                              ))
                          .toList(),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Grade Level',
                        hintText: 'Select Grade Level',
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                      ]),
                    ),
                    const SizedBox(height: 16),
                    FormBuilderTextField(
                      name: 'notes',
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Notes',
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: 4,
                    ),
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
                              final inputs = _formKey.currentState!.instantValue;

                              if (isValid) {
                                setState(() {
                                  _isPerforming = true;
                                });

                                final newStudent = Student(
                                  id: widget.student?.id ?? UniqueKey().toString(),
                                  name: inputs['name'],
                                  contactInfo: inputs['contactInfo'],
                                  gradeLevel: inputs['gradeLevel'],
                                  notes: inputs['notes'],
                                );

                                if (widget.student == null) {
                                  context.read<StudentCubit>().addStudent(newStudent);
                                } else {
                                  context.read<StudentCubit>().updateStudent(newStudent);
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
