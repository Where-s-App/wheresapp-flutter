import 'package:wheresapp/widgets/message.dart';

class MessageModel {
  MessageModel(this._message, this._username);

  final Map<String, dynamic> _message;
  final String _username;

  String get value => _message['value'];

  DateTime get time => _message['time'].toDate();

  String get author => _message['author'];

  MessageType get type => author == _username
      ? MessageType.fromAuthor
      : MessageType.fromCorrespondent;
}
