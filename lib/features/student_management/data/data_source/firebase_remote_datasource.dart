import 'package:classroom_manangement/core/error/exceptions.dart';
import 'package:classroom_manangement/features/student_management/data/data_source/student_remote_ds.dart';
import 'package:classroom_manangement/features/student_management/data/models/student_model.dart';
import 'package:classroom_manangement/features/student_management/domain/entities/student.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class StudentFirebaseDataSource implements StudentRemoteDataSource {
  final FirebaseFirestore _firestore;

  StudentFirebaseDataSource(this._firestore);

  @override
  Future<void> addStudent(Student student) async {
    try {
      final studentDocRef = _firestore.collection('students').doc();
      final studentModel = StudentModel(
        id: studentDocRef.id, 
        name: student.name, 
        contactInfo: student.contactInfo, 
        gradeLevel: student.gradeLevel, 
        notes: student.notes);
        await studentDocRef.set(studentModel.toMap());

  } on FirebaseException catch(e){
    throw APIException(
      message: e.message ?? 'Unknown Error', 
      statusCode: e.code);
  } on APIException{
    rethrow;
  } catch (e) {
      throw APIException(message: toString(), statusCode: '500');
    }
  }

  @override
  Future<void> deleteStudent(String id) async {
    try {
      await _firestore.collection('students').doc(id).delete();
    } on FirebaseException catch(e){
    throw APIException(
      message: e.message ?? 'Unknown Error', 
      statusCode: e.code);
  } on APIException{
    rethrow;
  } catch (e) {
      throw APIException(message: toString(), statusCode: '500');
    }
  }

  @override
  Future<List<Student>> getAllStudents() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('students').get();
      return querySnapshot.docs.map((doc) {
        return Student(
          id: doc.id,
          name: doc['name'],
          contactInfo: doc['contactInfo'],
          gradeLevel: doc['gradeLevel'],
          notes: doc['notes'],
        );
      }).toList();
    } on FirebaseException catch(e){
    throw APIException(
      message: e.message ?? 'Unknown Error', 
      statusCode: e.code);
  } on APIException{
    rethrow;
  } catch (e) {
      throw APIException(message: toString(), statusCode: '500');
    }
  }

  @override
  Future<Student?> getStudentById(String id) async {
    try {
      DocumentSnapshot docSnapshot = await _firestore.collection('students').doc(id).get();
      if (docSnapshot.exists) {
        return Student(
          id: docSnapshot.id,
          name: docSnapshot['name'],
          contactInfo: docSnapshot['contactInfo'],
          gradeLevel: docSnapshot['gradeLevel'],
          notes: docSnapshot['notes'],
        );
      } else {
        throw Exception('Student not found');
      }
    } on FirebaseException catch(e){
    throw APIException(
      message: e.message ?? 'Unknown Error', 
      statusCode: e.code);
  } on APIException{
    rethrow;
  } catch (e) {
      throw APIException(message: toString(), statusCode: '500');
    }
  }

  @override
  Future<void> updateStudent(Student student) async {
    final studentModel = StudentModel(
      id: student.id, 
      name: student.name,
        contactInfo: student.contactInfo,
        gradeLevel: student.gradeLevel,
        notes: student.notes);
    try {
      await _firestore.collection('students').doc(student.id).update(studentModel.toMap());
    } on FirebaseException catch(e){
    throw APIException(
      message: e.message ?? 'Unknown Error', 
      statusCode: e.code);
  } on APIException{
    rethrow;
  } catch (e) {
      throw APIException(message: toString(), statusCode: '500');
    }
  }
}
 