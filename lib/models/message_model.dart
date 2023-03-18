import 'package:hive/hive.dart';

enum MessageType {
  fromAuthor,
  fromCorrespondent,
}

class MessageModel {
  MessageModel(this._message);

  final Map<String, dynamic> _message;

  String get value => _message['value'];

  DateTime get time => _message['time'].toDate();

  String get author => _message['author'];

  MessageType get type => _getMessageType();

  MessageType _getMessageType() {
    final username = Hive.box('session').get('username');

    return username == author
        ? MessageType.fromAuthor
        : MessageType.fromCorrespondent;
  }
}
