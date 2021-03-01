import 'package:memorme_android_flutter/data/models/sql_constants.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  // Singleton
  static final DBProvider _dbProvider = new DBProvider._privateConstructor();
  Database _db;
  OpenDatabaseOptions options;

  factory DBProvider() {
    return _dbProvider;
  }

  // make single instance of database
  DBProvider._privateConstructor() {
    options = OpenDatabaseOptions(
      version: 1,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        await db.execute("CREATE TABLE $story_table ("
            "$id INTEGER PRIMARY KEY,"
            "$memory_fk INTEGER NOT NULL,"
            "$date_created INTEGER NOT NULL,"
            "$date_last_edited INTEGER NOT NULL,"
            "$data TEXT NOT NULL,"
            "$type INTEGER NOT NULL,"
            "$position INTEGER NOT NULL,"
            "FOREIGN KEY ($memory_fk) REFERENCES $memory_table ($id) ON DELETE CASCADE ON UPDATE CASCADE"
            ")");
        await db.execute("CREATE TABLE $memory_table ("
            "$id INTEGER PRIMARY KEY,"
            "$title TEXT,"
            //"$preview_story_fk INTEGER NOT NULL,"
            "$date_created INTEGER NOT NULL,"
            "$date_last_edited INTEGER NOT NULL,"
            "$location INTEGER"
            //"FOREIGN KEY ($preview_story_fk) REFERENCES $story_table ($id)"
            ")");
        await db.execute("CREATE TABLE $collection_table ("
            "$id INTEGER PRIMARY KEY,"
            "$preview_data TEXT NOT NULL,"
            "$type INTEGER NOT NULL,"
            "$title TEXT,"
            "$date_created INTEGER NOT NULL,"
            "$date_last_edited INTEGER NOT NULL"
            ")");
        await db.execute("CREATE TABLE $memory_collection_relationship_table ("
            "$id INTEGER PRIMARY KEY,"
            "$memory_fk INTEGER NOT NULL,"
            "$collection_fk INTEGER NOT NULL,"
            "$data TEXT,"
            "$date_created INTEGER NOT NULL,"
            "$date_last_edited INTEGER NOT NULL,"
            "FOREIGN KEY ($memory_fk) REFERENCES $memory_table ($id),"
            "FOREIGN KEY ($collection_fk) REFERENCES $collection_table ($id)"
            ")");
      },
    );
  }

  getDatabase() async {
    String directory = await getDatabasesPath();
    String dbPath = join(directory, "MemorMe.db");
    _db = await databaseFactory.openDatabase(dbPath, options: options);
    return _db;
  }
}
