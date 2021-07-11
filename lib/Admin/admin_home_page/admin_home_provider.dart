import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commerce/Config/config.dart';
import 'package:commerce/Models/item.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class AdminHomeScreenProvider with ChangeNotifier {
  File image;
  bool uploading = false;
  String imageUrl;
  ImagePicker imagePicker = ImagePicker();

  Widget selectOptionCard(String text, Function function) {
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
                  style: TextStyle(color: Colors.blue[900], fontSize: 15)),
            ),
          ),
        ),
      ),
    );
  }

  takeImage(context) {
    showDialog(
        context: context,
        builder: (con) {
          return SimpleDialog(
            title: Text(
              'Select option for product photo',
              style: TextStyle(
                  color: Colors.blue[900], fontWeight: FontWeight.bold),
            ),
            children: <Widget>[
              selectOptionCard("Capture with Camera", capturePhotoWithCamera),
              selectOptionCard("Select from Gallery", pickPhotoFromGallery),
              selectOptionCard("Cancel", () => Navigator.pop(context)),
            ],
          );
        });
    notifyListeners();
  }

  capturePhotoWithCamera() async {
    final imageFile = await imagePicker.getImage(source: ImageSource.camera);
    if (imageFile != null) {
      image = File(imageFile.path);
    }
    //Navigator.of(context).pop();
    notifyListeners();
  }

  pickPhotoFromGallery() async {
    final imageFile = await imagePicker.getImage(source: ImageSource.gallery);
    if (imageFile != null) {
      image = File(imageFile.path);
    }
    //Navigator.of(context).pop();
    notifyListeners();
  }

  deleteProduct(context, ItemModel itemModel) {
    return showDialog(
        context: context,
        builder: (value) {
          return SimpleDialog(
            title: Text(
              'Are you sure ?',
              style: TextStyle(
                  color: Colors.blue[900], fontWeight: FontWeight.bold),
            ),
            children: <Widget>[
              selectOptionCard("Ok", () {
                EcommerceApp.firestore
                    .collection('items')
                    .doc(itemModel.shortInfo)
                    .delete();
                Navigator.pop(context);
              }),
              selectOptionCard("Cancel", () => Navigator.pop(context)),
            ],
          );
        }).then((value) {
      notifyListeners();
    });
  }

  clearFormInfo(
    TextEditingController priceController,
    TextEditingController oldPriceController,
    TextEditingController discountController,
    TextEditingController titleController,
    TextEditingController descriptionController,
    TextEditingController shortInfoController,
  ) {
    image = null;
    priceController.clear();
    oldPriceController.clear();
    discountController.clear();
    titleController.clear();
    descriptionController.clear();
    shortInfoController.clear();
    notifyListeners();
  }

  Future<void> uploadImageAndSaveItemInfo(
    String shortInfo,
    String description,
    String price,
    String title,
    String discount,
    String oldPrice,
    TextEditingController priceController,
    TextEditingController oldPriceController,
    TextEditingController discountController,
    TextEditingController titleController,
    TextEditingController descriptionController,
    TextEditingController shortInfoController,
  ) async {
    uploading = true;
    await uploadItemImage();
    saveItemInfo(
        shortInfo,
        description,
        price,
        title,
        discount,
        oldPrice,
        priceController,
        oldPriceController,
        discountController,
        titleController,
        descriptionController,
        shortInfoController);
    notifyListeners();
  }

  Future uploadItemImage() async {
    Reference ref = FirebaseStorage.instance.ref().child("Items");
    UploadTask uploadTask = ref.putFile(image);
    await uploadTask.whenComplete(() {
      Fluttertoast.showToast(msg: 'Uploaded successfully');
    });
    ref.getDownloadURL().then((fileURL) {
      imageUrl = fileURL;
      notifyListeners();
    });
    notifyListeners();
  }

  saveItemInfo(
    String shortInfo,
    String description,
    String price,
    String title,
    String discount,
    String oldPrice,
    TextEditingController priceController,
    TextEditingController oldPriceController,
    TextEditingController discountController,
    TextEditingController titleController,
    TextEditingController descriptionController,
    TextEditingController shortInfoController,
  ) {
    final itemRef = FirebaseFirestore.instance.collection('items');
    itemRef.doc(shortInfo).set({
      "shortInfo": shortInfo.trim(),
      "longDescription": description.trim(),
      "price": int.parse(price),
      "publishedDate": DateTime.now(),
      "status": "available",
      "thumbnailUrl": imageUrl,
      "title": title.trim(),
      "numberOfItem": 1,
      "discount": int.parse(discount.trim()),
      "old_price": int.parse(oldPrice.trim()),
      "productInCart": false,
    }).then((value) {
      image = null;
      uploading = false;
      descriptionController.clear();
      titleController.clear();
      priceController.clear();
      shortInfoController.clear();
      oldPriceController.clear();
      discountController.clear();
      notifyListeners();
    });

    notifyListeners();
  }
}
