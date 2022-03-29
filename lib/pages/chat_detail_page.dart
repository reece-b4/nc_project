import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nc_project/pages/models/chat_message_mode.dart';

class ChatDetailPage extends StatefulWidget {
  final String name;
  final String otherUser;

  const ChatDetailPage({Key? key, required this.name, required this.otherUser})
      : super(key: key);

  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final myController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String _conversationId = '';
  List _messages = [];
  Stream<DocumentSnapshot>? _messageStream;

  @override
  void initState() {
    super.initState();
    subToStream(widget.otherUser);
    getInitialMessages();
  }

  void subToStream(otherUserId) async {
    try {
      List chattees = [auth.currentUser!.uid, otherUserId];
      chattees.sort((a, b) {
        return a.compareTo(b);
      });
      _conversationId = chattees.join('');
      final bool _conversationExists = await checkConversationExists();
      if (!_conversationExists) {
        createConversation();
      }
      _messageStream = FirebaseFirestore.instance
          .collection('conversations')
          .doc(_conversationId)
          .snapshots();
    } catch (error) {
      print(error);
    }
  }

  Future<bool> checkConversationExists() async {
    final doc = await FirebaseFirestore.instance
        .collection('conversations')
        .doc(_conversationId)
        .get();
    return doc.exists;
  }

  void createConversation() async {
    await FirebaseFirestore.instance
        .collection('conversations')
        .doc(_conversationId)
        .set({"messages": []});
  }

  List convertMessages(List messages) {
    return messages
        .map((message) {
          String type = (message["written_by"] == widget.otherUser)
              ? "receiver"
              : "sender";
          return ChatMessage(
              messageContent: message["message_content"], messageType: type);
        })
        .toList()
        .reversed
        .toList();
  }

  void getInitialMessages() async {
    try {
      var doc =
          await _db.collection("conversations").doc(_conversationId).get();
      if (doc.exists) {
        setState(() {
          _messages = convertMessages(doc.get("messages"));
        });
      }
    } catch (error) {
      print(error);
    }
  }

  void sendMessage(ChatMessage message) async {
    String content = message.messageContent;
    String writtenBy = message.messageType == "sender"
        ? auth.currentUser!.uid
        : widget.otherUser;
    try {
      await _db.collection("conversations").doc(_conversationId).update({
        "messages": FieldValue.arrayUnion([
          {"written_by": writtenBy, "message_content": content}
        ])
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  width: 2,
                ),
                const CircleAvatar(
                  backgroundImage: NetworkImage("https://i.pravatar.cc/300"),
                  maxRadius: 20,
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        widget.name,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(
                        "Online",
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.settings,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          StreamBuilder(
              stream: _messageStream,
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasData) {
                  _messages = convertMessages(snapshot.data!.get("messages"));
                }
                return ListView.builder(
                  reverse: true,
                  itemCount: _messages.length,
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(top: 10, bottom: 100),
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.only(
                          left: 14, right: 14, top: 10, bottom: 10),
                      child: Align(
                        alignment: (_messages[index].messageType == "receiver"
                            ? Alignment.topLeft
                            : Alignment.topRight),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: (_messages[index].messageType == "receiver"
                                ? Colors.grey[300]
                                : Colors.blue[100]),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            _messages[index].messageContent,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextField(
                      controller: myController,
                      decoration: const InputDecoration(
                        hintText: "Write message...",
                        hintStyle: TextStyle(color: Colors.black54),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      if (myController.text != '') {
                        setState(() {
                          sendMessage(
                            ChatMessage(
                              messageContent: myController.text,
                              messageType: "sender",
                            ),
                          );
                          myController.text = '';
                        });
                      }
                    },
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                    backgroundColor: const Color.fromARGB(255, 119, 55, 192),
                    elevation: 0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
