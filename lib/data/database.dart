import 'package:encryptor/encryptor.dart';
import 'package:hive/hive.dart';

class Database {
  Database({this.chatId});

  String? chatId;

  Box sessionBox = Hive.box('session');

  String get username => sessionBox.get('username', defaultValue: 'default');

  set username(String username) => sessionBox.put('username', username);

  Box keyBox = Hive.box('keys');

  int get privateNumber => _getEncryptedPrivateNumber();

  int _getEncryptedPrivateNumber() {
    String encryptedPrivateNumber =
        keyBox.get('$username-$chatId-privateNumber', defaultValue: '');

    if (encryptedPrivateNumber == '') return -1;

    String decryptedPrivateNumber =
        Encryptor.decrypt(username, encryptedPrivateNumber);

    int parsedPrivateNumber = int.parse(decryptedPrivateNumber, radix: 16);

    return parsedPrivateNumber;
  }

  set privateNumber(int number) => keyBox.put('$username-$chatId-privateNumber',
      Encryptor.encrypt(username, number.toRadixString(16)));

  String get key => _getEncryptedKey();

  String _getEncryptedKey() {
    String encryptedKey = keyBox.get('$username-$chatId-key', defaultValue: '');

    if (encryptedKey == '') return '';
    String decriptedKey = Encryptor.decrypt(username, encryptedKey);

    return decriptedKey;
  }

  set key(String key) =>
      keyBox.put('$username-$chatId-key', Encryptor.encrypt(username, key));

  void deleteCredentials() {
    sessionBox.delete('username');
  }
}
