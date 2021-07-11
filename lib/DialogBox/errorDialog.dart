
import 'package:flutter/material.dart';

class ErrorAlertDialog extends StatelessWidget {
  final String message;

  const ErrorAlertDialog({ this.message}) ;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Text(
        message,
        style: TextStyle(color: Colors.black87),
      ),
      actions: <Widget>[
        // ignore: deprecated_member_use
        RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.blue[900],
          child: Center(
            child: Text("OK"),
          ),
        ),
      ],
    );
  }
}
