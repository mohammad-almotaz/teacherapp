import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_app/Controllers/UserController.dart';
import 'package:student_app/Helpers/Const.dart';
import 'package:student_app/Helpers/Validation.dart';
import 'package:student_app/Screens/Auth/Register.dart';
import 'package:student_app/Screens/Home.dart';
import 'package:student_app/Widgets/BezierContainer.dart';
import 'package:student_app/Widgets/ButtomWithRadius.dart';
import 'package:student_app/Widgets/InputField.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isProcessing;
  GlobalKey<FormState> _formKey;

  TextEditingController _emailController;
  TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();

    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    _isProcessing = false;
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState.validate()) return;
    setState(() => _isProcessing = true);

    var pro = Provider.of<UserController>(context, listen: false);

    User user = await pro.signInUsingEmailPassword(
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

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: -size.height * .15,
              right: -size.width * .4,
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
                      SizedBox(height: size.height * .2),
                      Image.asset('assets/images/Logo.png'),
                      SizedBox(height: 50),
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
                      SizedBox(height: 20),
                      _isProcessing
                          ? CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                CColors.primaryTheme,
                              ),
                            )
                          : ButtomWithRadius(
                              text: 'Login',
                              functionOnTab: _login,
                            ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Divider(thickness: 1),
                              ),
                            ),
                            Text('or'),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Divider(
                                  thickness: 1,
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Register(),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 20),
                          padding: EdgeInsets.all(15),
                          alignment: Alignment.bottomCenter,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Don\'t have an account ?',
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Register',
                                style: TextStyle(
                                  color: Color(0xfff79c4f),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
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
          ],
        ),
      ),
    );
  }
}
