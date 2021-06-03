import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login.dart';
import 'register.dart';
// import 'package:commerce/Config/config.dart';

class AuthenticScreen extends StatefulWidget {
  static const routeName = 'AuthenticScreen';

  @override
  _AuthenticScreenState createState() => _AuthenticScreenState();
}

class _AuthenticScreenState extends State<AuthenticScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            flexibleSpace: Container(
              color: Colors.blue[900],
            ),
            title: Text(
              'E-Shopping',
              style: GoogleFonts.satisfy(
                  textStyle: TextStyle(color: Colors.white, fontSize: 40)),
            ),
            centerTitle: true,
            bottom: TabBar(
              tabs: <Widget>[
                Tab(
                  icon: Icon(
                    Icons.lock,
                    color: Colors.white,
                  ),
                  text: 'Login',
                ),
                Tab(
                  icon: Icon(
                    Icons.perm_contact_calendar,
                    color: Colors.white,
                  ),
                  text: 'Register',
                ),
              ],
              indicatorColor: Colors.white,
              indicatorWeight: 5,
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              Login(),
              Register(),
            ],
          ),
        ));
  }
}
