
import 'package:commerce/providers/theme_provider.dart';
import 'package:flutter/material.dart';


import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'customAppBar.dart';

class ThemesScreen extends StatelessWidget {
  static const routeName = '/themes_screen';


  Widget buildRadioListTile(
      ThemeMode themeMode, String txt, IconData icon, BuildContext ctx) {
    return RadioListTile(
      secondary: Icon(
        icon,
        color: Theme.of(ctx).buttonColor,
      ),
      value: themeMode,
      groupValue: Provider.of<ThemeProvider>(ctx, listen: true).tm,
      onChanged: (newThemeValue) =>
          Provider.of<ThemeProvider>(ctx, listen: false)
              .themeModeChange(newThemeValue),
      title: Text(txt),
    );
  }

  @override
  Widget build(BuildContext context) {
    var themeMode = Provider.of<ThemeProvider>(context).tm ;
    return  Scaffold(
        appBar:  AppBar(
          elevation: 0,
          backgroundColor: themeMode == ThemeMode.dark
              ? Theme.of(context).canvasColor
              : Colors.white,
          iconTheme: IconThemeData(
            color:
            themeMode == ThemeMode.dark ? Colors.white : Colors.blue[900],
          ),
          title: Text(
            'Settings',
            style: GoogleFonts.satisfy(
                textStyle: TextStyle(
                    color: themeMode == ThemeMode.dark
                        ? Colors.white
                        : Colors.blue[900],
                    fontSize: 37)),
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
                      style: TextStyle(
                          color: themeMode == ThemeMode.dark
                              ? Colors.white
                              : Colors.blue[900],
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
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
