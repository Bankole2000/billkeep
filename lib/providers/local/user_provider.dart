import 'package:billkeep/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CurrentUserProvider extends Notifier<UserModel?> {
  @override
  UserModel? build() {
    return null;
  }

  void setUser(UserModel user) {
    state = user;
  }

  void clearUser() {
    state = null;
  }
}

final currentUserProvider = NotifierProvider<CurrentUserProvider, UserModel?>(
  CurrentUserProvider.new,
);
