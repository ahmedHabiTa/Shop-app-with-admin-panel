import 'package:commerce/Admin/admin_login/admin_login_screen.dart';
import 'package:commerce/Authentication/Authentication_provider.dart';
import 'package:commerce/Widgets/customTextField.dart';
import 'package:commerce/DialogBox/errorDialog.dart';

import 'package:commerce/Widgets/wideButton.dart';
import 'package:commerce/providers/theme_provider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}
class _LoginState extends State<Login> {
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    var themeMode = Provider.of<ThemeProvider>(context).tm;
    //double _screenWidth = MediaQuery.of(context).size.width;
    return Consumer<AuthenticationProvider>(
      builder: (context,provider,_){
        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                //Image Asset...
                Container(
                  alignment: Alignment.bottomCenter,
                  child: Image.asset('assets/images/login.png'),
                  height: 220,
                  width: double.infinity,
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    'Login to your account',
                    style: TextStyle(
                        color: themeMode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black87),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      CustomTextField(
                        controller: _emailController,
                        data: Icons.email,
                        hintText: 'E-mail',
                        isObsecure: false,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          CustomTextField(
                            controller: _passwordController,
                            data: Icons.lock,
                            hintText: 'Password',
                            isObsecure: obscureText,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: IconButton(
                              icon: Icon(
                                Icons.remove_red_eye,
                                color: themeMode == ThemeMode.dark ? Colors.white : Colors.blue[900],
                              ),
                              onPressed: () {
                                setState(() {
                                  obscureText = !obscureText;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                WideButton(
                  message: 'Login',
                  onPressed: () {
                    _emailController.text.isNotEmpty &&
                        _passwordController.text.isNotEmpty
                        ? provider.loginUser(context, _emailController.text.trim(), _passwordController.text.trim())
                        : showDialog(
                      context: context,
                      builder: (c) {
                        return ErrorAlertDialog(
                          message: 'Please Enter your Email and Password',
                        );
                      },
                    );
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                // ignore: deprecated_member_use
                FlatButton.icon(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => AdminSignInScreen()),
                    ),
                    icon: Icon(
                      Icons.nature_people,
                      color: themeMode == ThemeMode.dark
                          ? Colors.white
                          : Colors.blue[900],
                    ),
                    label: Text(
                      'Admin ? Login here !',
                      style: TextStyle(
                          color: themeMode == ThemeMode.dark
                              ? Colors.white
                              : Colors.blue[900],
                          fontWeight: FontWeight.bold),
                    ))
              ],
            ),
          ),
        );
      },
    );
  }



}
