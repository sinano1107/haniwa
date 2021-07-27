import 'package:flutter/material.dart';
import 'package:haniwa/models/user.dart';

class UserProvider extends ChangeNotifier {
  User _user = User(
    groupId: null,
  );
  User get user => _user;
  void setUser(User value) => _user = value;
}
