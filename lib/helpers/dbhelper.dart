import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:statemanagement/models/cartitem.dart';
import 'package:statemanagement/models/product.dart';

class DbHelper {
  //constants
  static const dbName = 'products.db';
  static const dbVersion = 18;
  //products table
  static const tbProduct = 'product';
  static const prodCode = 'code';
  static const prodName = 'nameDesc';
  static const prodPrice = 'price';
  static const prodIsFavorite = 'isFavorite';
  //cart table
  static const tbCart = 'cart';
  static const cartProdCode = 'productCode';
  static const cartQuantity = 'quantity';

  static Future<Database> openDb() async {
    //join databases path + dbname file
    var path = join(await getDatabasesPath(), dbName);
    var sql1 =
        'CREATE TABLE IF NOT EXISTS $tbProduct ($prodCode TEXT PRIMARY KEY, $prodName TEXT NOT NULL, $prodPrice DECIMAL(10,2), $prodIsFavorite BOOLEAN)';
    var sql2 =
        'CREATE TABLE IF NOT EXISTS $tbCart ($cartProdCode TEXT PRIMARY KEY, $cartQuantity INTEGER)';

    var db = await openDatabase(
      path,
      version: dbVersion,
      onCreate: (db, version) {
        _createProductTable(db, sql1);
        _createCartTable(db, sql2);
      },
      onUpgrade: (db, oldVersion, newVersion) {
        if (newVersion > oldVersion) {
          db.execute('DROP TABLE IF EXISTS $tbProduct');
          db.execute('DROP TABLE IF EXISTS $tbCart');
          _createProductTable(db, sql1);
          _createCartTable(db, sql2);
        }
      },
    );
    return db;
  }

  static void _createProductTable(Database db, var sql) async {
    await db.execute(sql);
    // print('Table $tbProduct created');
  }

  static void _createCartTable(Database db, var sql) async {
    await db.execute(sql);
    // print('Table $tbCart created');
  }

  static void insertProduct(Product product) async {
    final db = await openDb();
    db.insert(tbProduct, product.toMap());
    // print('inserted product');
  }

  static Future<void> insertCart(CartItem cartItem) async {
    final db = await openDb();
    await db.insert(tbCart, cartItem.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    // print('Inserted cart item');
  }

  static Future<List<Map<String, dynamic>>> fetchProducts() async {
    final db = await openDb();
    return db.query(tbProduct);
  }

  static Future<List<Map<String, dynamic>>> fetchCartItems() async {
    final db = await openDb();
    return db.query(tbCart);
  }

  //update product
  static void updateProduct(Product product) async {
    final db = await openDb();
    db.update(
      tbProduct,
      product.toMap(),
      where: '$prodCode = ?',
      whereArgs: [product.code],
    );
    // print('updated product');
  }

  // dbhelper.dart

  static Future<void> updateCartItem(CartItem cartItem) async {
    final db = await openDb();
    await db.update(
      tbCart,
      cartItem.toMap(),
      where: '$cartProdCode = ?',
      whereArgs: [cartItem.code],
    );
    // print('Updated cart item');
  }

  static void updateProductFavoriteStatus(
      String productCode, bool isFavorite) async {
    final db = await openDb();
    await db.update(
      tbProduct,
      {prodIsFavorite: isFavorite ? true : false},
      where: '$prodCode = ?',
      whereArgs: [productCode],
    );
    // print('Updated favorite status for product: $productCode');
  }

  static Future<int> countProducts() async {
    final db = await openDb();
    final result = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $tbProduct'));
    return result ?? 0;
  }

  static Future<void> deleteProduct(String code) async {
    final db = await openDb();

    // Delete from tbProduct
    await db.delete(
      tbProduct,
      where: '$prodCode = ?',
      whereArgs: [code],
    );

    // Delete from tbCart
    await db.delete(
      tbCart,
      where: '$cartProdCode = ?',
      whereArgs: [code],
    );

    // print('Deleted product and related entries from tbCart');
  }

  static Future<void> deleteCartItem(String code) async {
    final db = await openDb();
    await db.delete(
      tbCart,
      where: '$cartProdCode = ?',
      whereArgs: [code],
    );
    // print('Deleted cart item');
  }
}
