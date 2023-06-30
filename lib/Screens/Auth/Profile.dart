import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_app/Controllers/UserController.dart';
import 'package:student_app/Helpers/Const.dart';
import 'package:student_app/Widgets/ButtomWithRadius.dart';
import 'package:student_app/Screens/Auth/Login.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool _isSigningOut = false;

  Future<void> _signOut() async {
    setState(() => _isSigningOut = true);
    await FirebaseAuth.instance.signOut();
    Provider.of<UserController>(context, listen: false).user = null;
    setState(() => _isSigningOut = false);

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => Login(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
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
      body: Consumer<UserController>(
        builder: (context, viewModel, child) {
          return ListView(
            padding: const EdgeInsets.all(8.0),
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      NetworkImage('https://special-party.com/default.png'),
                ),
              ),
              ContainerLabel(
                label: 'Name',
                text: viewModel?.user?.displayName,
              ),
              ContainerLabel(
                label: 'Email',
                text: viewModel?.user?.email,
              ),
              _isSigningOut
                  ? CircularProgressIndicator()
                  : ButtomWithRadius(
                      functionOnTab: _signOut,
                      text: 'Sign out',
                    ),
            ],
          );
        },
      ),
    );
  }
}

class ContainerLabel extends StatelessWidget {
  const ContainerLabel({
    Key key,
    @required this.label,
    @required this.text,
  }) : super(key: key);

  final String label, text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(text),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
