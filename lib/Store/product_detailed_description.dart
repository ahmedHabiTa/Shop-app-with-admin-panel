import 'package:commerce/Models/item.dart';
import 'package:commerce/Widgets/customAppBar.dart';
import 'package:commerce/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailedDescription extends StatelessWidget {
  final ItemModel itemModel;

  ProductDetailedDescription({this.itemModel});

  @override
  Widget build(BuildContext context) {
    var themeMode = Provider.of<ThemeProvider>(context).tm;
    return Scaffold(
        appBar: customAppBar(themeMode, context, ''),
        body: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.all(20),
          child: Container(
            child: Text(
             itemModel.longDescription,
              style: TextStyle(fontSize: 20),
            ),
          ),
        )));
  }
}
