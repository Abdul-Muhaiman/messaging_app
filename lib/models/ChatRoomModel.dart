// // class ChatRoomModel {
// //   ChatRoomModel({
// //     required this.chatroomID,
// //     required this.participants,
// //     required this.lastMessage,
// //     required this.createdOn,
// //     required this.users,
// //   });
// //
// //   late final String chatroomID;
// //   dynamic participants;
// //   late final LastMessage lastMessage;
// //   late final String createdOn;
// //   late final List<dynamic> users;
// //
// //   ChatRoomModel.fromJson(Map<String, dynamic> json) {
// //     chatroomID = json['chatRoomID'];
// //     participants = participants.fromJson(json['participants']);
// //     lastMessage = LastMessage.fromJson(json['lastMessage']);
// //     createdOn = json['createdOn'];
// //     users = List.castFrom<dynamic, dynamic>(json['users']);
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     final _data = <String, dynamic>{};
// //     _data['chatRoomID'] = chatroomID;
// //     _data['participants'] = participants.toJson();
// //     _data['lastMessage'] = lastMessage.toJson();
// //     _data['createdOn'] = createdOn;
// //     _data['users'] = users;
// //     return _data;
// //   }
// // }
// //
// // // class Participants {
// // //   Participants({
// // //     required this.asdl;ad,
// // //     required this.akfhsal,
// // //   });
// // //   late final bool asdl;ad;
// // //   late final bool akfhsal;
// // //
// // //   Participants.fromJson(Map<String, dynamic> json){
// // //     asdl;ad = json['asdl;ad'];
// // //     akfhsal = json['akfhsal'];
// // //   }
// // //
// // //   Map<String, dynamic> toJson() {
// // //     final _data = <String, dynamic>{};
// // //     _data['asdl;ad'] = asdl;ad;
// // //     _data['akfhsal'] = akfhsal;
// // //     return _data;
// // //   }
// // // }
// //
// // class LastMessage {
// //   LastMessage({
// //     required this.message,
// //     required this.senderID,
// //   });
// //
// //   late final String message;
// //   late final String senderID;
// //
// //   LastMessage.fromJson(Map<String, dynamic> json) {
// //     message = json['message'];
// //     senderID = json['senderID'];
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     final _data = <String, dynamic>{};
// //     _data['message'] = message;
// //     _data['senderID'] = senderID;
// //     return _data;
// //   }
// // }
//
// class ChatRoomModel {
//   ChatRoomModel(
//       {this.chatroomID,
//       this.participants,
//       this.lastMessage,
//       this.createdOn,
//       this.users});
//
//   ChatRoomModel.fromJson(dynamic json) {
//     chatroomID = json['chatroomID'];
//     participants = json['participants'];
//     lastMessage = json['lastMessage'];
//     createdOn = json['createdOn'];
//     users = json['users'];
//   }
//
//   String? chatroomID;
//   dynamic participants;
//   Map<String, dynamic>? lastMessage;
//   dynamic createdOn;
//   List<dynamic>? users;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['chatroomID'] = chatroomID;
//     map['participants'] = participants;
//     map['lastMessage'] = lastMessage;
//     map['createdOn'] = createdOn;
//     map['users'] = users;
//     return map;
//   }
// }
//
// // {
// //   "chatRoomID": "",
// //   "participants": {
// //     "asdl;ad": true
// //     "akfhsal": true
// //   },
// //   "lastMessage": {
// //     "message": "asd",
// //     "senderID": "adsfgj",
// //   },
// //   "createdOn": "",
// //   "users": []
// // }



class ChatRoomModel {
  String? chatroomID;
  Map<String, bool>? participants;
  LastMessage? lastMessage;
  dynamic createdOn;
  List<String>? users;

  ChatRoomModel({
    this.chatroomID,
    this.participants,
    this.lastMessage,
    this.createdOn,
    this.users,
  });

  ChatRoomModel.fromJson(Map<String, dynamic> json) {
    chatroomID = json['chatRoomID'];
    participants = Map<String, bool>.from(json['participants'] ?? {});
    lastMessage = LastMessage.fromJson(json['lastMessage'] ?? {});
    createdOn = json['createdOn'];
    users = List<String>.from(json['users'] ?? []);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['chatRoomID'] = chatroomID;
    data['participants'] = participants;
    data['lastMessage'] = lastMessage?.toJson();
    data['createdOn'] = createdOn;
    data['users'] = users;
    return data;
  }
}

class LastMessage {
  String? message;
  String? senderID;

  LastMessage({
    this.message,
    this.senderID,
  });

  LastMessage.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    senderID = json['senderID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['senderID'] = senderID;
    return data;
  }
}
