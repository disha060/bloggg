import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../entities/user.dart';

part 'app_user_state.dart';

class AppUserCubit extends Cubit<AppUserState> {
  AppUserCubit() : super(AppUserInitial());

  void updateUser(User? user) {
    if (user == null) {
      emit(AppUserInitial());  // When no user (logged out)
    } else {
      emit(AppUserLoggedIn(user));  // When user exists (logged in)
    }
  }
}
