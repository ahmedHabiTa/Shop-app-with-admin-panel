import 'package:commerce/Admin/admin_orders_screen.dart';
import 'package:commerce/Config/config.dart';
import 'package:commerce/Widgets/splash_screen.dart';
import 'package:commerce/Widgets/theme_screen.dart';
import 'package:commerce/constants.dart';
import 'package:commerce/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
class AdminDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var themeMode = Provider.of<ThemeProvider>(context).tm;
    return Drawer(
      child: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: CircleAvatar(
              radius: 110,
              backgroundImage: AssetImage("assets/images/ecommerce.png"),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'Welcome to Admin panel',
            style: GoogleFonts.actor(
              textStyle: TextStyle(
                  color: themeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.blue[900],
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
            textAlign: TextAlign.center,
          ),
          Column(
            children: [
              customListTile(
                themeMode,
                Icons.border_color,
                'Client\'s Orders',
                () {
                  Route route =
                      MaterialPageRoute(builder: (c) => AdminOrdersScreen());
                  Navigator.push(context, route);
                },context
              ),
              customListTile(
                themeMode,
                Icons.settings,
                'Settings',
                () {
                  Route route =
                      MaterialPageRoute(builder: (c) => ThemesScreen());
                  Navigator.push(context, route);
                },context
              ),
              customListTile(
                themeMode,
                Icons.logout,
                'Log Out',
                () {
                  Route route =
                      MaterialPageRoute(builder: (c) => SplashScreen());
                  Navigator.pushReplacement(context, route);
                  adminToken = false ;
                  EcommerceApp.sharedPreferences.setBool('adminToken', adminToken);
                },context
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget customListTile(ThemeMode themeMode,IconData icon,String text,Function function,context){
    var themeMode = Provider.of<ThemeProvider>(context).tm;
    return Card(
      semanticContainer: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: themeMode == ThemeMode.dark ? Colors.white : Colors.black87,
      child:  Padding(
        padding: EdgeInsets.all(1),
        child: Container(
          decoration: BoxDecoration(
            color: themeMode == ThemeMode.dark
                ? Theme.of(context).canvasColor
                : Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: ListTile(
              leading: Icon(
                icon,
                color: themeMode == ThemeMode.dark
                    ? Colors.white
                    : Colors.blue[900],
              ),
              title: Text(text,
                style: GoogleFonts.robotoCondensed(
                  textStyle: TextStyle(
                      color: themeMode == ThemeMode.dark
                          ? Colors.white
                          : Colors.blue[900],
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),),
              onTap: function
          ),
        ),
      ),
    );
  }
}
