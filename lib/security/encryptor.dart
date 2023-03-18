import 'package:encryptor/encryptor.dart';
import 'package:hive/hive.dart';

class MessageEncryptor {
  MessageEncryptor({required this.chatId});

  final String chatId;

  String get key => Hive.box('keys').get('$chatId-secret').toString();

  String encrypt(String message) {
    String encryptedMessage = Encryptor.encrypt(key, message);

    return encryptedMessage;
  }

  String decrypt(String message) {
    String decryptedMessage = Encryptor.decrypt(key, message);

    return decryptedMessage;
  }
}
