import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nc_project/pages/widgets/conversations_list.dart';

import 'models/chat_users_model.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  Stream<DocumentSnapshot>? _conversationStream;
  List _conversations = [];

  @override
  void initState() {
    super.initState();
    subToStream();
    getInitialConversations();
  }

  void subToStream() async {
    try {
      _conversationStream = FirebaseFirestore.instance
          .collection('users')
          .doc(auth.currentUser!.uid)
          .snapshots();
    } catch (error) {
      print(error);
    }
  }

  void getInitialConversations() async {
    try {
      var doc = await _db.collection("users").doc(auth.currentUser!.uid).get();
      List dbConvos = doc.get("conversations");
      List convertedConvos = dbConvos.map((convo) {
        return ChatUsers(
          userId: convo["userId"],
          name: convo["name"],
          time: convo["time"],
          imageURL: convo["img"],
          messageText: convo["lastMessage"],
        );
      }).toList();
      setState(() {
        _conversations = convertedConvos;
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search...",
                    hintStyle: TextStyle(color: Colors.grey.shade600),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey.shade600,
                      size: 20,
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.all(8),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.grey.shade100)),
                  ),
                ),
              ),
              StreamBuilder(
                  stream: _conversationStream,
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasData) {
                      _conversations = snapshot.data!.get("conversations");
                    }
                    return ListView.builder(
                      itemCount: _conversations.length,
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(top: 16),
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return ConversationList(
                          userId: _conversations[index]["userId"],
                          name: _conversations[index]["name"],
                          messageText: _conversations[index]["lastMessage"],
                          imageUrl: _conversations[index]["img"],
                          time: _conversations[index]["time"],
                          isMessageRead:
                              (index == 0 || index == 3) ? true : false,
                        );
                      },
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
