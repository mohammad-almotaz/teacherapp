import 'package:flutter/material.dart';
import 'package:student_app/Screens/DataBases/AbsenceStudents.dart';
import 'package:student_app/Helpers/Const.dart';
import 'package:student_app/Helpers/Helper.dart';
import 'package:student_app/Widgets/CheckBox.dart';

class TakeAbsenceStudents extends StatefulWidget {
  const TakeAbsenceStudents({
    Key key,
    @required this.className,
    @required this.classId,
    @required this.docsStudents,
  }) : super(key: key);

  final String className;
  final String classId;
  final List docsStudents;

  @override
  _TakeAbsenceStudentsState createState() => _TakeAbsenceStudentsState();
}

class _TakeAbsenceStudentsState extends State<TakeAbsenceStudents> {
  Map _dataStudentsAbsences;
  bool _isLoading;

  @override
  void initState() {
    super.initState();
    _isLoading = false;
    _dataStudentsAbsences = {};

    widget.docsStudents?.forEach((data) async {
      Map noteInfo = data.data();

      _dataStudentsAbsences[data.id] = {
        'student_name': noteInfo['name'],
        'status': false,
      };
    });
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
      ),
      body: Container(
        child: widget.docsStudents != null
            ? ListView.separated(
                separatorBuilder: (context, index) => SizedBox(height: 16.0),
                itemCount: widget.docsStudents.length,
                itemBuilder: (context, index) {
                  var data = widget.docsStudents[index];
                  return ContainerStudent(
                    data: data,
                    isSelected: _dataStudentsAbsences[data.id]['status'],
                    onTap: () {
                      setState(() => _dataStudentsAbsences[data.id]['status'] =
                          !_dataStudentsAbsences[data.id]['status']);
                    },
                  );
                },
              )
            : Center(
                child: Text(
                    'Dosent has Students in this class ${widget.className}'),
              ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: widget.docsStudents != null
          ? FloatingActionButton.extended(
              onPressed: () async {
                setState(() => _isLoading = true);
                await AbsenceStudents().addAbsence(
                  classId: widget.classId,
                  mapStudents: _dataStudentsAbsences,
                );
                setState(() => _isLoading = false);
                await Helper.showDialogAwesome(
                  context: context,
                  btnOkText: 'Okay',
                  title: 'Done enter the data',
                  onChanged: () => Navigator.of(context).pop(),
                );
              },
              label: _isLoading
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        CColors.whiteTheme,
                      ),
                    )
                  : Container(
                      width: size.width - 100,
                      alignment: Alignment.center,
                      child: Text('Take absence now'),
                    ),
            )
          : SizedBox(),
    );
  }
}

class ContainerStudent extends StatelessWidget {
  const ContainerStudent({
    Key key,
    @required this.data,
    @required this.isSelected,
    @required this.onTap,
  }) : super(key: key);
  final data;
  final bool isSelected;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    Map noteInfo = data.data();
    String studentName = noteInfo['name'];
    String createdAt = noteInfo['created_at'].toString();

    return Padding(
      padding: const EdgeInsets.all(8.0),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
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
                    CheckBox(
                      onTap: onTap,
                      value: isSelected,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
