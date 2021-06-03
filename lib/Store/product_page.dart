import 'package:commerce/Store/product_detailed_description.dart';
import 'package:commerce/Store/storehome.dart';
import 'package:commerce/Widgets/customAppBar.dart';
import 'package:commerce/Widgets/main_Drawer.dart';
import 'package:commerce/Models/item.dart';
import 'package:commerce/Widgets/wideButton.dart';
import 'package:commerce/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductPage extends StatefulWidget {
  final ItemModel itemModel;

  ProductPage({this.itemModel});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
    var themeMode = Provider.of<ThemeProvider>(context).tm;
    return SafeArea(
      child: Scaffold(
        floatingActionButton: WideButton(
          message: "Add to Cart",
          onPressed: () => checkItemInCart(widget.itemModel.shortInfo, context),
        ),
        appBar: customAppBar(themeMode, context, ''),
        //drawer: MyDrawer(),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left :12.0),
                child: Center(
                  child: Text(
                    widget.itemModel.title,
                      style: Theme.of(context).textTheme.headline3,maxLines: 2,),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Stack(
                  alignment: AlignmentDirectional.bottomStart,
                  children: [
                    Image.network(
                      widget.itemModel.thumbnailUrl,
                      height: 350,
                      width: 300,
                      fit: BoxFit.contain,
                    ),
                    if(widget.itemModel.discount != 0)
                      Container(
                        height: 22,
                        color: Colors.red,
                        child: Text('Discount',style: TextStyle(color: Colors.white,fontSize: 20)),
                      ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    Text("EGP  "+ '${widget.itemModel.price*widget.itemModel.numberOfItem}',
                        style: Theme.of(context).textTheme.headline3),
                    SizedBox(
                      width: 15,
                    ),
                    Card(
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
                                 if(widget.itemModel.numberOfItem == 1){
                                   // ignore: unnecessary_statements
                                   (){};
                                 }else{
                                   setState(() {
                                     widget.itemModel.numberOfItem--;
                                   });
                                 }
                                },
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text('${widget.itemModel.numberOfItem}'),
                              SizedBox(
                                width: 10,
                              ),
                              IconButton(
                                  icon: Icon(Icons.add,
                                      color: themeMode == ThemeMode.dark
                                          ? Colors.white
                                          : Colors.black87),
                                  onPressed: () {
                                    setState(() {
                                      widget.itemModel.numberOfItem++;
                                    });
                                  }),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                color: themeMode == ThemeMode.dark
                    ? Colors.white
                    : Colors.black87,
                child: Padding(
                  padding: EdgeInsets.all(1),
                  child: Container(
                    //height: 40,
                    decoration: BoxDecoration(
                      color: themeMode == ThemeMode.dark
                          ? Theme.of(context).canvasColor
                          : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Center(
                        child: InkWell(
                          onTap: (){
                            Route route = MaterialPageRoute(
                                builder: (c) => ProductDetailedDescription(itemModel: widget.itemModel ,));
                            Navigator.push(context, route);
                          },
                          child: Text(
                            widget.itemModel.longDescription,
                            style: Theme.of(context).textTheme.headline3,
                            maxLines: 7,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
