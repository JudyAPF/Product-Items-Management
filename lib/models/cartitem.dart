import 'package:statemanagement/helpers/dbhelper.dart';

class CartItem {
  late String code;
  late int quantity;

  CartItem({
    required this.code,
    this.quantity = 1,
  });

  Map<String, dynamic> toMap() {
    return {
      DbHelper.cartProdCode: code,
      DbHelper.cartQuantity: quantity,
    };
  }

  CartItem.fromMap(Map<String, dynamic> value) {
    code = value[DbHelper.cartProdCode];
    quantity = value[DbHelper.cartQuantity];
  }

  

}