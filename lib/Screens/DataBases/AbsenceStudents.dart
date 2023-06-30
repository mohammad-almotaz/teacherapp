import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:student_app/Controllers/UserController.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection('absences');

class AbsenceStudents {
  String get userUid => Get.context.read<UserController>().user.uid;

  Future<void> addAbsence({
    @required String classId,
    @required Map mapStudents,
  }) async {
    mapStudents.forEach((key, data) async {
      Map<String, dynamic> secondData = <String, dynamic>{
        "class_id": classId,
        "student_id": key,
        "student_name": data['student_name'],
        "status": data['status'],
        "date": DateFormat('yyyy-MM-dd').format(DateTime.now()),
      };

      await _mainCollection
          .doc(userUid)
          .collection('absence')
          .doc()
          .set(secondData)
          .whenComplete(() => print("Absences added to the database"))
          .catchError((e) => print(e));
    });
  }

  Stream<QuerySnapshot> readAbsences({
    @required String classId,
    @required String date,
  }) {
    return _mainCollection
        .doc(userUid)
        .collection('absence')
        .where("class_id", isEqualTo: classId)
        .where("date", isEqualTo: date)
        .snapshots();
  }

  Future<bool> checkIfExists({
    @required String classId,
  }) async {
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();

    final QuerySnapshot result = await _mainCollection
        .doc(userUid)
        .collection('absence')
        .where("class_id", isEqualTo: classId)
        .where("date", isEqualTo: today)
        .limit(1)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    return documents.length != 1;
  }
}
