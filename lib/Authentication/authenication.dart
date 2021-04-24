import 'package:flutter/material.dart';
import 'login.dart';
import 'register.dart';
// import 'package:commerce/Config/config.dart';

class AuthenticScreen extends StatefulWidget {
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
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                colors: [Colors.pink, Colors.lightGreenAccent],
                begin: const FractionalOffset(0, 0),
                end: FractionalOffset(1, 0),
                stops: [0, 1],
                tileMode: TileMode.clamp,
              )),
            ),
            title: Text(
              'E-Shopping',
              style: TextStyle(color: Colors.white, fontSize: 40),
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
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.pink, Colors.lightGreenAccent],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
            child: TabBarView(
              children: <Widget>[
                Login(),
                Register(),
              ],
            ),
          ),
        ));
  }
}
