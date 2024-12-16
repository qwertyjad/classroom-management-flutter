import 'package:classroom_manangement/core/error/exceptions.dart';
import 'package:classroom_manangement/features/attendance_tracking/data/data_source/attendance_remote_ds.dart';
import 'package:classroom_manangement/features/attendance_tracking/domain/entities/attendance.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class AttendanceFirebaseRemoteDataSource implements AttendanceRemoteDataSource {
  FirebaseFirestore _firestore;

  AttendanceFirebaseRemoteDataSource(this._firestore);

  @override
  Future<void> deleteAttendance(String studentId) async {
    try {
      // Assuming a collection called "attendance" exists in Firestore
      await _firestore.collection('attendance').doc('$studentId').delete();
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
  Future<List<Attendance>> getAttendanceByDate(DateTime date) async {
    try {
      // Fetch attendance for the specific date
      QuerySnapshot snapshot = await _firestore
          .collection('attendance')
          .where('date', isEqualTo: date.toIso8601String())
          .get();

      // Convert the snapshot to a list of Attendance objects
      return snapshot.docs.map((doc) => Attendance.fromMap(doc.data() as Map<String, dynamic>)).toList();
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
  Future<List<Attendance>> getAttendanceForStudent() async {
    try {
      // Fetch attendance for the specific student
      QuerySnapshot snapshot = await _firestore
          .collection('attendance')
          .where('studentId')
          .get();

      // Convert the snapshot to a list of Attendance objects
      return snapshot.docs.map((doc) => Attendance.fromMap(doc.data() as Map<String, dynamic>)).toList();
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
  Future<void> markAttendance(Attendance attendance) async {
    try {
      // Add attendance to Firestore
      await _firestore.collection('attendance').doc('${attendance.studentId}-${attendance.date.toIso8601String()}').set(attendance.toMap());
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
  Future<void> updateAttendance(Attendance attendance) async {
    try {
      // Update attendance record in Firestore
      await _firestore.collection('attendance').doc('${attendance.studentId}-${attendance.date.toIso8601String()}').update(attendance.toMap());
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
