import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commerce/Widgets/customAppBar.dart';
import 'package:commerce/Widgets/main_drawer.dart';
import 'package:commerce/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:commerce/Config/config.dart';
import 'package:provider/provider.dart';
import '../Widgets/loadingWidget.dart';
import '../Widgets/orderCard.dart';
class MyOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}
class _MyOrdersState extends State<MyOrders> {
  @override
  Widget build(BuildContext context) {
    var themeMode = Provider.of<ThemeProvider>(context).tm ;
    return SafeArea(
      child: Scaffold(
        drawer: MyDrawer(),
        appBar: customAppBar(themeMode, context, "Orders"),
        body: SingleChildScrollView(
          child: StreamBuilder<QuerySnapshot>(
            stream: EcommerceApp.firestore.collection(EcommerceApp.collectionUser)
                .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
                .collection(EcommerceApp.collectionOrders).snapshots(),
            builder: (c,snapshot){
              return snapshot.hasData
                  ? ListView.builder(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
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
        )
      
    );
  }
}
