import 'package:equatable/equatable.dart';

class Student extends Equatable{
  final String id; // Unique identifier
  final String name;
  final String contactInfo;
  final String gradeLevel;
  final String notes;

  const Student({
    required this.id,
    required this.name,
    required this.contactInfo,
    required this.gradeLevel,
    required this.notes,
  });

  @override
  List<Object> get props => [id];
  }

