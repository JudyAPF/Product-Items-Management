import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:statemanagement/models/product.dart';
import 'package:statemanagement/providers/productsprovider.dart';

// ignore: must_be_immutable
class ManageProductScreen extends StatelessWidget {
  ManageProductScreen({super.key, this.index});
  int? index;

  final _formKey = GlobalKey<FormState>();

  var codeController = TextEditingController();
  var descController = TextEditingController();
  var priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var productsProvider = Provider.of<Products>(context, listen: false);
    Product? product;

    if (index != null) {
      product = productsProvider.item(index!);
      codeController.text = product.code;
      descController.text = product.nameDesc;
      priceController.text = product.price.toString();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(index == null ? 'Add Product' : 'Edit Product'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(10),
          children: [
            TextFormField(
              readOnly: product != null,
              controller: codeController,
              decoration: const InputDecoration(
                  label: Text('Product Code'), border: OutlineInputBorder()),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Product code is required';
                }
                return null;
              },
            ),
            const Gap(10),
            TextFormField(
              controller: descController,
              decoration: const InputDecoration(
                  label: Text('Description'), border: OutlineInputBorder()),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Description is required';
                }
                return null;
              },
            ),
            const Gap(10),
            TextFormField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  label: Text('Price'), border: OutlineInputBorder()),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Price is required';
                }
                // Validate if the input can be parsed as a double
                if (double.tryParse(value) == null) {
                  return 'Invalid price';
                }

                if (double.parse(value) <= 0) {
                  return 'Price must be greater than 0';
                }
                return null;
              },
            ),
            const Gap(10),
            ElevatedButton(
                onPressed: () {
                if (_formKey.currentState!.validate()) {
                  var p = Product(
                    code: codeController.text,
                    nameDesc: descController.text,
                    price: double.parse(priceController.text),
                  );
                  if (index == null) {
                    productsProvider.add(p);
                  } else {
                    productsProvider.update(p, index!);
                  }
                  Navigator.pop(context);
                }
              },
                child: Text(index == null ? 'ADD' : 'EDIT')),
          ],
        ),
      ),
    );
  }
}
