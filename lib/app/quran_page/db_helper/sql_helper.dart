import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE bookmarks(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        ayah_id TEXT,
        suraId TEXT,
        verseId TEXT,
        ayahText TEXT,
        ayahTextKhmer TEXT,
        ayahNormal TEXT,
        surahName TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }

// id: the id of a item
// title, description: name and description of your activity
// created_at: the time that the item was created. It will be automatically handled by SQLite

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'quran.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Create new item (journal)
  static Future<int> createItem(String ayah_id,
  String suraId,
  String verseId,
  String ayahText,
  String ayahTextKhmer,
  String ayahNormal,
  String surahName) async {
    final db = await SQLHelper.db();

    final data = {
       'ayah_id':ayah_id,
       'suraId':suraId,
       'verseId':verseId,
       'ayahText':ayahText,
       'ayahTextKhmer':ayahTextKhmer,
       'ayahNormal':ayahNormal,
       'surahName':surahName
    };
    final id = await db.insert('bookmarks', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }
  // Read all items (journals)
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();
    print(db.query('bookmarks', orderBy: "id"));
    return db.query('bookmarks', orderBy: "id DESC");
  }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getItem(String id) async {
    final db = await SQLHelper.db();
    return db.query('bookmarks', where: "ayah_id = ?", whereArgs: [id], limit: 1);
  }

  // Update an item by id
  static Future<int> updateItem(
      int id,
      String ayah_id,
      String suraId,
      String verseId,
      String ayahText,
      String ayahTextKhmer,
      String ayahNormal,
      String surahName) async {
    final db = await SQLHelper.db();

    final data = {
      'ayah_id':ayah_id,
      'suraId':suraId,
      'verseId':verseId,
      'ayahText':ayahText,
      'ayahTextKhmer':ayahTextKhmer,
      'ayahNormal':ayahNormal,
      'surahName':surahName,
      'createdAt': DateTime.now().toString()
    };

    final result =
    await db.update('bookmarks', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  static Future<void> deleteItem(String id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("bookmarks", where: "ayah_id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}