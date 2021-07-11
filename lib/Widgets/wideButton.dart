import 'package:commerce/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class WideButton extends StatelessWidget {
  final String message ;
  final Function onPressed ;

  WideButton({Key key,this.message, this.onPressed});

  @override
  Widget build(BuildContext context) {
    var themeMode = Provider.of<ThemeProvider>(context).tm;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: themeMode == ThemeMode.dark ? Colors.white : Colors.blue[900]
        ),
        // ignore: deprecated_member_use
        child: FlatButton(
          onPressed: onPressed,
          child: Text(message,style: TextStyle(color: themeMode == ThemeMode.dark ? Colors.black87 : Colors.white),),
        ),
      ),
    );
  }
}
