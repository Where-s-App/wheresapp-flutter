import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wheresapp/models/public_keys_model.dart';
import 'package:wheresapp/security/key_generator.dart';

class ChatController {
  static Stream<QuerySnapshot> getChats(String username) {
    final chats = FirebaseFirestore.instance
        .collection('chats')
        .where('users', arrayContains: username)
        .snapshots();

    return chats;
  }

  static Future<Map<String, dynamic>?> getChatWithId(String chatId) async {
    final chatReference =
        FirebaseFirestore.instance.collection('chats').doc(chatId);

    Map<String, dynamic>? chatData;

    await chatReference.get().then((chat) {
      chatData = chat.data();
    });

    return chatData;
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

        KeyGenerator.generateSecret(chatId, authorPublicKeys);

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
      final docs = keys.docs.forEach((element) {
        final author = element.data()['author'];

        if (author != null) {
          authorPublicKeys = PublicKeysModel.fromJson(author);
        }
      });
    });

    return authorPublicKeys;
  }

  static Future<PublicKeysModel> getCorrespondentKeys(String chatId) async {
    final correspondentPublicKeysReference = FirebaseFirestore.instance
        .collection('public-keys')
        .where('chatId', isEqualTo: chatId);

    late PublicKeysModel correspondentPublicKeys;

    await correspondentPublicKeysReference.get().then((keys) {
      keys.docs.forEach((key) {
        if (key.data()['correspondent'] != null) {
          correspondentPublicKeys =
              PublicKeysModel.fromJson(key.data()['correspondent']);
        }
      });
    });

    return correspondentPublicKeys;
  }

  static Future<bool> isAuthor(String chatId, String username) async {
    final chatPublicKeys = FirebaseFirestore.instance
        .collection('public-keys')
        .where('chatId', isEqualTo: chatId)
        .where('username', isEqualTo: username);

    late bool isAuthor;

    await chatPublicKeys.get().then((keys) {
      isAuthor = keys.docs.any((chat) => chat['author'] != null);
    });

    return isAuthor;
  }

  static Future<bool> isChatValidated(String chatId) async {
    final publicKeys = FirebaseFirestore.instance
        .collection('public-keys')
        .where('chatId', isEqualTo: chatId);

    late bool valid;

    await publicKeys.get().then((keys) {
      if (keys.size == 2) {
        valid = true;
      } else {
        valid = false;
      }
    });

    return valid;
  }

  static Future<void> sendMessage(
      String chatId, String username, String message) {
    final chat = FirebaseFirestore.instance.collection('chats').doc(chatId);

    return chat.update({
      'messages': FieldValue.arrayUnion([
        {
          'author': username,
          'value': message,
          'time': DateTime.now(),
        }
      ])
    });
  }

  static Future<void> createChat(String username, String correspondent) async {
    final chat = FirebaseFirestore.instance.collection('chats').doc();

    late bool isValidCorrespondent;

    await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: correspondent)
        .get()
        .then((data) => isValidCorrespondent =
            data.docs.first.data()['username'] != null &&
                username != correspondent);

    if (!isValidCorrespondent) {
      return Future.error('Correspondent does not exist');
    }

    PublicKeysModel publicKeys = KeyGenerator.generateAuthorPublicKeys(chat.id);

    return chat.set({
      'author': username,
      'correspondent': correspondent,
      'users': [username, correspondent],
      'messages': []
    }).whenComplete(() {
      sendAuthorKeys(chat.id, username, publicKeys);
    });
  }

  static Future<void> createChatWithId(
      String chatId, String username, String otherUsername) {
    final chat = FirebaseFirestore.instance.collection('chats').doc(chatId);

    return chat.set({
      'users': [username, otherUsername],
      'messages': [
        {
          'user': username,
          'value': 'Hello!',
          'createdAt': DateTime.now(),
        }
      ]
    });
  }

  static Future<void> deleteChat(String chatId) {
    final chat = FirebaseFirestore.instance.collection('chats').doc(chatId);

    return chat.delete();
  }

  static Future<void> updateChat(
      String chatId, String username, String message) {
    final chat = FirebaseFirestore.instance.collection('chats').doc(chatId);

    return chat.update({
      'messages': FieldValue.arrayUnion([
        {
          'user': username,
          'value': message,
          'createdAt': DateTime.now(),
        }
      ])
    });
  }

  static Future<void> updateChatWithId(
      String chatId, String username, String message) {
    final chat = FirebaseFirestore.instance.collection('chats').doc(chatId);

    return chat.update({
      'messages': FieldValue.arrayUnion([
        {
          'user': username,
          'value': message,
          'createdAt': DateTime.now(),
        }
      ])
    });
  }
}
