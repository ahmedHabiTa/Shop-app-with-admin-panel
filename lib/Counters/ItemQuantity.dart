
import 'package:commerce/Models/item.dart';
import 'package:flutter/foundation.dart';

class ItemQuantity with ChangeNotifier {
  ItemModel itemModel ;
  int _numberOfItems =1 ;
  int get numberOfItems => _numberOfItems ;
    add(int no){
      _numberOfItems = no ;
      _numberOfItems++ ;
      notifyListeners();
    }
  minus(int no){
    _numberOfItems = no ;
    _numberOfItems-- ;
    notifyListeners();
  }


}
