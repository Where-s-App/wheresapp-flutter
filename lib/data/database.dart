import 'package:hive/hive.dart';

class Database {
  Database({this.chatId});

  String? chatId;

  Box sessionBox = Hive.box('session');

  String get username => sessionBox.get('username', defaultValue: 'default');

  set username(String username) => sessionBox.put('username', username);

  Box keyBox = Hive.box('keys');

  int get privateNumber =>
      keyBox.get('$username-$chatId-privateNumber', defaultValue: -1);

  set privateNumber(int number) =>
      keyBox.put('$username-$chatId-privateNumber', number);

  String get key => keyBox.get('$username-$chatId-key', defaultValue: '');

  set key(String key) => keyBox.put('$username-$chatId-key', key);

  void deleteCredentials() {
    sessionBox.delete('username');
  }
}
