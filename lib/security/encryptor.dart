import 'package:encryptor/encryptor.dart';
import 'package:wheresapp/data/database.dart';

class MessageEncryptor {
  MessageEncryptor({required this.chatId});

  final String chatId;

  String get key => Database(chatId: chatId).key;

  String encrypt(String message) {
    String encryptedMessage = Encryptor.encrypt(key, message);

    return encryptedMessage;
  }

  String decrypt(String message) {
    late String decryptedMessage;

    try {
      if (key == '') {
        throw ArgumentError('No key was found');
      }
      decryptedMessage = Encryptor.decrypt(key, message);
    } catch (e) {
      decryptedMessage = message;
    }

    return decryptedMessage;
  }
}
