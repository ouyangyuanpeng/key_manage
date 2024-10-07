import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class KeyModel {
  final int? id;
  final String domain;
  final String username;
  final String password;

  KeyModel(this.id,this.domain, this.username, this.password);

  factory KeyModel.fromJson(Map<String, dynamic> json) {
    return KeyModel(
      json['id'],
      json['domain'],
      json['username'],
      json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'domain': domain,
      'username': username,
      'password': password,
    };
  }

  @override
  String toString() {
    return 'KeyModel{id: $id, domain: $domain, username: $username, password: $password}';
  }
}

class KeyModelHelper {
  static final KeyModelHelper _instance = KeyModelHelper._internal();

  factory KeyModelHelper() => _instance;

  static Database? _database;

  KeyModelHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'key_model.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE keys(id INTEGER PRIMARY KEY AUTOINCREMENT, domain TEXT, username TEXT, password TEXT)',
        );
      },
    );
  }

  Future<void> insertKey(KeyModel key) async {
    final db = await database;
    await db.insert(
      'keys',
      key.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<KeyModel>> getKeys() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('keys');

    return List.generate(maps.length, (i) {
      return KeyModel(
        maps[i]['id'],
        maps[i]['domain'],
        maps[i]['username'],
        maps[i]['password'],
      );
    });
  }

  Future<void> removeKey(int id) async {
    final db = await database;
    await db.delete(
      'keys',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
