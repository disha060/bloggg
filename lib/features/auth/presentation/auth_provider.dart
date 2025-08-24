import 'package:flutter/material.dart';
import 'package:bloggg/core/usecase/usecase.dart';
import 'package:bloggg/features/auth/domain/usecases/current_user.dart';
import 'package:bloggg/features/auth/domain/usecases/user_login.dart';
import 'package:bloggg/features/auth/domain/usecases/user_sign_up.dart';
import '../../../core/common/provider/app_user/app_user_provider.dart';

class AuthProvider extends ChangeNotifier {
  final UserSignUp _userSignUp;
  final UserLogin _userLogin;
  final CurrentUser _currentUser;
  final AppUserProvider _appUserProvider;

  AuthProvider({
    required UserSignUp userSignUp,
    required UserLogin userLogin,
    required CurrentUser currentUser,
    required AppUserProvider appUserProvider,
  })  : _userSignUp = userSignUp,
        _userLogin = userLogin,
        _currentUser = currentUser,
        _appUserProvider = appUserProvider;

  bool _isLoading = false;
  String? _errorMessage;
  bool _isLoggedIn = false;

  bool get isLoading => _isLoading;
  String? get error => _errorMessage;
  bool get isLoggedIn => _isLoggedIn;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void reset() {
    _isLoading = false;
    _errorMessage = null;
    _isLoggedIn = false;
    notifyListeners();
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    final res = await _userSignUp(UserSignUpParams(
      email: email,
      password: password,
      name: name,
    ));
    _setLoading(false);
    res.fold(
          (failure) {
        _isLoggedIn = false;
        _setError(failure.message);
      },
          (user) {
        _appUserProvider.updateUser(user);
        _isLoggedIn = true;
        _setError(null);
      },
    );
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    final res = await _userLogin(UserLoginParams(
      email: email,
      password: password,
    ));
    _setLoading(false);
    res.fold(
          (failure) {
        _isLoggedIn = false;
        _setError(failure.message);
      },
          (user) {
        _appUserProvider.updateUser(user);
        _isLoggedIn = true;
        _setError(null);
      },
    );
  }

  Future<void> checkCurrentUser() async {
    _setLoading(true);
    final res = await _currentUser(NoParams());
    _setLoading(false);
    res.fold(
          (failure) {
        _isLoggedIn = false;
        _setError(failure.message);
      },
          (user) {
        _appUserProvider.updateUser(user);
        _isLoggedIn = true;
        _setError(null);
      },
    );
  }
}
