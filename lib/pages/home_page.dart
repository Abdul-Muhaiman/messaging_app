import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messaging_app/models/ChatRoomModel.dart';
import 'package:messaging_app/models/FirebaseHelper.dart';
import 'package:messaging_app/pages/chat_room_page.dart';
import 'package:messaging_app/pages/login_page.dart';

import '../models/UserModel.dart';
import 'search_page.dart';

class HomeScreen extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const HomeScreen(
      {Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messaging App'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return LoginPage();
                  },
                ),
              );
            },
            icon: const Icon(Icons.exit_to_app),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('chatrooms')
                    .where('users', arrayContains: '${widget.userModel.uid}')
                    .orderBy('createdOn')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          ChatRoomModel chatRoomModel = ChatRoomModel.fromJson(
                              snapshot.data!.docs[index].data()
                                  as Map<String, dynamic>);
                          Map<String, dynamic> participants =
                              chatRoomModel.participants!;
                          List<String> participantKeys =
                              participants.keys.toList();
                          participantKeys.remove(widget.userModel.uid);
                          return FutureBuilder(
                            future:
                                FirebaseHelper.getUserById(participantKeys[0]),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                if (snapshot.hasData) {
                                  return ListTile(
                                    onTap: () {
                                      FirebaseFirestore.instance
                                          .collection('chatrooms')
                                          .doc(chatRoomModel.chatroomID
                                              .toString())
                                          .update({
                                        "presentUsers": {
                                          widget.userModel.uid.toString(): true
                                        }
                                      });
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ChatRoomPage(
                                            userModel: widget.userModel,
                                            firebaseUser: widget.firebaseUser,
                                            targetUser: snapshot.data,
                                            chatRoom: chatRoomModel,
                                          ),
                                        ),
                                      );
                                    },
                                    leading: CircleAvatar(
                                      radius: 25,
                                      backgroundImage:
                                          snapshot.data.profilepic!.isNotEmpty
                                              ? NetworkImage(snapshot
                                                  .data.profilepic
                                                  .toString())
                                              : null,
                                      child: snapshot.data.profilepic!.isEmpty
                                          ? const Icon(Icons.person, size: 30)
                                          : null,
                                    ),
                                    title: Text(
                                      snapshot.data.fullname.toString(),
                                    ),
                                    subtitle: Row(
                                      children: <Widget>[
                                        chatRoomModel.lastMessage!.senderID ==
                                                widget.userModel.uid
                                            ? const Icon(
                                                Icons.check,
                                                size: 18,
                                              )
                                            : Container(),
                                        chatRoomModel.lastMessage!.senderID ==
                                                widget.userModel.uid
                                            ? Text(
                                                '\t${chatRoomModel.lastMessage!.message}')
                                            : Text(
                                                '${chatRoomModel.lastMessage!.message}'),
                                      ],
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              } else {
                                return Container();
                              }
                            },
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
                        child: Text('Find new friends'),
                      );
                    }
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchPage(
                  userModel: widget.userModel,
                  firebaseUser: widget.firebaseUser),
            ),
          );
        },
        child: const Icon(Icons.search),
      ),
    );
  }
}
