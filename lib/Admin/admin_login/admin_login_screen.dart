import 'package:commerce/Authentication/authenication_screen.dart';
import 'package:commerce/Widgets/customTextField.dart';
import 'package:commerce/DialogBox/errorDialog.dart';
import 'package:commerce/Widgets/wideButton.dart';
import 'package:commerce/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'admin_login_provider.dart';
class AdminSignInScreen extends StatefulWidget {
  @override
  _AdminSignInScreenState createState() => _AdminSignInScreenState();
}
class _AdminSignInScreenState extends State<AdminSignInScreen> {
  final TextEditingController _adminIDController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    var themeMode = Provider.of<ThemeProvider>(context).tm;
    var key = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: key,
      body: SingleChildScrollView(
        child: Consumer<AdminLoginProvider>(
          builder: (context,provider,_){
            return  Container(
              color: themeMode == ThemeMode.dark ? Theme.of(context).canvasColor : Colors.white,
              height: MediaQuery.of(context).size.height,
              child: Column(
                //mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: Image.asset(
                      'assets/images/admin.png',
                      fit: BoxFit.cover,
                    ),
                    height: 280,
                    width: double.infinity,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text('Login to manage your business',
                        style: TextStyle(
                          color: themeMode == ThemeMode.dark ? Colors.white : Colors.black87,
                          fontSize: 20,
                        )),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        CustomTextField(
                          controller: _adminIDController,
                          data: Icons.person,
                          hintText: 'Admin ID ',
                          isObsecure: false,
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
                                  color: themeMode == ThemeMode.dark ? Colors.white :Colors.blue[900],
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
                  SizedBox(
                    height: 10,
                  ),
                  WideButton(
                    message: 'Login',
                    onPressed: () {
                      _adminIDController.text.isNotEmpty &&
                          _passwordController.text.isNotEmpty
                          ? Provider.of<AdminLoginProvider>(context,listen: false).loginAdmin(_adminIDController.text.trim(), _passwordController.text.trim(),context)
                          : showDialog(
                          context: context,
                          builder: (c) {
                            return ErrorAlertDialog(
                              message: 'Enter your ID and Password',
                            );
                          });
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  // ignore: deprecated_member_use
                  FlatButton.icon(
                      onPressed: () => Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => AuthenticScreen())),
                      icon: Icon(
                        Icons.nature_people,
                        color: themeMode == ThemeMode.dark ? Colors.white : Colors.blue[900],
                      ),
                      label: Text(
                        'Return to the login Page',
                        style: TextStyle(
                            color: themeMode == ThemeMode.dark ? Colors.white : Colors.blue[900], fontWeight: FontWeight.bold),
                      )),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
