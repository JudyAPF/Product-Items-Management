import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:statemanagement/models/cartitem.dart';
import 'package:statemanagement/providers/cartprovider.dart';
import 'package:statemanagement/providers/productsprovider.dart';
import 'package:statemanagement/screens/manageproduct.dart';
import 'package:statemanagement/screens/viewcart.dart';

// ignore: use_key_in_widget_constructors
class ViewProductsScreen extends StatefulWidget {
  @override
  State<ViewProductsScreen> createState() => _ViewProductsScreenState();
}

class _ViewProductsScreenState extends State<ViewProductsScreen> {
  void openAddScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ManageProductScreen(),
    ));
  }

  void openEditScreen(BuildContext context, int index) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ManageProductScreen(index: index),
    ));
  }

  void addToCart(BuildContext context, String pCode) {
    Provider.of<CartItems>(context, listen: false).add(
      CartItem(
        code: pCode,
      ),
    );
  }

  bool showFavoritesOnly = false;

  @override
  Widget build(BuildContext context) {
    var productsProvider = Provider.of<Products>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('View Products'),
        actions: [
          IconButton(
            onPressed: () => openAddScreen(context),
            icon: const Icon(Icons.add),
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                // ignore: sort_child_properties_last
                child: Text('All'),
                value: 'all',
              ),
              const PopupMenuItem(
                // ignore: sort_child_properties_last
                child: Text('Favorites Only'),
                value: 'favorites',
              ),
            ],
            onSelected: (value) {
              productsProvider.toggleShowFavoritesOnly(value == 'favorites');
            },
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Consumer<Products>(builder: (_, products, c) {
        return FutureBuilder(
          future: products.items,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            var productList = snapshot.data;

            if (products.showFavoritesOnly) {
              if (productList == null || productList.isEmpty) {
                return const Center(
                  child: Text('No favorite products found'),
                );
              }
              productList =
                  productList.where((product) => product.isFavorite).toList();
            }

            if (productList!.isEmpty) {
              return Center(
                child: Opacity(
                  opacity: 0.3,
                  child: Image.asset(
                    'assets/images/empty_list.png',
                    width: MediaQuery.of(context).size.width * 0.3,
                  ),
                ),
              );
            }
            return ListView.builder(
              itemBuilder: (_, index) => Padding(
                padding: const EdgeInsets.all(10),
                child: Dismissible(
                  key: Key(productList![index].code),
                  direction: DismissDirection.startToEnd,
                  onDismissed: (direction) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete Product'),
                        content: Text(
                            'Are you sure you want to delete ${productList![index].code}?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              productsProvider.remove(productList![index].code);
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
                        onTap: () => openEditScreen(context, index),
                        leading: IconButton(
                          onPressed: () {
                            productsProvider.toggleFavorite(index);
                          },
                          icon: Icon(productList[index].isFavorite
                              ? Icons.favorite
                              : Icons.favorite_outline),
                        ),
                        title: Text(productList[index].code),
                        trailing: IconButton(
                          onPressed: () =>
                              addToCart(context, productList![index].code),
                          icon: const Icon(Icons.shopping_cart_outlined),
                        )),
                  ),
                ),
              ),
              itemCount: productList?.length ?? 0,
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const ViewCartScreen(),
          ),
        ),
        child: const Icon(Icons.shopping_cart_checkout),
      ),
    );
  }
}
