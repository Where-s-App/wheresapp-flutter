import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wheresapp/api/user_controller.dart';
import 'package:wheresapp/providers/session_provider.dart';
import 'package:wheresapp/views/home_page.dart';

class Login extends ConsumerStatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<bool> handleLogin() async {
    late bool status;
    await UserController.getUserByUsername(_usernameController.text)
        .then((userData) {
      final passwordBytes = utf8.encode(_passwordController.text);
      final passwordHash = sha256.convert(passwordBytes).toString();

      if (userData.password == passwordHash) {
        status = true;
        ref.watch(SessionProvider.session).user = userData;
      } else {
        status = false;
      }
    });
    return status;
  }

  bool checkboxValue = false;

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Padding(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Login',
              style: Theme.of(context).textTheme.headline4,
            ),
            const SizedBox(height: 20),
            Form(
              child: Column(
                children: [
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                    ),
                  ),
                  TextFormField(
                    obscureText: true,
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  if (_usernameController.text.isNotEmpty &&
                      _passwordController.text.isNotEmpty) {
                    bool loginSuccessful = await handleLogin();

                    if (loginSuccessful) {
                      final cacheUsername = Hive.box('session').get('username');

                      if (cacheUsername == null ||
                          cacheUsername != _usernameController.text) {
                        Hive.box('session')
                            .put('username', _usernameController.text);
                      }

                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => HomePage()));
                    }
                  }
                },
                child: const Text('Login')),
          ],
        ),
      ),
    ));
  }
}
