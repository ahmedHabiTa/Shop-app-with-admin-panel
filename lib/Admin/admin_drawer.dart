import 'package:commerce/Admin/admin_orders_screen.dart';
import 'package:commerce/Widgets/theme_settings.dart';
import 'package:commerce/main.dart';
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
          Divider(
            color: themeMode == ThemeMode.dark
                ? Colors.white
                : Colors.black87,
            thickness: 1,
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
                },
              ),
              customDivider(themeMode),
              customListTile(
                themeMode,
                Icons.settings,
                'Settings',
                () {
                  Route route =
                      MaterialPageRoute(builder: (c) => ThemesScreen());
                  Navigator.push(context, route);
                },
              ),
              customDivider(themeMode),
              customListTile(
                themeMode,
                Icons.logout,
                'Log Out',
                () {
                  Route route =
                      MaterialPageRoute(builder: (c) => SplashScreen());
                  Navigator.pushReplacement(context, route);
                },
              ),
              customDivider(themeMode),
            ],
          ),
        ],
      ),
    );
  }

  Widget customListTile(
      ThemeMode themeMode, IconData icon, String text, Function function) {
    return ListTile(
        leading: Icon(
          icon,
          color: themeMode == ThemeMode.dark ? Colors.white : Colors.blue[900],
        ),
        title: Text(
          text,
          style: GoogleFonts.robotoCondensed(
            textStyle: TextStyle(
                color: themeMode == ThemeMode.dark
                    ? Colors.white
                    : Colors.blue[900],
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
        ),
        onTap: function);
  }

  Widget customDivider(ThemeMode themeMode) {
    return Divider(
      height: 10,
      color: themeMode == ThemeMode.dark ? Colors.white60 : Colors.black38,
      thickness: 3,
      indent: 50,
      endIndent: 50,
    );
  }
}
