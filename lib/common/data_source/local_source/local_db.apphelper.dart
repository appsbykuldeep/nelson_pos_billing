part of 'local_db.dart';

Future<void> onDBCreate(sqflite.Database db) async {
  await _runCreateTable(db, ItemInfo.dbTable);
}
