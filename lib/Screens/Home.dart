import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student_app/Screens/DataBases/Classes.dart';
import 'package:student_app/Helpers/Const.dart';
import 'package:student_app/Helpers/Dialogs.dart';
import 'package:student_app/Screens/Auth/Profile.dart';
import 'package:student_app/screens/ShowClass.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _nameController;
  GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
  }

  Future<void> deleteClass(String docID) async {
    await Classes().deleteClass(docId: docID);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Delete class'),
      ),
    );

    print('fun deleteClass() Home screen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
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
            icon: const Icon(Icons.person),
            tooltip: 'Person',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Profile(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.plus_one),
            tooltip: 'plus_one',
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => DialogAddClass(
                  controller: _nameController,
                  formKey: _formKey,
                  functionOnTab: () async {
                    if (!_formKey.currentState.validate()) return;
                    await Classes().addClass(name: _nameController.text);
                    _nameController.clear();
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Classes().readClasses(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          } else if (snapshot.hasData || snapshot.data != null) {
            if (snapshot.data.docs.length == 0) {
              return Center(child: Text('Dosent has classes'));
            }
            return ListView.separated(
              separatorBuilder: (context, index) => SizedBox(height: 16.0),
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                return ContainerClass(
                  data: snapshot.data.docs[index],
                  onDismissed: deleteClass,
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

class ContainerClass extends StatelessWidget {
  const ContainerClass({
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
    String className = noteInfo['name'];
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
                  'Delete class',
                  style: TextStyle(color: CColors.whiteTheme),
                ),
              ),
            ],
          ),
        ),
        onDismissed: (direction) async => await onDismissed(docID),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ShowClass(
                  className: className,
                  classId: docID,
                ),
              ),
            );
          },
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
                            className,
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
      ),
    );
  }
}
