import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wheresapp/models/user_model.dart';

import '../models/session_model.dart';

class SessionProvider {
  static final session = StateProvider((ref) {
    return SessionModel(
        isLogged: false, user: UserModel(username: '', password: ''));
  });
}
