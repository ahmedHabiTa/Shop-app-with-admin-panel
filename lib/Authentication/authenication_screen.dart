import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class AuthenticScreen extends StatelessWidget {
  static const routeName = 'AuthenticScreen';

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
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Tab(
                  icon: Icon(
                    Icons.perm_contact_calendar,
                    color: Colors.white,
                  ),
                  child: Text(
                    'Register',
                    style: TextStyle(color: Colors.white),
                  ),
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
