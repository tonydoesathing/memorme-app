import 'dart:io';

import 'package:memorme_android_flutter/data/providers/uuid_provider.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid_util.dart';

class FileProvider {
  UuidProvider _uuidProvider = UuidProvider();
  static final FileProvider _singleton = FileProvider._internal();
  FileProvider._internal();

  RegExp regex = RegExp(
      "^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}");

  factory FileProvider() {
    return _singleton;
  }

  /// Takes a [path] to a file and makes it a MemorMe media, renaming it with
  /// a [Uuid] if it doesn't have one and storing it in the app's Data folder
  Future<String> mediaToDocumentsDirectory(String path) async {
    String fileName = basenameWithoutExtension(path);
    // check to see if Uuid
    if (!regex.hasMatch(fileName)) {
      // make a Uuid for the media
      fileName = _uuidProvider.uuid.v4(options: {'rng': UuidUtil.cryptoRNG});
    }
    // get the documents directory
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    // make the nested subdirectory path
    String p = join(documentsDirectory.path, fileName.substring(0, 2),
        fileName.substring(2, 4), fileName.substring(4, 6));
    // create the nested directory if does not exist
    documentsDirectory = await Directory(p).create(recursive: true);
    // make the file path
    p = join(p, fileName + extension(path));

    //check to see if we have collisions
    for (int i = 0;
        i < 5 && FileSystemEntity.typeSync(p) != FileSystemEntityType.notFound;
        i++) {
      //we do; this is like a 1 in a billion trillion or something stupid
      // just try it again a couple times
      // generate uuid
      fileName = _uuidProvider.uuid.v4(options: {'rng': UuidUtil.cryptoRNG});
      //get documents directory
      documentsDirectory = await getApplicationDocumentsDirectory();
      // make nested directory path
      p = join(documentsDirectory.path, fileName.substring(0, 2),
          fileName.substring(2, 4), fileName.substring(4, 6));
      // create the nested directory if does not exist
      documentsDirectory = await Directory(p).create(recursive: true);
      // make the file path
      p = join(p, fileName + extension(path));
      if (i == 4) {
        // 4 times and still a collision?? there's something fucked up
        throw ("Uuid keeps colliding");
      }
    }

    // move media to Documents location
    File oldMedia = File(path);
    await oldMedia.copy(p);
    await oldMedia.delete();

    return p;
  }

  /// Creates a Uuid, checks to see that it's free in the temp media, and
  /// returns a [path] to a free media uuid
  Future<String> makeTempMediaPath(String fileEnding) async {
    //create the Uuid
    String fileName =
        _uuidProvider.uuid.v4(options: {'rng': UuidUtil.cryptoRNG});
    // get the temp directory
    Directory temp = await getTemporaryDirectory();
    // make the nested subdirectory path
    String path = join(temp.path, fileName.substring(0, 2),
        fileName.substring(2, 4), fileName.substring(4, 6));
    // create the nested directory if does not exist
    temp = await Directory(path).create(recursive: true);
    // make the file path
    path = join(path, fileName + fileEnding);
    //check to see if we have collisions
    if (FileSystemEntity.typeSync(path) != FileSystemEntityType.notFound) {
      //we do; this is like a 1 in a billion trillion or something stupid
      // just try it again
      return await makeTempMediaPath(fileEnding);
    }
    return path;
  }
}
