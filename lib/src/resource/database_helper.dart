import 'package:medeasy/src/model/notification_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final String _databaseName = 'medeasy.db';
  static final String _tableName = 'notifications';
  static final int _databaseVersion = 2;

  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  static Database _database;

  Future<Database> get database async {
    if (_database == null) _database = await _initDatabase();
    return _database;
  }

  Future _initDatabase() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, _databaseName);
    return openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    ).then((Database db) => db).catchError((error) {
      print('DATABASE_HELPER_EXCEPTION: Failed to open database.');
      print(error);
      throw DatabaseHelperException(
        'DATABASE_HELPER_EXCEPTION: Failed to open database.',
      );
    });
  }

  Future _onCreate(Database db, int version) async {
    try {
      await db.execute('''
        CREATE TABLE $_tableName (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          dateTime INTEGER NOT NULL,
          title TEXT NOT NULL,
          body TEXT NOT NULL,
          type INTEGER NOT NULL
        )
      ''');
    } catch (error) {
      print('DATABASE_HELPER_EXCEPTION: Failed to create table.');
      print(error);
      throw DatabaseHelperException(
          'DATABASE_HELPER_EXCEPTION: Failed to create table.');
    }
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (newVersion > oldVersion) {
      print("Upgrading database");
      try {
        db.delete(_tableName);
      } catch (e) {
        print("Failed to delete old data in database");
      }
    }
  }

  Future<int> insert(NotificationModel notification) async {
    Database db = await instance.database;
    return await db.insert(_tableName, {
      'body': notification.body,
      'title': notification.title,
      'dateTime': notification.dateTime,
      'type': notification.type,
    }).catchError((error) {
      print('DATABASE_HELPER_EXCEPTION: Failed to insert into table.');
      print(error);
      throw DatabaseHelperException(
          'DATABASE_HELPER_EXCEPTION: Failed to insert into table.');
    });
  }

  Future<List<NotificationModel>> queryAllRows(int type) async {
    Database db = await instance.database;
    return await db.query(_tableName).then((rows){
      List<NotificationModel> res = [];
      rows.forEach((row) {
        if(row['type'] == type){
          res.add(NotificationModel.fromMap(row));
        }
      });
      return res;
    }).catchError((error) {
      print('DATABASE_HELPER_EXCEPTION: Failed to fetch from table.');
      print(error);
      throw DatabaseHelperException(
          'DATABASE_HELPER_EXCEPTION: Failed to fetch from table.');
    });
  }

  Future<int> deleteTable() async {
    Database db = await instance.database;
    return db.delete(_tableName).catchError((error) {
      print('DATABASE_HELPER_EXCEPTION: Failed to delete table.');
      print(error);
      throw DatabaseHelperException(
          'DATABASE_HELPER_EXCEPTION: Failed to delete table.');
    });
  }

  Future<int> deleteNotification(int id) async {
    Database db = await instance.database;
    return db.delete(_tableName, where: 'id = $id').catchError((error) {
      print('DATABASE_HELPER_EXCEPTION: Failed to delete Notification.');
      print(error);
      throw DatabaseHelperException(
          'DATABASE_HELPER_EXCEPTION: Failed to delete Notification.');
    });
  }
}

class DatabaseHelperException implements Exception {
  String cause;
  DatabaseHelperException(this.cause);
}
