import 'package:commerce/Widgets/myDrawer.dart';
import 'package:commerce/providers/theme_provider.dart';
import 'package:flutter/material.dart';


import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ThemesScreen extends StatelessWidget {
  static const routeName = '/themes_screen';


  Widget buildRadioListTile(
      ThemeMode themeVal, String txt, IconData icon, BuildContext ctx) {
    return RadioListTile(
      secondary: Icon(
        icon,
        color: Theme.of(ctx).buttonColor,
      ),
      value: themeVal,
      groupValue: Provider.of<ThemeProvider>(ctx, listen: true).tm,
      onChanged: (newThemeValue) =>
          Provider.of<ThemeProvider>(ctx, listen: false)
              .themeModeChange(newThemeValue),
      title: Text(txt),
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        drawer:  MyDrawer(),
        appBar:  AppBar(
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
            'Settings',
            style: GoogleFonts.satisfy(
                textStyle: TextStyle(color: Colors.white, fontSize: 40)
            ),
          ),
          centerTitle: true,

        ),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'Choose your Theme MODE',textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  buildRadioListTile(ThemeMode.system,
                      'System Default Theme', null, context),
                  buildRadioListTile(
                      ThemeMode.light,
                      'Light MODE',
                      Icons.wb_sunny_outlined,
                      context),
                  buildRadioListTile(ThemeMode.dark, 'Dark MODE',
                      Icons.nights_stay_outlined, context),
                ],
              ),
            ),
          ],
        ),

    );
  }


}
