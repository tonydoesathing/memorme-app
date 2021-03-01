
import 'package:flutter_test/flutter_test.dart';
import 'package:memorme_android_flutter/data/models/sql_constants.dart';
import 'package:memorme_android_flutter/data/providers/database_provider.dart';
import 'package:sqflite/sqflite.dart';

main() {

  DBProvider dbProvider;
  Database db;
  group("Database manager test", () {

    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      dbProvider = DBProvider();
    });

    test("Did database initialize", () {
      db = dbProvider.getDatabase();
    });
  });
}