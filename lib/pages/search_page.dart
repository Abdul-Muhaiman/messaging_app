// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messaging_app/main.dart';
import 'package:messaging_app/models/ChatRoomModel.dart';

import '../models/UserModel.dart';
import 'chat_room_page.dart';

class SearchPage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const SearchPage(
      {Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();

  Future<ChatRoomModel?> getChatRoomModel(UserModel targetUser) async {
    ChatRoomModel? chatRoom;
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('chatrooms')
        .where('participants.${widget.userModel.uid}', isEqualTo: true)
        .where('participants.${targetUser.uid}', isEqualTo: true)
        .get();

    if (snapshot.docs.isNotEmpty) {
      //Get the chat room if it exists
      debugPrint('Chat room available');
      var docData = snapshot.docs[0].data();
      ChatRoomModel existingChatRoom =
          ChatRoomModel.fromJson(docData as Map<String, dynamic>);
      chatRoom = existingChatRoom;
    } else {
      //Create new chat room if it doesn't exist'
      debugPrint('No chat room available');
      ChatRoomModel newChatRoom = ChatRoomModel(
        chatroomID: uuid.v1().toString(),
        lastMessage: LastMessage(message: '', senderID: ''),
        participants: {
          widget.userModel.uid.toString(): true,
          targetUser.uid.toString(): true
        },
        createdOn: DateTime.now(),
        users: [widget.userModel.uid.toString(), targetUser.uid.toString()],
      );
      await FirebaseFirestore.instance
          .collection('chatrooms')
          .doc(newChatRoom.chatroomID)
          .set(newChatRoom.toJson());

      chatRoom = newChatRoom;

      debugPrint('New chat room created');
    }
    return chatRoom;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            child: TextFormField(
              controller: searchController,
              decoration: const InputDecoration(labelText: "Email address"),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          CupertinoButton(
            color: Theme.of(context).colorScheme.secondary,
            onPressed: () {
              setState(() {});
            },
            child: const Text('Search'),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where('email', isEqualTo: searchController.text)
                    .where('email', isNotEqualTo: widget.userModel.email)
                    .snapshots(),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      QuerySnapshot snapshotData =
                          snapshot.data as QuerySnapshot;
                      if (snapshot.data!.docs.isNotEmpty) {
                        Map<String, dynamic> userMap =
                            snapshotData.docs[0].data() as Map<String, dynamic>;
                        UserModel searchUser = UserModel.fromJson(userMap);
                        return Column(
                          children: [
                            ListTile(
                              onTap: () async {
                                ChatRoomModel? chatRoomModel =
                                    await getChatRoomModel(searchUser);
                                if (chatRoomModel != null) {
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChatRoomPage(
                                        userModel: widget.userModel,
                                        firebaseUser: widget.firebaseUser,
                                        targetUser: searchUser,
                                        chatRoom: chatRoomModel,
                                      ),
                                    ),
                                  );
                                }
                              },
                              title: Text(searchUser.fullname!),
                              subtitle: Text(searchUser.email!),
                              leading: CircleAvatar(
                                radius: 25,
                                backgroundImage:
                                    searchUser.profilepic!.isNotEmpty
                                        ? NetworkImage(
                                            searchUser.profilepic.toString())
                                        : null,
                                child: searchUser.profilepic!.isEmpty
                                    ? const Icon(Icons.person, size: 30)
                                    : null,
                              ),
                              trailing: const Icon(Icons.keyboard_arrow_right,
                                  size: 30),
                            ),
                          ],
                        );
                      } else {
                        return const Center(child: Text('No result found'));
                      }
                    } else if (snapshot.hasError) {
                      return const Center(child: Text('Error occurred'));
                    } else {
                      return const Center(child: Text("No data found"));
                    }
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                }),
          )
        ],
      ),
    );
  }
}
