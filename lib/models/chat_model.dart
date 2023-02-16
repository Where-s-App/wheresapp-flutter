import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wheresapp/models/message_model.dart';

class ChatModel {
  ChatModel(QuerySnapshot<Object?> snapshot, int index,
      {required this.author}) {
    _document = snapshot.docs[index];
  }

  late final QueryDocumentSnapshot<Object?> _document;

  String author;

  String get id => _document.id;

  String get correspondent =>
      _document['users'].singleWhere((user) => user != author);

  late final List<dynamic> _messages = _document['messages'];

  List<MessageModel> get messages => _getMessages();

  List<MessageModel> _getMessages() {
    List<MessageModel> messages = [];

    for (var message in _messages) {
      messages.add(MessageModel(message, author));
    }

    return messages;
  }

  DateTime get time =>
      messages.isNotEmpty ? messages.last.time : DateTime.now();
}
