import 'package:commerce/Admin/admin_product_details/admin_product_details_provider.dart';
import 'package:commerce/Models/item.dart';
import 'package:commerce/Widgets/customTextField.dart';
import 'package:commerce/Widgets/loadingWidget.dart';
import 'package:commerce/Widgets/wideButton.dart';
import 'package:commerce/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class AdminProductDetails extends StatefulWidget {
  final ItemModel itemModel;
  AdminProductDetails({this.itemModel});
  @override
  _AdminProductDetailsState createState() => _AdminProductDetailsState();
}
class _AdminProductDetailsState extends State<AdminProductDetails> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
     TextEditingController _priceController =  TextEditingController();
     TextEditingController _discountController =  TextEditingController();
     TextEditingController _oldPriceController =  TextEditingController();
     TextEditingController _titleController =  TextEditingController();
    var themeMode = Provider.of<ThemeProvider>(context).tm;
    _priceController.text = widget.itemModel.price.toString();
    _discountController.text = widget.itemModel.discount.toString();
    _oldPriceController.text = widget.itemModel.oldPrice.toString();
    _titleController.text = widget.itemModel.title;
    return Consumer<AdminProductDetailsProvider>(
     builder: (context,_provider,_){
       return SafeArea(
         child: Scaffold(
           appBar: AppBar(
             elevation: 0,
             backgroundColor: themeMode == ThemeMode.dark
                 ? Theme.of(context).canvasColor
                 : Colors.white,
             iconTheme: IconThemeData(
               color: themeMode == ThemeMode.dark
                   ? Colors.white
                   : Colors.blue[900],
             ),
           ),
           body: SingleChildScrollView(
             child: Form(
               key: _formKey,
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: <Widget>[
                   CustomTextField(
                     hintText: 'Price :',
                     isObsecure: false,
                     controller: _priceController,
                   ),
                   CustomTextField(
                     hintText: 'old Price :',
                     isObsecure: false,
                     controller: _oldPriceController,
                   ),
                   CustomTextField(
                     hintText: 'Discount :',
                     isObsecure: false,
                     controller: _discountController,
                   ),
                   CustomTextField(
                     hintText: 'Title :',
                     isObsecure: false,
                     controller: _titleController,
                   ),
                   SizedBox(
                     height: 10,
                   ),
                   Provider.of<AdminProductDetailsProvider>(context).uploading==true? linearProgress() : Center(
                     child: WideButton(
                       message: 'Update',
                       onPressed: () {
                         if (_formKey.currentState.validate()) {
                           Provider.of<AdminProductDetailsProvider>(context,listen: false).updateProduct(
                             int.parse(_priceController.text),
                             int.parse(_oldPriceController.text),
                             int.parse(_discountController.text),
                             widget.itemModel.shortInfo,
                             _titleController.text,
                           );
                         }
                       },
                     ),
                   ),
                 ],
               ),
             ),
           ),
         ),
       );
     },
    );
  }

}
