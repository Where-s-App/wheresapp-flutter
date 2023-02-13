import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wheresapp/api/firebase_options.dart';
import 'package:wheresapp/api/user_controller.dart';

void main() {
  test('Registers hashed username and password', () async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    UserController.createUser('natanael', 'natanael');
  });
}
