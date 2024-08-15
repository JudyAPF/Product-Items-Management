import 'package:flutter/material.dart';
import 'package:statemanagement/helpers/dbhelper.dart';
import 'package:statemanagement/models/cartitem.dart';

class CartItems extends ChangeNotifier {
  List<CartItem> _items = [];

  Future<List<CartItem>> get items async {
    var list = await DbHelper.fetchCartItems();
    _items = list.map((item) => CartItem.fromMap(item)).toList();
    return _items;
  }

  int get totalNoItems => _items.length;

  Future<void> add(CartItem cartItem) async {
  var existingCartItem = _items.firstWhere(
    (item) => item.code == cartItem.code,
    orElse: () => CartItem(code: '', quantity: 0), // Create a default cart item if not found
  );

  if (existingCartItem.code.isNotEmpty) {
    // Product already exists in the cart, increment quantity
    existingCartItem.quantity++;
    await DbHelper.updateCartItem(existingCartItem); // Update the cart item in the database
  } else {
    // Product does not exist in the cart, add it
    _items.add(cartItem);
    await DbHelper.insertCart(cartItem); // Insert the cart item into the database
  }
  
  notifyListeners();
}

void remove(String code) async {
    _items.removeWhere((item) => item.code == code);
    await DbHelper.deleteCartItem(code);
    notifyListeners();
  }


}
