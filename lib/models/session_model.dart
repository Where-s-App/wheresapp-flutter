import 'package:wheresapp/models/user_model.dart';

class SessionModel {
  bool isLogged;
  UserModel user;

  SessionModel({required this.isLogged, required this.user});

  void login(UserModel user) {
    isLogged = true;
    this.user = user;
  }

  void logout() {
    isLogged = false;
    user = UserModel(username: '', password: '');
  }
}
