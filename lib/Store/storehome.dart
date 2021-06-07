import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commerce/Config/config.dart';

import 'package:commerce/Store/cart.dart';
import 'package:commerce/Store/product_page.dart';
import 'package:commerce/Counters/cartitemcounter.dart';
import 'package:commerce/Widgets/loadingWidget.dart';
import 'package:commerce/providers/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../Widgets/main_drawer.dart';
import '../Models/item.dart';
import 'Search.dart';

double width;

class StoreHome extends StatefulWidget {

  @override
  _StoreHomeState createState() => _StoreHomeState();
}

class _StoreHomeState extends State<StoreHome> {

  List<String> sliderImages = [
    'assets/slider_images/1615441020ydvqD.item_XXL_51889566_32a329591e022.jpeg',
    'assets/slider_images/1615450256e0bZk.item_XXL_7582156_7501823.jpeg',
    'assets/slider_images/1615451715MqRD4.item_XXL_131956716_5973d6a4ae72f.jpeg',
    'assets/slider_images/1615452417AmlJk.item_XXL_42123558_50e9b1ffa8fe5.jpeg',
    'assets/slider_images/1619472351ITAM5.3bb51c97376281.5ec3ca8c1e8c5.jpg',
    'assets/slider_images/1619875101BSVpU.1.jpg',
    'assets/slider_images/1620253816SgPr3.1.jpg',
    'assets/slider_images/16202548748OGFF.1.jpg',
    'assets/slider_images/1620867082asmxD.1.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    var themeMode = Provider.of<ThemeProvider>(context).tm;
    width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            elevation: 2,
            backgroundColor: themeMode == ThemeMode.dark
                ? Theme.of(context).canvasColor
                : Colors.white,
            iconTheme: IconThemeData(
              color:
                  themeMode == ThemeMode.dark ? Colors.white : Colors.blue[900],
            ),
            title: Text(
              'E-Shopping',
              style: GoogleFonts.satisfy(
                  textStyle: TextStyle(
                      color: themeMode == ThemeMode.dark
                          ? Colors.white
                          : Colors.blue[900],
                      fontSize: 30)),
            ),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.search,
                    size: 30,
                    color: themeMode == ThemeMode.dark
                        ? Colors.white
                        : Colors.blue[900],
                  ),
                  onPressed: () {
                    Route route = MaterialPageRoute(builder: (c) => SearchProduct());
                    Navigator.pushReplacement(context, route);
                  }),
              Center(
                child: Stack(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.shopping_cart,
                        color: themeMode == ThemeMode.dark
                            ? Colors.white
                            : Colors.blue[900],
                      ),
                      onPressed: () {
                        Route route =
                            MaterialPageRoute(builder: (c) => CartPage());
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
                                                  .getStringList(
                                                      EcommerceApp.userCartList)
                                                  .length ==
                                              null
                                          ? 0.toString()
                                          : EcommerceApp.sharedPreferences
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
              ),
            ],
          ),
          drawer: MyDrawer(),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    'Best Offers',
                    style: GoogleFonts.oswald(
                      textStyle: TextStyle(
                          color: themeMode == ThemeMode.dark
                              ? Colors.white
                              : Colors.blue[900],
                          fontSize: 27,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
                CarouselSlider(
                    items: sliderImages.map((i) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        child: Image(
                          image: AssetImage(i),
                          fit: BoxFit.fill,
                          height: 180,
                        ),
                      );
                    }).toList(),
                    options: CarouselOptions(
                      height: 180,
                      aspectRatio: 16 / 9,
                      viewportFraction: 1,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 3),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      scrollDirection: Axis.horizontal,
                    )),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    'Products',
                    style: GoogleFonts.oswald(
                      textStyle: TextStyle(
                          color: themeMode == ThemeMode.dark
                              ? Colors.white
                              : Colors.blue[900],
                          fontSize: 27,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("items")
                        .limit(15)
                        .orderBy("publishedDate", descending: true)
                        .snapshots(),
                    builder: (context, dataSnapshot) {
                      return !dataSnapshot.hasData
                          ? Center(
                              child: circularProgress(),
                            )
                          : GridView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              physics: BouncingScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 250,
                                childAspectRatio: 1 / 1.8,
                                crossAxisSpacing: 0,
                                mainAxisSpacing: 0,
                              ),
                              itemBuilder: (ctx, index) {
                                ItemModel model = ItemModel.fromJson(
                                    dataSnapshot.data.docs[index].data());
                                return productsInfo(model, ctx);
                              },
                              itemCount: dataSnapshot.data.docs.length,
                            );
                    }),
              ],
            ),
          )),
    );
  }
}

