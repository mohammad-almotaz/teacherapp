import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student_app/Screens/DataBases/AbsenceStudents.dart';

import 'package:student_app/Helpers/Const.dart';
import 'package:student_app/Helpers/Dialogs.dart';
import 'package:student_app/Screens/ShowAbsenceStudents.dart';
import 'package:student_app/Screens/TakeAbsenceStudents.dart';
import 'package:intl/intl.dart';

import 'DataBases/Students.dart';

class ShowClass extends StatefulWidget {
  const ShowClass({
    Key key,
    @required this.className,
    @required this.classId,
  }) : super(key: key);

  final String className;
  final String classId;

  @override
  _ShowClassState createState() => _ShowClassState();
}

class _ShowClassState extends State<ShowClass> {
  TextEditingController _nameController;
  List _docsStudents;
  bool _showFloatingActionButton;
  GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _formKey = GlobalKey<FormState>();

    _showFloatingActionButton = true;
    checkIfExistsAbsenceToday();
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
  }

  Future<void> deleteStudent(String docID) async {
    await Students().deleteStudent(docId: docID);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Delete Student'),
      ),
    );

    print('fun deleteStudent() ShowClass screen');
  }

  Future<void> _onPressedCalendar(BuildContext context) async {
    DateTime pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: Locale('en', 'US'),
    );

    if (pickedDate == null) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ShowAbsenceStudents(
          className: widget.className,
          classId: widget.classId,
          date: DateFormat('yyyy-MM-dd').format(pickedDate),
        ),
      ),
    );
  }

  Future<void> checkIfExistsAbsenceToday() async {
    bool data = await AbsenceStudents().checkIfExists(classId: widget.classId);
    setState(() => _showFloatingActionButton = data);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

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
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            tooltip: 'person_add',
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => DialogAddStudent(
                  controller: _nameController,
                  formKey: _formKey,
                  functionOnTab: () async {
                    if (!_formKey.currentState.validate()) return;

                    await Students().addStudent(
                      classId: widget.classId,
                      name: _nameController.text,
                    );
                    _nameController.clear();
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today),
            tooltip: 'calendar',
            onPressed: () async => await _onPressedCalendar(context),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Students().readStudents(classId: widget.classId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          } else if (snapshot.hasData || snapshot.data != null) {
            if (snapshot.data.docs.length == 0) {
              return Center(
                child: Text(
                    'Dosent has Students in this class ${widget.className}'),
              );
            }
            _docsStudents = snapshot.data.docs;
            return ListView.separated(
              separatorBuilder: (context, index) => SizedBox(height: 16.0),
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                return ContainerStudent(
                  data: snapshot.data.docs[index],
                  onDismissed: deleteStudent,
                );
              },
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _showFloatingActionButton
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => TakeAbsenceStudents(
                      classId: widget.classId,
                      className: widget.className,
                      docsStudents: _docsStudents,
                    ),
                  ),
                );
              },
              label: Container(
                width: size.width - 100,
                alignment: Alignment.center,
                child: Text('Take absence'),
              ),
            )
          : null,
    );
  }
}

class ContainerStudent extends StatelessWidget {
  const ContainerStudent({
    Key key,
    @required this.data,
    @required this.onDismissed,
  }) : super(key: key);
  final data;
  final Function onDismissed;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    Map noteInfo = data.data();
    String docID = data.id;
    String studentName = noteInfo['name'];
    String createdAt = noteInfo['created_at'].toString();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Dismissible(
        key: Key('item-' + docID),
        direction: DismissDirection.endToStart,
        background: Container(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(Icons.delete, color: CColors.whiteTheme),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Delete student',
                  style: TextStyle(color: CColors.whiteTheme),
                ),
              ),
            ],
          ),
        ),
        onDismissed: (direction) async => await onDismissed(docID),
        child: Container(
          width: size.width,
          height: size.height * 0.15,
          decoration: BoxDecoration(
            color: CColors.whiteTheme,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Text(
                          studentName,
                          style: TextStyle(
                            fontSize: size.height * 0.022,
                            fontWeight: FontWeight.w700,
                            height: 1,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        child: Text(
                          createdAt,
                          style: TextStyle(
                            fontSize: size.height * 0.018,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
