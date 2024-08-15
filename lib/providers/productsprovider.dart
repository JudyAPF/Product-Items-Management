import 'package:flutter/material.dart';
import 'package:statemanagement/helpers/dbhelper.dart'; 
import 'package:statemanagement/models/product.dart';

class Products extends ChangeNotifier {
  List<Product> _items = [];

  Future<List<Product>> get items async {
    var list = await DbHelper.fetchProducts();
    _items = list.map((item) => Product.fromMap(item)).toList();
    return _items;
  }
 
  int get totalNoItems {
    return _items.length;
  }

  void add(Product p) {
    DbHelper.insertProduct(p); 
    notifyListeners();
  }

  void update(Product p, int index) {
    DbHelper.updateProduct(p); 
    _items[index] = p;
    notifyListeners();
  }

  void toggleFavorite(int index) {
    _items[index].isFavorite = !_items[index].isFavorite;
    notifyListeners();
    DbHelper.updateProductFavoriteStatus(_items[index].code, _items[index].isFavorite);
  }

  Product item(int index) => _items[index];

  bool showFavoritesOnly = false;

  void toggleShowFavoritesOnly(bool value) {
    showFavoritesOnly = !showFavoritesOnly;
    notifyListeners();
  }

  void remove(String code) async {
    _items.removeWhere((item) => item.code == code);
    await DbHelper.deleteProduct(code);
    notifyListeners();
  }

}