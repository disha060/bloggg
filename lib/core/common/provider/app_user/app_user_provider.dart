import 'package:flutter/material.dart';
import '../../entities/user.dart';

class AppUserProvider extends ChangeNotifier {
  User? _user;

  User? get user => _user;

  bool get isLoggedIn => _user != null;

  void updateUser(User? newUser) {
    _user = newUser;
    notifyListeners();  // Notifies all widgets listening to this provider
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}
