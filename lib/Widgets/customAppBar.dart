import 'package:commerce/Config/config.dart';
import 'package:commerce/Store/cart.dart';
import 'package:commerce/Counters/cartitemcounter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

Widget customAppBar(ThemeMode themeMode,context,String text, {PreferredSize bottom,double elevation = 0.0}){
  return AppBar(
    bottom: bottom,
    elevation: elevation,
    backgroundColor: themeMode == ThemeMode.dark
        ? Theme.of(context).canvasColor
        : Colors.white,
    iconTheme: IconThemeData(
      color:
      themeMode == ThemeMode.dark ? Colors.white : Colors.blue[900],
    ),
    title: Text(
      text,
      style: GoogleFonts.satisfy(
          textStyle: TextStyle(
              color: themeMode == ThemeMode.dark
                  ? Colors.white
                  : Colors.blue[900],
              fontSize: 37)),
    ),
    centerTitle: true,
    actions: <Widget>[
      Stack(
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.shopping_cart,
              color: themeMode == ThemeMode.dark
                  ? Colors.white
                  : Colors.blue[900],
            ),
            onPressed: () {
              Route route = MaterialPageRoute(builder: (c) => CartPage());
              Navigator.push(context, route);
            },
          ),
          Positioned(
            child: Stack(
              children: <Widget>[
                Icon(
                  Icons.brightness_1,
                  size: 20,
                  color: Colors.orange[700],
                ),
                Positioned(
                  top: 3,
                  bottom: 4,
                  left: 5,
                  right: 4,
                  child: Consumer<CartItemCounter>(
                    builder: (context, counter, _) {
                      return Text(
                        (EcommerceApp.sharedPreferences
                            .getStringList(EcommerceApp.userCartList)
                            .length == null ? 0.toString(): EcommerceApp.sharedPreferences
                            .getStringList(EcommerceApp.userCartList)
                            .length-1)
                            .toString() ,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ],
  );

}
