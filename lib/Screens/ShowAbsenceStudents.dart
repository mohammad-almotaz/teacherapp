import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student_app/Screens/DataBases/AbsenceStudents.dart';
import 'package:student_app/Helpers/Const.dart';

class ShowAbsenceStudents extends StatefulWidget {
  const ShowAbsenceStudents({
    Key key,
    @required this.date,
    @required this.className,
    @required this.classId,
  }) : super(key: key);

  final String date;
  final String className;
  final String classId;

  @override
  _ShowAbsenceStudentsState createState() => _ShowAbsenceStudentsState();
}

class _ShowAbsenceStudentsState extends State<ShowAbsenceStudents> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.className),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            ),
            gradient: LinearGradient(
              colors: <Color>[
                CColors.primaryTheme,
                CColors.secondaryTheme,
              ],
            ),
          ),
        ),
        elevation: 0,
        backgroundColor: CColors.primaryTheme,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: AbsenceStudents()
            .readAbsences(classId: widget.classId, date: widget.date),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          } else if (snapshot.hasData || snapshot.data != null) {
            if (snapshot.data.docs.length == 0) {
              return Center(
                child: Text('Dosent has Absences in this day ${widget.date}'),
              );
            }
            return ListView.separated(
              separatorBuilder: (context, index) => SizedBox(height: 16.0),
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                var data = snapshot.data.docs[index];
                return ContainerStudent(
                  data: data,
                );
              },
            );
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class ContainerStudent extends StatelessWidget {
  const ContainerStudent({
    Key key,
    @required this.data,
  }) : super(key: key);
  final data;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    Map noteInfo = data.data();
    String studentName = noteInfo['student_name'];
    bool status = noteInfo['status'];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: size.width,
        height: size.height * 0.15,
        decoration: BoxDecoration(
          color: status
              ? Colors.redAccent.withOpacity(0.2)
              : Colors.greenAccent.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius:
                  BorderRadius.horizontal(left: Radius.circular(10.0)),
              child: Container(
                width: 6,
                color: CColors.primaryTheme,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  studentName,
                  style: TextStyle(
                    fontSize: size.height * 0.022,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
