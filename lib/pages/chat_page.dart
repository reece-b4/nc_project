import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nc_project/pages/widgets/conversations_list.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  int _selectedIndex = 1;
  final List<String> _pages = <String>["home", "chat", "profile"];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.popAndPushNamed(context, _pages[_selectedIndex]);
  }

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  List _conversations = [];

  @override
  void initState() {
    super.initState();
    getConversations();
  }

  void getConversations() async {
    var doc = await _db.collection("users").doc(auth.currentUser!.uid).get();
    List dbConvos = await doc.get("conversations");
    var convertedConvos = dbConvos.map((convo) async {
      List chatees = [auth.currentUser!.uid, convo["userId"]];
      chatees.sort((a, b) {
        return a.compareTo(b);
      });
      String convId = chatees.join("");
      DocumentSnapshot convInfo =
          await _db.collection("conversations").doc(convId).get();
      Map convData = convInfo.data() as Map;
      return {
        "userId": convo["userId"],
        "name": convo["name"],
        "img": convo["img"],
        "lastMessage": convData["lastMessage"],
        "time": convData["time"],
      };
    }).toList();
    var awaitedConvos = await Future.wait(convertedConvos);
    awaitedConvos
        .sort(((b, a) => a["time"].toString().compareTo(b["time"].toString())));
    setState(() {
      _conversations = awaitedConvos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 83, 167, 245),
        centerTitle: true,
        title: Image.asset('ptp_logolong.png', height: 40, fit: BoxFit.cover),
      ),
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
              ListView.builder(
                itemCount: _conversations.length,
                shrinkWrap: true,
                padding: const EdgeInsets.only(top: 16),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return ConversationList(
                    userId: _conversations[index]["userId"],
                    name: _conversations[index]["name"],
                    imageUrl: _conversations[index]["img"],
                    messageText: _conversations[index]["lastMessage"],
                    time: _conversations[index]["time"],
                    isMessageRead: (index == 0 || index == 3) ? true : false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.question_answer_outlined),
            label: 'Chat',
            backgroundColor: Colors.purple,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.face),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 83, 167, 245),
        onTap: _onItemTapped,
      ),
    );
  }
}
