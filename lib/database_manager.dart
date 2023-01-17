import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:async/async.dart';

class DataBaseManager {

  static final DataBaseManager _dataBaseManager = DataBaseManager._internal();

  DataBaseManager._internal();

  static DataBaseManager get instance => _dataBaseManager;

  static Database? _database;

  final _initDatabaseMemoizer = AsyncMemoizer<Database>();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabaseMemoizer.runOnce(() async {
      return await _initDatabase();
    });

    return _database!;
  }

  Future<Database> _initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'todo_database.db'),
      onCreate: (db, version) {
        return db.execute('CREATE TABLE todos(id INTEGER PRIMARY KEY, title TEXT, completed INTEGER)');
      },
      version: 1,
    );
  }
}