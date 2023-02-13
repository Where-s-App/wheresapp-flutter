import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:wheresapp/models/user_model.dart';

class UserController {
  static void createUser(String username, String password) {
    final users = FirebaseFirestore.instance.collection('users');

    final passwordToBytes = utf8.encode(password);

    final passwordHash = sha256.convert(passwordToBytes).toString();

    users.where('username', isEqualTo: username).get().then((value) {
      if (value.docs.isEmpty) {
        users.add({
          'username': username,
          'password': passwordHash,
        });
      } else {
        throw Exception('Username already exists');
      }
    });
  }

  static Future<UserModel> getUserByUsername(String username) async {
    final userData = FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .limit(1)
        .snapshots();

    late UserModel user;
    await userData.first.then((data) {
      user = UserModel(
          username: data.docs[0]['username'],
          password: data.docs[0]['password']);
    });

    return user;
  }
}
