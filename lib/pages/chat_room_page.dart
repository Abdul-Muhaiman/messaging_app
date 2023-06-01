import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messaging_app/main.dart';
import 'package:messaging_app/models/MessageModel.dart';

import '../models/ChatRoomModel.dart';
import '../models/UserModel.dart';

class ChatRoomPage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  final UserModel targetUser;
  final ChatRoomModel chatRoom;

  const ChatRoomPage(
      {Key? key,
      required this.userModel,
      required this.firebaseUser,
      required this.targetUser,
      required this.chatRoom})
      : super(key: key);

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  TextEditingController messageController = TextEditingController();

  void sendMessage() {
    String message = messageController.text.trim();
    messageController.clear();

    if (message != '') {
      MessageModel messageModel = MessageModel(
        messageID: uuid.v1(),
        sender: widget.userModel.uid,
        text: message,
        createdon: DateTime.now(),
        seen: false,
      );
      FirebaseFirestore.instance
          .collection('chatrooms')
          .doc(widget.chatRoom.chatroomID)
          .collection('messages')
          .doc(messageModel.messageID)
          .set(messageModel.toJson());

      LastMessage lastMessage =
          LastMessage(message: message, senderID: widget.userModel.uid!);

      FirebaseFirestore.instance
          .collection('chatrooms')
          .doc(widget.chatRoom.chatroomID)
          .update(
        {'lastMessage': lastMessage.toJson()},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            FirebaseFirestore.instance
                .collection('chatrooms')
                .doc(widget.chatRoom.chatroomID.toString())
                .update(
              {
                "presentUsers": {widget.userModel.uid.toString(): false},
              },
            );
          },
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
        titleSpacing: 0,
        title: ListTile(
          leading: CircleAvatar(
            radius: 20,
            backgroundImage: widget.targetUser.profilepic!.isNotEmpty
                ? NetworkImage(widget.targetUser.profilepic.toString())
                : null,
            child: widget.targetUser.profilepic!.isEmpty
                ? const Icon(Icons.person, size: 30)
                : null,
          ),
          title: Text(
            widget.targetUser.fullname!,
            style: const TextStyle(fontSize: 18),
          ),
          subtitle: Text(
            widget.targetUser.email.toString(),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          //Chats
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('chatrooms')
                      .doc(widget.chatRoom.chatroomID)
                      .collection('messages')
                      .orderBy('createdon', descending: false)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            MessageModel message = MessageModel.fromJson(
                                snapshot.data!.docs[index].data());
                            return Row(
                              mainAxisAlignment:
                                  message.sender == widget.userModel.uid
                                      ? MainAxisAlignment.end
                                      : MainAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 3),
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Text(
                                    message.text.toString(),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return const Center(
                          child: Text(
                              'An error occurred! Check your internet connection'),
                        );
                      } else {
                        return const Center(
                          child: Text('Say hi to your friend'),
                        );
                      }
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
            ),
          ),
          //Message sending
          Container(
            color: Colors.grey.shade200,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Row(
              children: <Widget>[
                Flexible(
                  child: TextFormField(
                    controller: messageController,
                    maxLength: null,
                    decoration: const InputDecoration(
                        border: InputBorder.none, hintText: 'Enter a message'),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    sendMessage();
                  },
                  icon: const Icon(Icons.send),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
