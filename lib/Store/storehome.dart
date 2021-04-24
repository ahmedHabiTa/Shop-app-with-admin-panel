import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commerce/Config/config.dart';
import 'package:commerce/Store/cart.dart';
import 'package:commerce/Store/product_page.dart';
import 'package:commerce/Counters/cartitemcounter.dart';
import 'package:commerce/Widgets/loadingWidget.dart';
import 'package:commerce/Widgets/searchBox.dart';
import 'package:commerce/providers/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../Widgets/myDrawer.dart';
import '../Models/item.dart';

double width;

class StoreHome extends StatefulWidget {
  @override
  _StoreHomeState createState() => _StoreHomeState();
}

class _StoreHomeState extends State<StoreHome> {
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
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
            'E-Shopping',
            style: GoogleFonts.satisfy(
                textStyle: TextStyle(color: Colors.white, fontSize: 40)),
          ),
          centerTitle: true,
          actions: <Widget>[
            Stack(
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.shopping_cart,
                    color: Colors.pink,
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
        ),
        drawer: MyDrawer(),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverPersistentHeader(
              pinned: true,
              delegate: SearchBoxDelegate(),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("items")
                  .limit(15)
                  .orderBy("publishedDate", descending: true)
                  .snapshots(),
              builder: (context, dataSnapshot) {
                return !dataSnapshot.hasData
                    ? SliverToBoxAdapter(
                        child: Center(
                          child: circularProgress(),
                        ),
                      )
                    : SliverStaggeredGrid.countBuilder(
                        crossAxisCount: 1,
                        staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                        itemBuilder: (context, index) {
                          ItemModel model = ItemModel.fromJson(
                              dataSnapshot.data.docs[index].data());
                          return sourceInfo(model, context);
                        },
                        itemCount: dataSnapshot.data.docs.length,
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}

Widget sourceInfo(ItemModel model, BuildContext context,
    {Color background, removeCartFunction}) {
  var mode = Provider.of<ThemeProvider>(context).tm;
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    color:
        mode == ThemeMode.dark ? Theme.of(context).canvasColor : Colors.white,
    child: InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: () {
        Route route = MaterialPageRoute(
            builder: (c) => ProductPage(
                  itemModel: model,
                ));
        Navigator.pushReplacement(context, route);
      },
      splashColor: Colors.pink,
      child: Padding(
        padding: EdgeInsets.all(6),
        child: Container(
          height: 180,
          width: width,
          child: Row(
            children: <Widget>[
              Image.network(
                model.thumbnailUrl,
                width: 140,
                height: 160,
              ),
              SizedBox(
                width: 4,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        model.title,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        model.shortInfo,
                        style: TextStyle(
                            color: mode == ThemeMode.dark
                                ? Colors.white
                                : Colors.black87,
                            fontSize: 12),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.pink[300],
                            ),
                            height: 50,
                            width: 40,
                            alignment: Alignment.topLeft,
                            child: Center(
                              child: Text(
                                '\$ ${(model.price + model.price).toString()}',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    decoration: TextDecoration.lineThrough),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.pink,
                            ),
                            height: 50,
                            width: 40,
                            alignment: Alignment.topLeft,
                            child: Center(
                              child: Text(
                                '\$ ${(model.price).toString()}',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                      Align(
                          alignment: Alignment.bottomRight,
                          child: removeCartFunction == null
                              ? IconButton(
                            icon: Icon(
                              Icons.add_shopping_cart,
                              color: Colors.pinkAccent,
                              size: 30,
                            ),
                            onPressed: () {
                              checkItemInCart(model.shortInfo, context);
                            },
                          )
                              : IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.pinkAccent,
                            ),
                            onPressed: () {
                              removeCartFunction();
                            },
                          )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

// Widget card({Color primaryColor = Colors.redAccent, String imgPath}) {
//   return Container(
//     height: 150,
//     width: width * 0.34,
//     margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//     decoration: BoxDecoration(
//         color: primaryColor,
//         borderRadius: BorderRadius.all(Radius.circular(20)),
//         boxShadow: <BoxShadow>[
//           BoxShadow(
//               offset: Offset(0, 5), blurRadius: 10, color: Colors.grey[200]),
//         ]),
//     child: ClipRRect(
//       borderRadius: BorderRadius.all(Radius.circular(20)),
//       child: Image.network(
//         imgPath,
//         height: 150,
//         width: width * 0.34,
//         fit: BoxFit.fill,
//       ),
//     ),
//   );
// }

void checkItemInCart(String productID, BuildContext context) {
  EcommerceApp.sharedPreferences
          .getStringList(EcommerceApp.userCartList)
          .contains(productID)
      ? Fluttertoast.showToast(msg: 'Item Already in Cart')
      : Provider.of<CartItemCounter>(context, listen: false)
          .addItemToCart(productID, context);
}
