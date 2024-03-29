import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wheresapp/data/database.dart';

import '../models/public_keys_model.dart';
import '../security/key_generator.dart';

class KeyController {
  static Future<void> sendAuthorKeys(
      String chatId, String username, PublicKeysModel publicKeys) async {
    final publicKeysReference =
        FirebaseFirestore.instance.collection('public-keys').doc();

    publicKeysReference.set({
      'chatId': chatId,
      'username': username,
      'author': {
        'generator': publicKeys.generator,
        'prime': publicKeys.prime,
        'result': publicKeys.result,
      },
    });
  }

  static Future<PublicKeysModel> getAuthorKeys(String chatId) async {
    final authorPublicKeysReference = FirebaseFirestore.instance
        .collection('public-keys')
        .where('chatId', isEqualTo: chatId);

    late PublicKeysModel authorPublicKeys;

    await authorPublicKeysReference.get().then((keys) {
      for (var element in keys.docs) {
        final author = element.data()['author'];

        if (author != null) {
          authorPublicKeys = PublicKeysModel.fromJson(author);
        }
      }
    });

    return authorPublicKeys;
  }

  static Future<PublicKeysModel> getCorrespondentKeys(String chatId) async {
    final correspondentPublicKeysReference = FirebaseFirestore.instance
        .collection('public-keys')
        .where('chatId', isEqualTo: chatId);

    late PublicKeysModel correspondentPublicKeys;

    await correspondentPublicKeysReference.get().then((keys) {
      for (var key in keys.docs) {
        if (key.data()['correspondent'] != null) {
          correspondentPublicKeys =
              PublicKeysModel.fromJson(key.data()['correspondent']);
        }
      }
    });

    return correspondentPublicKeys;
  }

  static Future<void> sendCorrespondentKeys(
      String chatId, String username) async {
    final chatPublicKeys = FirebaseFirestore.instance
        .collection('public-keys')
        .where('chatId', isEqualTo: chatId);

    await chatPublicKeys.get().then((keys) async {
      bool hasOnlyAuthor = keys.size == 1;

      if (hasOnlyAuthor) {
        final publicKeyReference =
            FirebaseFirestore.instance.collection('public-keys');

        PublicKeysModel authorPublicKeys = await getAuthorKeys(chatId);

        PublicKeysModel publicKeys =
            KeyGenerator.generateCorrespondentPublicKeys(
                chatId, authorPublicKeys);

        KeyGenerator.generateSecret(
            chatId, authorPublicKeys, Database(chatId: chatId).privateNumber);

        publicKeyReference.add({
          "username": username,
          "correspondent": {
            "generator": publicKeys.generator,
            "prime": publicKeys.prime,
            "result": publicKeys.result,
          },
          "chatId": chatId
        });
      }
    });
  }
}
