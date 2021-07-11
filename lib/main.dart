import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commerce/Admin/admin_product_details/admin_product_details_provider.dart';
import 'package:commerce/Counters/cartitemcounter.dart';
import 'package:commerce/providers/order_provider.dart';
import 'package:commerce/providers/theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Admin/admin_home_page/admin_home_provider.dart';
import 'Admin/admin_login/admin_login_provider.dart';
import 'Authentication/Authentication_provider.dart';
import 'package:commerce/Config/config.dart';
import 'Counters/cartitemcounter.dart';
import 'Counters/changeAddresss.dart';
import 'Counters/totalMoney.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Widgets/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  EcommerceApp.auth = FirebaseAuth.instance;
  EcommerceApp.sharedPreferences = await SharedPreferences.getInstance();
  EcommerceApp.firestore = FirebaseFirestore.instance;

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<CartItemCounter>(
        create: (c) => CartItemCounter(),
      ),
      ChangeNotifierProvider<AdminProductDetailsProvider>(
        create: (c) => AdminProductDetailsProvider(),
      ),
      ChangeNotifierProvider<AdminLoginProvider>(
        create: (c) => AdminLoginProvider(),
      ),
      ChangeNotifierProvider<AdminHomeScreenProvider>(
        create: (c) => AdminHomeScreenProvider(),
      ),
      ChangeNotifierProvider<AuthenticationProvider>(
        create: (c) => AuthenticationProvider(),
      ),
      ChangeNotifierProvider<AddressChanger>(
        create: (c) => AddressChanger(),
      ),
      ChangeNotifierProvider<TotalAmount>(
        create: (c) => TotalAmount(),
      ),
      ChangeNotifierProvider<ThemeProvider>(
        create: (c) => ThemeProvider()..getThemeMode(),
      ),
      ChangeNotifierProvider<OrderProvider>(
        create: (c) => OrderProvider(),
      ),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var primaryColor = Provider.of<ThemeProvider>(context).primaryColor;
    var accentColor =
        Provider.of<ThemeProvider>(context).accentColor;
    var tm = Provider.of<ThemeProvider>(context).tm;
    return MaterialApp(
      title: 'e-Shop',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      themeMode: tm,
      theme: ThemeData(
          cardColor: Colors.black87,
          buttonColor: Colors.blue[900],
          primaryColor: primaryColor,
          accentColor: accentColor,
          //canvasColor: Color.fromRGBO(255, 254, 180, 1),
          textTheme: ThemeData.light().textTheme.copyWith(
                // bodyText1: TextStyle(color: Color.fromRGBO(20, 50, 50, 1)),
                headline6: GoogleFonts.openSans(
                  textStyle: TextStyle(
                      color: Colors.black87,
                      fontSize: 19,
                      //fontFamily: 'Satisfy',
                      fontWeight: FontWeight.bold),
                ),
                headline1: GoogleFonts.oswald(
                  textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                headline3: GoogleFonts.robotoCondensed(
                  textStyle: TextStyle(
                      color: Colors.black87,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                headline4: GoogleFonts.robotoCondensed(
                  textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              )),
      darkTheme: ThemeData(
          primaryColor: primaryColor,
          unselectedWidgetColor: Colors.white70,
          cardColor: Colors.white,
          buttonColor: Colors.white,
          accentColor: accentColor,
          canvasColor: Color.fromRGBO(5, 22, 33, 1),
          textTheme: ThemeData.dark().textTheme.copyWith(
                bodyText1: TextStyle(color: Colors.white),
                headline6: GoogleFonts.openSans(
                  textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.bold),
                ),
                headline1: GoogleFonts.oswald(
                  textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                headline3: GoogleFonts.robotoCondensed(
                  textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                headline4: GoogleFonts.robotoCondensed(
                  textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              )),
    );
  }
}

