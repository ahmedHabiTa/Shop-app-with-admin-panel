import 'package:commerce/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final IconData data;
  final String hintText;
  bool isObsecure = true;

final String labelText ;
  CustomTextField(
      {Key key, this.controller, this.data, this.hintText, this.isObsecure,this.labelText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeMode = Provider.of<ThemeProvider>(context).tm;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      color: themeMode == ThemeMode.dark ? Colors.white : Colors.blue[900],
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          decoration: BoxDecoration(
            color: themeMode == ThemeMode.dark ? Theme.of(context).canvasColor : Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          padding: EdgeInsets.all(8),
          child: TextFormField(
            controller: controller,
            obscureText: isObsecure,
            cursorColor: Colors.black87,
            decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: Icon(
                  data,
                  color: themeMode == ThemeMode.dark ? Colors.white : Colors.blue[900],
                ),
                focusColor: themeMode == ThemeMode.dark ? Colors.white : Colors.blue[900],
                hintText: hintText,
                labelText: labelText,
                labelStyle: TextStyle(color: themeMode == ThemeMode.dark ? Colors.white : Colors.blue[900]),
                hintStyle: TextStyle(color: themeMode == ThemeMode.dark ? Colors.white : Colors.blue[900])),
          ),
        ),
      ),
    );
  }
}
