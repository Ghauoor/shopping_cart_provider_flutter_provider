import 'dart:io' as io;

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/cart_model.dart';

class DBHelper {
  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db!;
    }

    _db = await initDatabase();
    return _db!;
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'cart.db');

    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE cart (id INTEGER PRIMARY KEY , productId VARCHAR UNIQUE,productName TEXT,initialPrice INTEGER, productPrice INTEGER , quantity INTEGER, unitTag TEXT , image TEXT )',
    );
  }

  Future<CartModel> insert(CartModel cart) async {
    var dbClient = await db;
    await dbClient?.insert('cart', cart.toMap());
    return cart;
  }

  Future<List<CartModel>> getCartList() async {
    var dbClient = await db;
    final List<Map<String, Object?>> quryResult = await dbClient!.query('cart');
    return quryResult.map((e) => CartModel.fromMap(e)).toList();
  }
}