Widget productsInfo(ItemModel itemModel, BuildContext context,
    {Color background, removeCartFunction,Widget widget}) {
  var themeMode = Provider.of<ThemeProvider>(context).tm;

  return Card(
    semanticContainer: true,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    color: themeMode == ThemeMode.dark ? Colors.white : Colors.black87,
    child: InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        Route route = MaterialPageRoute(
            builder: (c) => ProductPage(
                  itemModel: itemModel,
                ));
        Navigator.push(context, route);
      },
      splashColor: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(1),
        child: Container(
          decoration: BoxDecoration(
            color: themeMode == ThemeMode.dark
                ? Theme.of(context).canvasColor
                : Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 5,
              ),
              Center(
                child: Stack(
                  alignment: AlignmentDirectional.bottomStart,
                  children: [
                    Image.network(
                      itemModel.thumbnailUrl,
                      width: 150,
                      height: 160,
                      fit: BoxFit.contain,
                    ),
                    if (itemModel.discount != 0)
                      Container(
                        height: 15,
                        color: Colors.red,
                        child: Text(
                          'Discount',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(
                width: 4,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 5),
                child: Text(
                  itemModel.title,
                  style: Theme.of(context).textTheme.headline4,
                  maxLines: 2,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 10,
                  ),
                  cardPrice(
                      Text(
                        '${removeCartFunction == null ?(itemModel.price).toString() :(itemModel.price*itemModel.numberOfItem).toString()} EGP',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      Colors.blue[900]),
                  if (itemModel.discount != 0)
                    if(removeCartFunction == null)
                    cardPrice(
                        Text(
                          '${(itemModel.oldPrice).toString()} EGP',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              decoration: TextDecoration.lineThrough,
                              decorationColor: Colors.black87),
                        ),
                        Colors.blue[300]),
                  Spacer(),
                  if(removeCartFunction != null )
                    widget
                ],
              ),
              Align(
                  alignment: Alignment.bottomRight,
                  child: removeCartFunction == null
                      ? IconButton(
                          icon: Icon(
                              itemModel.productInCart == false ?Icons.add_shopping_cart : Icons.shopping_cart ,
                            color: themeMode == ThemeMode.dark
                                ? Colors.white
                                : Colors.blue[900],
                            size: 25,
                          ),
                          onPressed: () {
                            checkItemInCart(itemModel,itemModel.shortInfo, context);
                          },
                        )
                      : IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: themeMode == ThemeMode.dark
                                ? Colors.white
                                : Colors.blue[900],
                          ),
                          onPressed: () {
                            removeCartFunction();
                          },
                        )),
            ],
          ),
        ),
      ),
    ),
  );
}

void checkItemInCart(ItemModel itemModel,String productID, BuildContext context) {
  EcommerceApp.sharedPreferences
          .getStringList(EcommerceApp.userCartList)
          .contains(productID)
      ? Fluttertoast.showToast(msg: 'Item Already in Cart')
      : Provider.of<CartItemCounter>(context, listen: false)
          .addItemToCart(productID, context).then((value){
    EcommerceApp.firestore.collection('items').doc(itemModel.shortInfo).update({
      'productInCart' : true
    });
  });
}

Widget cardPrice(Widget child, Color color) {
  return Container(
    decoration: BoxDecoration(
      shape: BoxShape.rectangle,
      color: color,
    ),
    height: 25,
    width: 80,
    alignment: Alignment.topLeft,
    child: Center(child: child),
  );
}
