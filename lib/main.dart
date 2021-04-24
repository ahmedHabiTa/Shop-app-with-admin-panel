import 'dart:async';
 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commerce/Counters/ItemQuantity.dart';
import 'package:commerce/Counters/cartitemcounter.dart';
import 'package:commerce/providers/order_provider.dart';
import 'package:commerce/providers/theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Authentication/authenication.dart';
import 'package:commerce/Config/config.dart';
import 'Counters/cartitemcounter.dart';
import 'Counters/changeAddresss.dart';
import 'Counters/totalMoney.dart';
import 'Store/storehome.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  EcommerceApp.auth =FirebaseAuth.instance ;
  EcommerceApp.sharedPreferences = await SharedPreferences.getInstance();
  EcommerceApp.firestore = FirebaseFirestore.instance;
  runApp(MultiProvider(
        providers: [
          ChangeNotifierProvider<CartItemCounter>(create: (c)=> CartItemCounter(),),
          ChangeNotifierProvider<ItemQuantity>(create: (c)=> ItemQuantity(),),
          ChangeNotifierProvider<AddressChanger>(create: (c)=> AddressChanger(),),
          ChangeNotifierProvider<TotalAmount>(create: (c)=> TotalAmount(),),
          ChangeNotifierProvider<ThemeProvider>(create: (c)=> ThemeProvider(),),
          ChangeNotifierProvider<OrderProvider>(create: (c)=> OrderProvider(),),
        ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var primaryColor =
        Provider.of<ThemeProvider>(context, listen: true).primaryColor;
    var accentColor =
        Provider.of<ThemeProvider>(context, listen: true).accentColor;
    var tm = Provider.of<ThemeProvider>(context, listen: true).tm;
    return MaterialApp(
          title: 'e-Shop',
          debugShowCheckedModeBanner: false,
        home: SplashScreen(),
        themeMode: tm,
        theme: ThemeData(
            cardColor: Colors.black87,
            buttonColor: Colors.black87,
            primarySwatch: primaryColor,
            accentColor: accentColor,
            //canvasColor: Color.fromRGBO(255, 254, 180, 1),
            textTheme: ThemeData.light().textTheme.copyWith(
              // bodyText1: TextStyle(color: Color.fromRGBO(20, 50, 50, 1)),
              headline6: GoogleFonts.openSans(
               textStyle:  TextStyle(
                   color: Colors.black87,
                   fontSize: 19,
                   //fontFamily: 'Satisfy',
                   fontWeight: FontWeight.bold),
              ),
              headline1: GoogleFonts.oswald(
                textStyle:  TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
              headline3: GoogleFonts.robotoCondensed(
                textStyle:  TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              headline4: GoogleFonts.robotoCondensed(
                textStyle:  TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            )),
        darkTheme: ThemeData(
            unselectedWidgetColor: Colors.white70,
            cardColor: Colors.white,
            buttonColor: Colors.white,
            primarySwatch: primaryColor,
            accentColor: accentColor,
            canvasColor: Color.fromRGBO(5, 22, 33, 1),
            textTheme: ThemeData.dark().textTheme.copyWith(
              bodyText1: TextStyle(color: Colors.white),
                headline6: GoogleFonts.openSans(
                  textStyle:  TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.bold),
                ),
              headline1: GoogleFonts.oswald(
                textStyle:  TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              headline3: GoogleFonts.robotoCondensed(
                textStyle:  TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              headline4: GoogleFonts.robotoCondensed(
                textStyle:  TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            )),

    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    displaySplash();
  }
  void displaySplash() {
      Timer(Duration(seconds: 4),()async{
        if(EcommerceApp.auth.currentUser != null){
        Route route = MaterialPageRoute(builder: (_) => StoreHome());
        Navigator.pushReplacement(context, route);
        }else{
          Route route = MaterialPageRoute(builder: (_) => AuthenticScreen());
          Navigator.pushReplacement(context, route);
        }
      });
  }
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration:  BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pink,Colors.lightGreenAccent],
            begin: const FractionalOffset(0,0),
            end: FractionalOffset(1,0),
            stops: [0,1],
            tileMode: TileMode.clamp,
          )
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/images/welcome.png'),
              SizedBox(height: 20,),
              Text('Welcome to the Online Shopping',style: TextStyle(color: Colors.white),),
            ],
          ),
        ),
      )
    );
  }


}
