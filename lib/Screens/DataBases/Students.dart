import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:student_app/Controllers/UserController.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection('students');

class Students {
  String get userUid => Get.context.read<UserController>().user.uid;

  Future<void> addStudent({
    @required String name,
    @required String classId,
  }) async {
    DocumentReference documentReferencer =
        _mainCollection.doc(userUid).collection('student').doc();

    Map<String, dynamic> data = <String, dynamic>{
      "name": name,
      "class_id": classId,
      "created_at": DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()),
    };

    await documentReferencer
        .set(data)
        .whenComplete(() => print("Student added to the database"))
        .catchError((e) => print(e));
  }

  Stream<QuerySnapshot> readStudents({
    @required String classId,
  }) {
    return _mainCollection
        .doc(userUid)
        .collection('student')
        .where("class_id", isEqualTo: classId)
        .snapshots();
  }

  Future<void> deleteStudent({
    @required String docId,
  }) async {
    DocumentReference documentReferencer =
        _mainCollection.doc(userUid).collection('student').doc(docId);

    await documentReferencer
        .delete()
        .whenComplete(() => print('Student deleted from the database'))
        .catchError((e) => print(e));
  }
}
