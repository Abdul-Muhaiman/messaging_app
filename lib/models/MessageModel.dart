import 'dart:convert';

/// messageID : ""
/// sender : ""
/// text : ""
/// seen : true
/// createdon : 12

MessageModel messageModelFromJson(String str) =>
    MessageModel.fromJson(json.decode(str));

String messageModelToJson(MessageModel data) => json.encode(data.toJson());

class MessageModel {
  MessageModel({
    String? messageID,
    String? sender,
    String? text,
    bool? seen,
    dynamic createdon,
  }) {
    _messageID = messageID;
    _sender = sender;
    _text = text;
    _seen = seen;
    _createdon = createdon;
  }

  MessageModel.fromJson(dynamic json) {
    _messageID = json['messageID'];
    _sender = json['sender'];
    _text = json['text'];
    _seen = json['seen'];
    _createdon = json['createdon'];
  }

  String? _messageID;
  String? _sender;
  String? _text;
  bool? _seen;
  dynamic _createdon;

  MessageModel copyWith({
    String? messageID,
    String? sender,
    String? text,
    bool? seen,
    dynamic createdon,
  }) =>
      MessageModel(
        messageID: messageID ?? _messageID,
        sender: sender ?? _sender,
        text: text ?? _text,
        seen: seen ?? _seen,
        createdon: createdon ?? _createdon,
      );

  String? get messageID => _messageID;

  String? get sender => _sender;

  String? get text => _text;

  bool? get seen => _seen;

  dynamic get createdon => _createdon;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['messageID'] = _messageID;
    map['sender'] = _sender;
    map['text'] = _text;
    map['seen'] = _seen;
    map['createdon'] = _createdon;
    return map;
  }
}
