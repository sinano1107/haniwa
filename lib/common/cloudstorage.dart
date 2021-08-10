import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

Future addMyImage() async {
  final user = FirebaseAuth.instance.currentUser;
  final response = await http.get(Uri.parse(user.photoURL));
  final documentDirectory = await getApplicationDocumentsDirectory();
  final file = File(join(documentDirectory.path, 'image.png'));
  file.writeAsBytesSync(response.bodyBytes);
  final metaData = SettableMetadata(
    cacheControl: 'max-age=600',
    contentType: 'image/png',
  );
  await FirebaseStorage.instance
      .ref('versions/v1/users/${user.uid}/icon.png')
      .putFile(file, metaData);
}
