import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commerce/Admin/adminOrderCard.dart';
import 'package:commerce/Config/config.dart';
import 'package:flutter/material.dart';
import '../Widgets/loadingWidget.dart';


class AdminShiftOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}


class _MyOrdersState extends State<AdminShiftOrders> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
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
          title: Text('Users\' Orders',style: TextStyle(color: Colors.white),),
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
