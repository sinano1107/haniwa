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
  final file = File(join(documentDirectory.path, 'image.JPG'));
  file.writeAsBytesSync(response.bodyBytes);
  print(file.uri);
  await FirebaseStorage.instance
      .ref('users/${user.uid}/icon.JPG')
      .putFile(file);
}
