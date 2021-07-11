import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commerce/Config/config.dart';
import 'package:commerce/Address/check_out_address.dart';
import 'package:commerce/Widgets/loadingWidget.dart';
import 'package:commerce/Models/item.dart';
import 'package:commerce/Counters/cartitemcounter.dart';
import 'package:commerce/Counters/totalMoney.dart';
import 'package:commerce/providers/theme_provider.dart';
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
  @override
  Widget build(BuildContext context) {
    var themeMode = Provider.of<ThemeProvider>(context).tm;
    var totalAmount =  Provider.of<TotalAmount>(context, listen: false).totalAmount ;
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
                      totalAmount:  totalAmount,
                    ));
            Navigator.push(context, route);
          }
        },
        label: Text(
          'continue...',
          style: TextStyle(fontWeight: FontWeight.bold,color: themeMode == ThemeMode.dark ? Colors.black87 : Colors.white),
        ),
        backgroundColor:themeMode == ThemeMode.dark ? Colors.white : Colors.blue[900],
        icon: Icon(Icons.navigate_next,color: themeMode == ThemeMode.dark ? Colors.black87 : Colors.white),
      ),
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
          'Cart',
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
                onPressed: () {},
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
      ),
      //drawer: MyDrawer(),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Consumer<TotalAmount>(
              builder: (context, amountProvider, cartProvider) {
                return  Padding(
                  padding: EdgeInsets.all(8),
                  child: Center(
                    child: Text(
                      'Total Price: $totalAmount EGP',
                      style: TextStyle(
                          color: themeMode == ThemeMode.dark
                              ? Colors.white
                              : Colors.blue[900],
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
                      ? noItemsInCard()
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              ItemModel model = ItemModel.fromJson(
                                  snapshot.data.docs[index].data());
                              if (index == 0) {
                                totalAmount = 0;
                                totalAmount = model.price*model.numberOfItem + totalAmount;
                              } else {
                                totalAmount = model.price*model.numberOfItem + totalAmount;
                              }
                              if (snapshot.data.docs.length-1  == index) {
                                Provider.of<TotalAmount>(context,
                                    listen: false)
                                    .display(totalAmount);
                              }
                              return productsInfo(model, context,
                                  removeCartFunction: () async {
                                    showDialog(
                                        context: context,
                                        builder: (value){
                                          return SimpleDialog(
                                            title: Text(
                                              'Are you sure ?',
                                              style:
                                              TextStyle(color: Colors.blue[900], fontWeight: FontWeight.bold),
                                            ),
                                            children: <Widget>[
                                              selectOptionCard(
                                                  "Ok",(){
                                                    Provider.of<CartItemCounter>(context,
                                                    listen: false)
                                                    .removeItemFromCart(model.shortInfo).then((value){
                                                  setState(() {
                                                    EcommerceApp.sharedPreferences
                                                        .getStringList(EcommerceApp.userCartList);
                                                  });
                                                  EcommerceApp.firestore.collection('items').doc(model.shortInfo).update({
                                                    'productInCart' : false
                                                  });
                                                });
                                                Navigator.pop(context);
                                              }
                                              ),
                                              selectOptionCard(
                                                  "Cancel",()=>  Navigator.pop(context)
                                              ),
                                            ],
                                          );
                                        }
                                    );
                              },widget:  Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  color: themeMode == ThemeMode.dark
                                      ? Colors.white
                                      : Colors.black87,
                                  child: Padding(
                                    padding: EdgeInsets.all(1),
                                    child: Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: themeMode == ThemeMode.dark
                                            ? Theme.of(context).canvasColor
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.remove,
                                                color: themeMode == ThemeMode.dark
                                                    ? Colors.white
                                                    : Colors.black87),
                                            onPressed: () {
                                              if(model.numberOfItem == 1){
                                                // ignore: unnecessary_statements
                                                    (){};
                                              }else{
                                                model.numberOfItem -- ;
                                                EcommerceApp.firestore.collection('items').doc(model.shortInfo).update({
                                                  'numberOfItem' : model.numberOfItem ,
                                                });
                                                setState(() {
                                                  model.numberOfItem = model.numberOfItem ;
                                                });
                                              }
                                            },
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text('${model.numberOfItem}'),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          IconButton(
                                              icon: Icon(Icons.add,
                                                  color: themeMode == ThemeMode.dark
                                                      ? Colors.white
                                                      : Colors.black87),
                                              onPressed: () {
                                                model.numberOfItem ++ ;
                                                EcommerceApp.firestore.collection('items').doc(model.shortInfo).update({
                                                  'numberOfItem' : model.numberOfItem ,
                                                });
                                                setState(() {
                                                  model.numberOfItem = model.numberOfItem ;
                                                });
                                              }),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );

                            },
                            childCount:snapshot.data.docs.length,
                          ),
                        );
            },
          ),
        ],
      ),
    );
  }
  Widget selectOptionCard(String text,Function function){
    return Card(
      color: Colors.black87,
      child: Padding(
        padding: const EdgeInsets.all(1),
        child: InkWell(
          onTap: function,
          child: Container(
            height: 30,
            color: Colors.white,
            child: Center(
              child: Text(text,
                  style: TextStyle(
                      color: Colors.blue[900],
                      fontSize: 15
                  )),
            ),
          ),
        ),
      ),
    );
  }
  noItemsInCard() {
    return SliverToBoxAdapter(
      child: Card(
        color: Colors.blue[900],
        child: Container(
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.insert_emoticon,
                color: Colors.white,
              ),
              Text('Cart is Empty',style: TextStyle(color: Colors.white),),
              Text('Add items to your Cart',style: TextStyle(color: Colors.white),),
            ],
          ),
        ),
      ),
    );
  }

}
