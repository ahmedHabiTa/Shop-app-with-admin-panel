import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commerce/Store/storehome.dart';
import 'package:commerce/Widgets/myDrawer.dart';
import 'package:flutter/material.dart';
import 'package:commerce/Config/config.dart';
import 'package:google_fonts/google_fonts.dart';




import '../Widgets/loadingWidget.dart';
import '../Widgets/orderCard.dart';

class MyOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: MyDrawer(),
        appBar: AppBar(
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
            'Orders',
            style: GoogleFonts.satisfy(
                textStyle: TextStyle(color: Colors.white, fontSize: 40)
            ),
          ),
          centerTitle: true,

        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: EcommerceApp.firestore.collection(EcommerceApp.collectionUser)
          .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
          .collection(EcommerceApp.collectionOrders).snapshots(),
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
                        ? OrderCard(
                      itemCount: snap.data.docs.length,
                      data: snap.data.docs,
                      orderID: snapshot.data.docs[index].id,
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
