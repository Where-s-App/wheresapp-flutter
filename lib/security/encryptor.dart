import 'package:encryptor/encryptor.dart';
import 'package:hive/hive.dart';

class MessageEncryptor {
  MessageEncryptor({required this.chatId});

  final String chatId;

  String get key => Hive.box('keys').get('$chatId-secret');

  String encrypt(String message) {
    String encryptedMessage = Encryptor.encrypt(key, message);

    return encryptedMessage;
  }

  String decrypt(String message) {
    late String decryptedMessage;

    try {
      final secret = Hive.box('keys').get('$chatId-secret');

      if (secret == null) {
        throw ArgumentError('Secret is null');
      }
      decryptedMessage = Encryptor.decrypt(secret, message);
    } catch (e) {
      decryptedMessage = message;
    }

    return decryptedMessage;
  }
}
