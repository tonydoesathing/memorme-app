import 'package:memorme_android_flutter/data/models/sql_constants.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// Provides access to the app's SQLite database
///
/// Handles:
/// * opening
/// * closing
/// * datebase initialization
/// * database updating
class DBProvider {
  // Singleton
  static final DBProvider _dbProvider = new DBProvider._privateConstructor();
  Database _db;
  OpenDatabaseOptions options;

  /// Returns the single [_dbProvider], which provides access to the database
  factory DBProvider() {
    return _dbProvider;
  }

  /// make single instance of database
  DBProvider._privateConstructor() {
    options = OpenDatabaseOptions(
      version: 1,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        await db.execute("CREATE TABLE $story_table ("
            "$row_id INTEGER PRIMARY KEY,"
            "$memory_fk INTEGER NOT NULL,"
            "$date_created INTEGER,"
            "$date_last_edited INTEGER,"
            "$row_data TEXT,"
            "$row_type INTEGER,"
            "$story_position INTEGER,"
            "FOREIGN KEY ($memory_fk) REFERENCES $memory_table ($row_id) ON DELETE CASCADE ON UPDATE CASCADE"
            ")");
        await db.execute("CREATE TABLE $memory_table ("
            "$row_id INTEGER PRIMARY KEY,"
            "$row_title TEXT,"
            "$preview_story_id INTEGER,"
            "$date_created INTEGER,"
            "$date_last_edited INTEGER,"
            "$location INTEGER"
            //"FOREIGN KEY ($preview_story_fk) REFERENCES $story_table ($id)"
            ")");
        await db.execute("CREATE TABLE $collection_table ("
            "$row_id INTEGER PRIMARY KEY,"
            "$preview_data TEXT,"
            "$row_type INTEGER,"
            "$row_title TEXT,"
            "$date_created INTEGER,"
            "$date_last_edited INTEGER"
            ")");
        await db.execute("CREATE TABLE $memory_collection_relationship_table ("
            "$row_id INTEGER PRIMARY KEY,"
            "$memory_fk INTEGER NOT NULL,"
            "$collection_fk INTEGER NOT NULL,"
            "$row_data TEXT,"
            "$date_created INTEGER,"
            "$date_last_edited INTEGER,"
            "FOREIGN KEY ($memory_fk) REFERENCES $memory_table ($row_id),"
            "FOREIGN KEY ($collection_fk) REFERENCES $collection_table ($row_id)"
            ")");
      },
    );
  }

  /// Returns the [_db] if loaded and loads it otherwise from an optional [pathToDb]
  ///
  /// Note: when loading another database, the previous one needs to be closed first.
  Future<Database> getDatabase({String pathToDb}) async {
    // if the db is already loaded, just return it
    if (_db != null) {
      return _db;
    }
    // otherwise open it
    String directory = await getDatabasesPath();
    String dbPath = join(directory, "MemorMe.db");
    _db = await databaseFactory.openDatabase(pathToDb ?? dbPath,
        options: options);
    return _db;
  }

  /// closes the [_db] if open and makes it null
  Future<Database> closeDatabase() async {
    if (_db != null) {
      await _db.close();
    }
    _db = null;
    return _db;
  }
}
