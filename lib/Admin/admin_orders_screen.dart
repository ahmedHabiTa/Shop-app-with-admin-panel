import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commerce/Admin/adminOrderCard.dart';
import 'package:commerce/Config/config.dart';
import 'package:commerce/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../Widgets/loadingWidget.dart';


class AdminOrdersScreen extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}


class _MyOrdersState extends State<AdminOrdersScreen> {
  @override
  Widget build(BuildContext context) {
    var themeMode = Provider.of<ThemeProvider>(context).tm ;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: themeMode == ThemeMode.dark
              ? Theme.of(context).canvasColor
              : Colors.white,
          iconTheme: IconThemeData(
            color:
            themeMode == ThemeMode.dark ? Colors.white : Colors.blue[900],
          ),
          title: Text(
            'Client\'s Orders',
            style: GoogleFonts.satisfy(
                textStyle: TextStyle(
                    color: themeMode == ThemeMode.dark
                        ? Colors.white
                        : Colors.blue[900],
                    fontSize: 37)),
          ),
          centerTitle: true,
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('orders').snapshots(),
          builder: (c,snapshot){
            return snapshot.hasData
                ? ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (c,index){
                return FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance.collection("items").where("shortInfo", whereIn: snapshot.data.docs[index]
                      .data()[EcommerceApp.productID]).get(),
                  builder: (c,snap){
                    return snap.hasData
                        ? AdminOrderCard(
                      itemCount: snap.data.docs.length,
                      data: snap.data.docs,
                      orderID: snapshot.data.docs[index].id,
                      orderBy: snapshot.data.docs[index].data()['orderBy'],
                      addressID: snapshot.data.docs[index].data()['addressID'],
                      numberOfOrder: index+1,
                    )
                        : Center(child: circularProgress(),);
                  },
                );
              },
            )
                : Center(child: circularProgress(),);
          },
        ),
      ),
    );
  }
}
