import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commerce/Admin/admin_home_screen.dart';
import 'package:commerce/Authentication/authenication.dart';
import 'package:commerce/Widgets/customTextField.dart';
import 'package:commerce/DialogBox/errorDialog.dart';
import 'package:commerce/Widgets/wideButton.dart';
import 'package:commerce/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AdminSignInScreen(),
    );
  }
}

class AdminSignInScreen extends StatefulWidget {
  @override
  _AdminSignInScreenState createState() => _AdminSignInScreenState();
}

class _AdminSignInScreenState extends State<AdminSignInScreen> {
  final TextEditingController _adminIDController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var themeMode = Provider.of<ThemeProvider>(context).tm;
    return SingleChildScrollView(
      child: Container(
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
                  CustomTextField(
                    controller: _passwordController,
                    data: Icons.lock,
                    hintText: 'Password',
                    isObsecure: true,
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
                    ? loginAdmin()
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
      ),
    );
  }

  loginAdmin() {
    FirebaseFirestore.instance.collection('admins').get().then((snapshot) {
      snapshot.docs.forEach((result) {
        if (result['id'] != _adminIDController.text.trim()) {
          // ignore: deprecated_member_use
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('Invalid ID'),
          ));
        } else if (result['password'] != _passwordController.text.trim()) {
          // ignore: deprecated_member_use
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('Invalid Password'),
          ));
        } else {
          // ignore: deprecated_member_use
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('Welcome dear Admin,' + result['name']),
          ));
          setState(() {
            _adminIDController.text = '';
            _passwordController.text = '';
          });
          Route route = MaterialPageRoute(builder: (c) => UploadPage());
          Navigator.pushReplacement(context, route);
        }
      });
    });
  }
}
