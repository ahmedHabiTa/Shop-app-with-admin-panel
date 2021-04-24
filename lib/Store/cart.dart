import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commerce/Config/config.dart';
import 'package:commerce/Address/check_out_address.dart';
import 'package:commerce/Widgets/loadingWidget.dart';
import 'package:commerce/Models/item.dart';
import 'package:commerce/Counters/cartitemcounter.dart';
import 'package:commerce/Counters/totalMoney.dart';

import 'package:commerce/Widgets/myDrawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:commerce/Store/storehome.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {


  double totalAmount;

  @override
  void initState() {
    super.initState();
    totalAmount = 0;
    Provider.of<TotalAmount>(context, listen: false).display(0);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (EcommerceApp.sharedPreferences
                  .getStringList(EcommerceApp.userCartList)
                  .length ==
              1) {
            Fluttertoast.showToast(msg: 'Cart is Empty');
          } else {
            Route route = MaterialPageRoute(
                builder: (c) => Address(
                      totalAmount: totalAmount,
                    ));
            Navigator.push(context, route);
          }
        },
        label: Text(
          'check Out Address',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromRGBO(255, 105, 150, 1),
        icon: Icon(Icons.navigate_next),
      ),
      appBar: AppBar(
        actions: [
          Stack(
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.shopping_cart,
                  color: Colors.pink,
                ),
                onPressed: null,
              ),
              Positioned(
                child: Stack(
                  children: <Widget>[
                    Icon(
                      Icons.brightness_1,
                      size: 20,
                      color: Colors.green,
                    ),
                    Positioned(
                      top: 3,
                      bottom: 4,
                      left: 4,
                      child: Consumer<CartItemCounter>(
                        builder: (context, counter, _) {
                          return Text(
                            (EcommerceApp.sharedPreferences
                                        .getStringList(
                                            EcommerceApp.userCartList)
                                        .length -
                                    1)
                                .toString(),
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
          'Cart',
          style: GoogleFonts.satisfy(
              textStyle: TextStyle(color: Colors.white, fontSize: 40)),
        ),
        centerTitle: true,
      ),
      drawer: MyDrawer(),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Consumer2<TotalAmount, CartItemCounter>(
              builder: (context, amountProvider, cartProvider, c) {
                return Padding(
                  padding: EdgeInsets.all(8),
                  child: Center(
                    child: cartProvider.count == 0
                        ? Container()
                        : Text(
                            'Total Price: \$ ${amountProvider.totalAmount.toString()}',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          ),
                  ),
                );
              },
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: EcommerceApp.firestore
                .collection('items')
                .where('shortInfo',
                    whereIn: EcommerceApp.sharedPreferences
                        .getStringList(EcommerceApp.userCartList))
                .snapshots(),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? SliverToBoxAdapter(
                      child: Center(
                        child: circularProgress(),
                      ),
                    )
                  : snapshot.data.docs.length == 0
                      ? beginBuildingCart()
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              ItemModel model = ItemModel.fromJson(
                                  snapshot.data.docs[index].data());
                              if (index == 0) {
                                totalAmount = 0;
                                totalAmount = model.price + totalAmount;
                              } else {
                                totalAmount = model.price + totalAmount;
                              }
                              if (snapshot.data.docs.length - 1 == index) {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((t) {
                                  Provider.of<TotalAmount>(context,
                                          listen: false)
                                      .display(totalAmount);
                                });
                              }
                              return sourceInfo(model, context,
                                  removeCartFunction: () async {
                                await Provider.of<CartItemCounter>(context,
                                        listen: false)
                                    .removeItemFromCart(model.shortInfo).then((value){
                                  setState(() {
                                    EcommerceApp.sharedPreferences
                                        .getStringList(EcommerceApp.userCartList);
                                  });
                                });
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text('Removed from cart'),
                                  duration: Duration(seconds: 3),
                                  action: SnackBarAction(
                                    label: 'UNDO!',
                                    onPressed: () async{
                                      await Provider.of<CartItemCounter>(context,
                                          listen: false)
                                          .addItemToCart(model.shortInfo,context).then((v){
                                         setState(() {
                                           EcommerceApp.sharedPreferences
                                               .getStringList(EcommerceApp.userCartList);
                                         });
                                       });
                                    },
                                  ),
                                ));

                              });
                            },
                            childCount: snapshot.hasData
                                ? snapshot.data.docs.length
                                : 0,
                          ),
                        );
            },
          ),
        ],
      ),
    );
  }

  beginBuildingCart() {
    return SliverToBoxAdapter(
      child: Card(
        color: Theme.of(context).primaryColor.withOpacity(0.5),
        child: Container(
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.insert_emoticon,
                color: Colors.white,
              ),
              Text('Cart is Empty'),
              Text('Add items to your Cart'),
            ],
          ),
        ),
      ),
    );
  }
}
