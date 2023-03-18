import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:wheresapp/models/message_model.dart';
import 'package:wheresapp/utils/string_extensions.dart';

class ChatModel {
  ChatModel(
    QuerySnapshot<Object?> snapshot,
    int index,
  ) {
    _document = snapshot.docs[index];
  }

  late final QueryDocumentSnapshot<Object?> _document;

  String get id => _document.id;

  List<String> get correspondents => _getCorrespondents();

  List<String> _getCorrespondents() {
    List<String> correspondents = [];
    String username = Hive.box('session').get('username');

    List<dynamic> users = _document['users'];

    for (var user in users) {
      if (user != username) {
        correspondents.add(user.toString().capitalize());
      }
    }
    return correspondents;
  }

  late final List<dynamic> _messages = _document['messages'];

  List<MessageModel> get messages => _getMessages();

  List<MessageModel> _getMessages() {
    List<MessageModel> messages = [];

    for (var message in _messages) {
      messages.add(MessageModel(message));
    }

    return messages;
  }

  DateTime get time =>
      messages.isNotEmpty ? messages.last.time : DateTime.now();
}
