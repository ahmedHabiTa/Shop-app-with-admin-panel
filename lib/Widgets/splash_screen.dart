import 'dart:async';
import 'package:commerce/Admin/admin_home_page/admin_home_screen.dart';
import 'package:commerce/Authentication/authenication_screen.dart';
import 'package:commerce/Config/config.dart';
import 'package:commerce/Store/storehome.dart';
import 'package:flutter/material.dart';
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    displaySplash();
    super.initState();
  }
  void displaySplash() {
    Timer(Duration(seconds: 3), () async {
      bool adminToken = EcommerceApp.sharedPreferences.getBool('adminToken');
      if (EcommerceApp.auth.currentUser != null && adminToken == false) {
        Route route = MaterialPageRoute(builder: (_) => StoreHome());
        Navigator.pushReplacement(context, route);
      } else if(EcommerceApp.auth.currentUser == null && adminToken == false){
        Route route = MaterialPageRoute(builder: (_) => AuthenticScreen());
        Navigator.pushReplacement(context, route);
      }else if(EcommerceApp.auth.currentUser == null && adminToken == true){
        Route route = MaterialPageRoute(builder: (_) => UploadPage());
        Navigator.pushReplacement(context, route);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Material(
        child: Container(
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/images/welcome.png'),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Welcome to the Online Shopping',
                  style: TextStyle(color: Colors.blue[900]),
                ),
              ],
            ),
          ),
        ));
  }
}