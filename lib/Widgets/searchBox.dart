import 'package:commerce/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Store/Search.dart';

class SearchBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var themeMode = Provider.of<ThemeProvider>(context).tm;
    return Card(
      margin: EdgeInsets.only(right: 10, left: 10),
      color: themeMode == ThemeMode.dark ? Colors.white : Colors.black87,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
       borderRadius: BorderRadius.circular(20),
        onTap: () {
          Route route = MaterialPageRoute(builder: (c) => SearchProduct());
          Navigator.pushReplacement(context, route);
        },
        child: Container(
          margin: EdgeInsets.all(1),
          width: MediaQuery.of(context).size.width,
          height: 50,
          decoration: BoxDecoration(
            color: themeMode == ThemeMode.dark
                ? Theme.of(context).canvasColor
                : Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 10,
              ),
              Padding(
                padding: EdgeInsets.only(left: 12),
                child: Text(
                  'Search...',
                  style: TextStyle(
                      color: themeMode == ThemeMode.dark
                          ? Colors.white
                          : Colors.blue[900],
                      fontSize: 17),
                ),
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.only(right: 12),
                child: Icon(
                  Icons.search,
                  color:
                  themeMode == ThemeMode.dark ? Colors.white : Colors.blue[900],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
