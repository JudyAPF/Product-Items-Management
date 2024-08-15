import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:statemanagement/providers/cartprovider.dart';

class ViewCartScreen extends StatefulWidget {
  const ViewCartScreen({super.key});

  @override
  State<ViewCartScreen> createState() => _ViewCartScreenState();
}

class _ViewCartScreenState extends State<ViewCartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
      ),
      body: Consumer<CartItems>(
        builder: (_, cartItems, c) => FutureBuilder(
          future: cartItems.items,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            var cartItemList = snapshot.data;

            if (cartItemList == null || cartItemList.isEmpty) {
              return const Center(
                child: Text('No items in cart found'),
              );
            }

            return ListView.builder(
              itemCount: cartItemList.length,
              itemBuilder: (_, index) => Padding(
                padding: const EdgeInsets.all(10),
                child: Dismissible(
                  key: Key(cartItemList[index].code),
                  direction: DismissDirection.startToEnd,
                  onDismissed: (direction) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete Product in Cart'),
                        content: Text(
                            'Are you sure you want to delete ${cartItemList[index].code}?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Provider.of<CartItems>(context, listen: false)
                                  .remove(cartItemList[index].code);
                            },
                            child: const Text('Yes'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              setState(() {});
                            },
                            child: const Text('No'),
                          ),
                        ],
                      ),
                    );
                  },
                  background: Container(
                    color: Colors.red, // Background color when swiping
                    alignment: Alignment.centerLeft,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Card(
                    child: ListTile(
                      title: Text(cartItemList[index].code),
                      trailing: Text(cartItemList[index].quantity.toString()),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
