import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commerce/Admin/admin_drawer.dart';
import 'package:commerce/Admin/admin_product_details/admin_product_details_screen.dart';
import 'package:commerce/DialogBox/errorDialog.dart';
import 'package:commerce/Models/item.dart';
import 'package:commerce/Widgets/customTextField.dart';
import 'package:commerce/Widgets/loadingWidget.dart';
import 'package:commerce/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import 'admin_home_provider.dart';
class UploadPage extends StatefulWidget {
  static const routeName = 'UploadPage/';
  @override
  _UploadPageState createState() => _UploadPageState();
}
class _UploadPageState extends State<UploadPage>
    with AutomaticKeepAliveClientMixin<UploadPage> {
  bool get wantKeepAlive => true;
  ItemModel itemModel;
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _shortInfoController = TextEditingController();
  TextEditingController _discountController = TextEditingController();
  TextEditingController _oldPriceController = TextEditingController();
  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Provider.of<AdminHomeScreenProvider>(context).image == null
        ? displayAdminHomeScreen()
        : displayAdminUploadScreen();
  }
  Widget displayAdminHomeScreen() {
    var themeMode = Provider.of<ThemeProvider>(context).tm;
    return Consumer<AdminHomeScreenProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          drawer: AdminDrawer(),
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
              'E-shopping ADMIN',
              style: GoogleFonts.satisfy(
                  textStyle: TextStyle(
                      color: themeMode == ThemeMode.dark
                          ? Colors.white
                          : Colors.blue[900],
                      fontSize: 27)),
            ),
            centerTitle: true,
            actions: [
              Container(
                margin: EdgeInsets.all(3),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: themeMode == ThemeMode.dark
                        ? Colors.white
                        : Colors.blue[900]),
                child: IconButton(
                  icon: Icon(Icons.add,
                      color: themeMode == ThemeMode.dark
                          ? Colors.black87
                          : Colors.white),
                  onPressed: () => provider.takeImage(context),
                ),
              ),
            ],
          ),
          body: adminHomeScreen(),
        );
      },
    );
  }

  Widget adminHomeScreen() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("items")
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
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 250,
                    childAspectRatio: 1 / 1.8,
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 0,
                  ),
                  itemBuilder: (ctx, index) {
                    ItemModel model = ItemModel.fromJson(
                        dataSnapshot.data.docs[index].data());
                    return adminHomeProducts(model, ctx);
                  },
                  itemCount: dataSnapshot.data.docs.length,
                );
        });
  }

  Widget adminHomeProducts(ItemModel itemModel, BuildContext context,
      {Color background}) {
    var themeMode = Provider.of<ThemeProvider>(context).tm;
    return Card(
      semanticContainer: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: themeMode == ThemeMode.dark ? Colors.white : Colors.black87,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Route route = MaterialPageRoute(
              builder: (c) => AdminProductDetails(
                    itemModel: itemModel,
                    // productID: productID,
                  ));
          // print(productID);
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
                        fit: BoxFit.fill,
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
                          '${(itemModel.price).toString()} EGP',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        Colors.blue[900]),
                    if (itemModel.discount != 0)
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
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red[900],
                  ),
                  onPressed: () => Provider.of<AdminHomeScreenProvider>(context,
                          listen: false)
                      .deleteProduct(context, itemModel),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget displayAdminUploadScreen() {
    var themeMode = Provider.of<ThemeProvider>(context).tm;
    return Consumer<AdminHomeScreenProvider>(
      builder: (context, provider, _) {
        return Scaffold(
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
              'New Product',
              style: GoogleFonts.robotoCondensed(
                  textStyle: TextStyle(
                      color: themeMode == ThemeMode.dark
                          ? Colors.white
                          : Colors.blue[900],
                      fontSize: 37)),
            ),
            centerTitle: true,
            leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: themeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.blue[900],
                ),
                onPressed: () {
                  provider.clearFormInfo(
                      _priceController,
                      _oldPriceController,
                      _discountController,
                      _titleController,
                      _descriptionController,
                      _shortInfoController);
                }),
            actions: <Widget>[
              provider.uploading
                  ? circularProgress()
                  : Container(
                      margin: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: themeMode == ThemeMode.dark
                              ? Colors.white
                              : Colors.blue[900]),
                      child: IconButton(
                          icon: Icon(Icons.add,
                              color: themeMode == ThemeMode.dark
                                  ? Colors.black87
                                  : Colors.white),
                          onPressed: () {
                            _titleController.text.isNotEmpty &&
                                    _shortInfoController.text.isNotEmpty &&
                                    _priceController.text.isNotEmpty &&
                                    _oldPriceController.text.isNotEmpty &&
                                    _discountController.text.isNotEmpty &&
                                    _descriptionController.text.isNotEmpty
                                ? provider.uploadImageAndSaveItemInfo(
                                    _shortInfoController.text,
                                    _descriptionController.text,
                                    _priceController.text,
                                    _titleController.text,
                                    _discountController.text,
                                    _oldPriceController.text,
                                    _priceController,
                                    _oldPriceController,
                                    _discountController,
                                    _titleController,
                                    _descriptionController,
                                    _shortInfoController)
                                : showDialog(
                                    context: context,
                                    builder: (c) {
                                      return ErrorAlertDialog(
                                        message: 'Complete all Information',
                                      );
                                    },
                                  );
                          }),
                    ),
            ],
          ),
          body: ListView(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: 250,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                          image: FileImage(provider.image), fit: BoxFit.cover)),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 12),
              ),
              CustomTextField(
                controller: _titleController,
                isObsecure: false,
                hintText: 'Title ',
                data: Icons.perm_device_information,
              ),
              CustomTextField(
                controller: _shortInfoController,
                isObsecure: false,
                hintText: 'Short Info',
                data: Icons.perm_device_information,
              ),
              CustomTextField(
                controller: _priceController,
                isObsecure: false,
                hintText: 'Price',
                data: Icons.perm_device_information,
              ),
              CustomTextField(
                controller: _oldPriceController,
                isObsecure: false,
                hintText: 'Old Price',
                data: Icons.perm_device_information,
              ),
              CustomTextField(
                controller: _discountController,
                isObsecure: false,
                hintText: 'Discount',
                data: Icons.perm_device_information,
              ),
              CustomTextField(
                controller: _descriptionController,
                isObsecure: false,
                hintText: 'Description',
                data: Icons.perm_device_information,
              ),
            ],
          ),
        );
      },
    );
  }
}
