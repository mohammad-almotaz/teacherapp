import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_app/Controllers/UserController.dart';
import 'package:student_app/Helpers/Const.dart';
import 'package:student_app/Helpers/Validation.dart';
import 'package:student_app/Screens/Home.dart';
import 'package:student_app/Screens/Auth/Login.dart';
import 'package:student_app/Widgets/ButtomWithRadius.dart';
import 'package:student_app/Widgets/InputField.dart';
import 'package:student_app/Widgets/bezierContainer.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _isProcessing;
  GlobalKey<FormState> _formKey;

  TextEditingController _emailController;
  TextEditingController _nameController;
  TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();

    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _nameController = TextEditingController();

    _isProcessing = false;
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState.validate()) return;
    setState(() => _isProcessing = true);

    var pro = Provider.of<UserController>(context, listen: false);

    User user = await pro.registerUsingEmailPassword(
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );

    setState(() => _isProcessing = false);

    if (user != null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => Home(),
        ),
        (route) => false,
      );
    }
  }

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text(
              'Back',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _loginAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Login()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Already have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Login',
              style: TextStyle(
                  color: Color(0xfff79c4f),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: height,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: -MediaQuery.of(context).size.height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: BezierContainer(),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: height * .2),
                      Image.asset('assets/images/Logo.png'),
                      SizedBox(
                        height: 50,
                      ),
                      InputField(
                        labelText: 'Name',
                        keyboardType: TextInputType.name,
                        controller: _nameController,
                        validator: (value) => Validation.validationRequired(
                          value,
                          'Please enter your name',
                        ),
                        prefix: Icon(
                          Icons.person,
                          color: CColors.primaryTheme,
                          size: 18.0,
                        ),
                      ),
                      InputField(
                        labelText: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                        validator: (value) => Validation.validationRequired(
                          value,
                          'Please enter your email',
                        ),
                        prefix: Icon(
                          Icons.email,
                          color: CColors.primaryTheme,
                          size: 18.0,
                        ),
                      ),
                      InputField(
                        labelText: 'Password',
                        keyboardType: TextInputType.visiblePassword,
                        controller: _passwordController,
                        obscureText: true,
                        validator: (value) => Validation.validationRequired(
                          value,
                          'Please enter your password',
                        ),
                        prefix: Icon(
                          Icons.lock,
                          color: CColors.primaryTheme,
                          size: 18.0,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      _isProcessing
                          ? CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                CColors.primaryTheme,
                              ),
                            )
                          : ButtomWithRadius(
                              text: 'Register Now',
                              functionOnTab: _register,
                            ),
                      _loginAccountLabel(),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(top: 40, left: 0, child: _backButton()),
          ],
        ),
      ),
    );
  }
}
