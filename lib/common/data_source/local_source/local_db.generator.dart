part of 'local_db.dart';

typedef DBColumnInfo<T> = (String name, Type, T? placeholder);

typedef DBTable<T> = (
  String table,
  Set<DBColumnInfo> dbColumns,
  String? primaryKey,
);

void _sqlLog(dynamic value) {
  dev.log("${DateTime.now()} $value");
}

Future<void> _runMigQuery(sqflite.Database database, String query) async {
  try {
    await database.execute(query);
  } catch (e) {
    _sqlLog(e);
    return;
  }
}

Future<List<Map<String, dynamic>>> runRawQueryUsingDB(
  sqflite.DatabaseExecutor? db,
  String query, [
  List<Object?>? arguments,
]) async {
  try {
    return (await db?.rawQuery(query, arguments)) ?? [];
  } catch (e) {
    _sqlLog(e);
    return [];
  }
}

Future<List<String>> _getTableColumnName(
  sqflite.Database db,
  String tableName,
) async {
  Set<String> tableColumns = <String>{};

  try {
    var result = await db.rawQuery("PRAGMA table_info('$tableName')");
    for (var column in result) {
      tableColumns.add((column['name'] as String).toLowerCase().trim());
    }
  } catch (e) {
    return [];
  }

  return tableColumns.toList();
}

Future<void> _runAddColumn(
  sqflite.Database database,
  String tableName,
  List<DBColumnInfo> columns,
) async {
  try {
    final preColums = await _getTableColumnName(database, tableName);
    for (var (columnName, type, placeholder) in columns) {
      if (preColums.contains(columnName.toLowerCase().trim())) {
        continue;
      }
      await _runMigQuery(
        database,
        "alter table `$tableName` add `$columnName` ${dartToDbTypeConverter(type, placeholder)}",
      );
    }
  } catch (e) {
    return;
  }
}

Future<void> _runCreateTable(
  sqflite.Database database,
  DBTable tableInfo,
) async {
  final (tableName, columns, primaryKey) = tableInfo;

  String query = "CREATE TABLE IF NOT EXISTS `$tableName` ";
  try {
    List<String> colQuery = [];

    for (var (columnName, type, placeholder) in columns) {
      colQuery.add(
        " `$columnName` ${dartToDbTypeConverter(type, placeholder)} ",
      );
    }
    if (primaryKey != null) {
      colQuery.add(" PRIMARY KEY (`$primaryKey`) ");
    }
    query = "$query (${colQuery.join(", ")} )";

    await database.execute(query);
  } catch (e) {
    _sqlLog(e);
    return;
  }
}

Future<void> onDBUpgrade(
  sqflite.Database db,
  int oldVersion,
  int newVersion,
) async {}

Future<bool> insertRecords<T>({
  required sqflite.Database db,
  required List<Map<String, Object?>> data,
  required String table,
}) async {
  if (data.isEmpty) {
    return false;
  }
  const batchSize = 2000;
  final dataLength = data.length;

  try {
    for (var i = 0; i < dataLength; i += batchSize) {
      final chunk = data.skip(i).take(batchSize);
      final batch = db.batch();
      for (final item in chunk) {
        batch.insert(
          table,
          item,
          conflictAlgorithm: sqflite.ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    }
  } catch (e) {
    _sqlLog(e);
    return false;
  }
  return true;
}

String dartToDbTypeConverter<T>(Type type, [T? placeholder]) {
  if (type is int? || type is bool?) {
    if (placeholder != null) {
      return "INTEGER NOT NULL DEFAULT $placeholder";
    }
    return "INTEGER";
  }
  if (type is double? || type is num?) {
    if (placeholder != null) {
      return "REAL NOT NULL DEFAULT $placeholder";
    }
    return "REAL";
  }

  if (placeholder != null) {
    return "Text not null DEFAULT '$placeholder'";
  }

  return "TEXT";
}
