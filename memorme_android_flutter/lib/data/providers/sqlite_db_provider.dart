import 'dart:io';

import 'package:memorme_android_flutter/data/models/memories/memory.dart';
import 'package:memorme_android_flutter/data/models/stories/story.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

/// Provides access to an SQLite database and sets it up
///
/// To load the MemorMe db, use the factory constructor ```SQLiteDBProvider.memorMeSQLiteDBProvider()```
class SQLiteDBProvider {
  final String path;
  final OpenDatabaseOptions dbOptions;
  Database _database;

  /// Provides an SQLite database from an optional [path] with optional opening [dbOptions]
  SQLiteDBProvider({this.path, this.dbOptions});

  /// Constructor for a MemorMe SQLite database, with the proper [OpenDatabaseOptions]
  ///
  /// Takes a [path] to the database
  ///
  /// ## Version 1 schema:
  /// ### Memories table
  /// memory_id INTEGER PRIMARY KEY
  /// date_created INTEGER
  /// date_last_edited INTEGER
  /// story_preview_id INTEGER
  ///
  /// ### Stories table
  /// story_id INTEGER PRIMARY KEY
  /// memory_id INTEGER NOT NULL FOREIGN KEY (memory_id) REFERENCES Memories (memory_id)
  /// date_created INTEGER NOT NULL
  /// date_last_edited INTEGER NOT NULL
  /// data TEXT
  /// type INTEGER
  ///
  factory SQLiteDBProvider.memorMeSQLiteDBProvider({String path}) {
    OpenDatabaseOptions options = OpenDatabaseOptions(
      version: 1,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        //create Memories table
        await db.execute("CREATE TABLE $memoriesTable ("
            "$memoryIdColumn INTEGER PRIMARY KEY,"
            "$memoryDateCreatedColumn INTEGER NOT NULL,"
            "$memoryDateLastEditedColumn INTEGER NOT NULL,"
            "$memoryStoryPreviewIdColumn INTEGER NOT NULL"
            ")");
        await db.execute("CREATE TABLE $storiesTable ("
            "$storyIdColumn INTEGER PRIMARY KEY,"
            "$memoryIdColumn INTEGER NOT NULL,"
            "$storyDateCreatedColumn INTEGER NOT NULL,"
            "$storyDatedLastEditedColumn INTEGER NOT NULL,"
            "$storyDataColumn TEXT,"
            "$storyTypeColumn INTEGER NOT NULL,"
            "FOREIGN KEY ($memoryIdColumn) REFERENCES $memoriesTable ($memoryIdColumn) ON DELETE CASCADE ON UPDATE CASCADE"
            ")");
      },
    );
    return SQLiteDBProvider(path: path, dbOptions: options);
  }

  /// if [_database] isn't null, return it
  /// otherwise, initialize it
  Future<Database> getDatabase() async {
    return _database ??= await _initDB();
  }

  Future<Database> closeDatabase() async {
    if (_database != null) {
      await _database.close();
    }
    _database = null;
    return _database;
  }

  /// Initialize the database
  Future<Database> _initDB() async {
    // if the path is null, set it to the default path
    String dbPath = path;
    if (path == null) {
      String directory = await getDatabasesPath();
      dbPath = join(directory, "MemorMe.db");
    }
    final db = await databaseFactory.openDatabase(dbPath, options: dbOptions);
    return db;
  }
}
