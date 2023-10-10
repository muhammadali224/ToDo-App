import 'package:sqflite/sqflite.dart';

import '../models/task.dart';

class DBHelper {
  static Database? _db;
  static const int _version = 1;
  static const String _tableName = 'tasks';

  static Future<void> intitDb() async {
    if (_db != null) {
      return;
    } else {
      try {
        // Get a location using getDatabasesPath
        String path = '${await getDatabasesPath()}tasks.db';
        // open the database
        _db = await openDatabase(
          path,
          version: _version,
          onCreate: (Database db, int version) async {
            // When creating the db, create the table
            await db.execute(
              //create all field for table
              'CREATE TABLE $_tableName ('
                  'id INTEGER PRIMARY KEY AUTOINCREMENT, '
                  'title STRING,'
                  'note TEXT,'
                  'date STRING,'
                  'startTime STRING,'
                  'endTime STRING,'
                  'remind INTEGER,'
                  'repeat STRING,'
                  'color INTEGER,'
                  'isComplete INTEGER'
                  ')',
            );
          },
        );
      } catch (e) {
        // catch the error
      }
    }
  }

// insert data to table
  static Future<int> insert(Task? task) async {
    return await _db!.insert(_tableName, task!.toJson());
  }

// delete data from table where id is equal id
  static Future<int> delete(Task task) async {
    return await _db!.delete(_tableName, where: 'id=?', whereArgs: [task.id,],);
  }

  static Future<int> deleteAll() async {
    return await _db!.delete(_tableName);
  }

// return query of data from table
  static Future<List<Map<String, dynamic>>> query() async {
    return await _db!.query(_tableName);
  }

// update isComplete from unique id
  static Future<int> update(int id) async {
    return await _db!.rawUpdate('''
    UPDATE tasks
    SET isComplete=?
    WHERE id=?
    ''', [1, id]);
  }
}
