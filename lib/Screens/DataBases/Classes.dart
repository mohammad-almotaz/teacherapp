import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:student_app/Controllers/UserController.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection('classes');

class Classes {
  String get userUid => Get.context.read<UserController>().user.uid;

  Future<void> addClass({
    @required String name,
  }) async {
    DocumentReference documentReferencer =
        _mainCollection.doc(userUid).collection('class').doc();

    Map<String, dynamic> data = <String, dynamic>{
      "name": name,
      "teacher_id": userUid,
      "created_at": DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()),
    };

    await documentReferencer
        .set(data)
        .whenComplete(() => print("Class added to the database"))
        .catchError((e) => print(e));
  }

  Stream<QuerySnapshot> readClasses() {
    return _mainCollection
        .doc(userUid)
        .collection('class')
        .where("teacher_id", isEqualTo: userUid)
        .snapshots();
  }

  Future<void> deleteClass({
    @required String docId,
  }) async {
    DocumentReference documentReferencer =
        _mainCollection.doc(userUid).collection('class').doc(docId);

    await documentReferencer
        .delete()
        .whenComplete(() => print('Class deleted from the database'))
        .catchError((e) => print(e));
  }
}
