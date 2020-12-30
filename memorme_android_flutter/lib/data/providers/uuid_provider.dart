import 'package:uuid/uuid.dart';

class UuidProvider {
  var uuid = Uuid();

  static final UuidProvider _singleton = UuidProvider._internal();
  UuidProvider._internal();

  factory UuidProvider() {
    return _singleton;
  }
}
