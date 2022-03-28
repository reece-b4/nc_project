import 'package:flutter/material.dart';
import 'package:nc_project/pages/widgets/conversations_list.dart';

import 'models/chat_users_model.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<ChatUsers> chatUsers = [
    ChatUsers(
      userId: "JaneRussel",
      name: "Jane Russel",
      messageText: "Awesome Setup",
      imageURL: "https://i.pravatar.cc/300",
      time: "Now",
    ),
    ChatUsers(
      userId: "GladysMurphy",
      name: "Glady's Murphy",
      messageText: "That's Great",
      imageURL: "https://i.pravatar.cc/300",
      time: "Yesterday",
    ),
    ChatUsers(
      userId: "JorgeHenry",
      name: "Jorge Henry",
      messageText: "Hey where are you?",
      imageURL: "https://i.pravatar.cc/300",
      time: "31 Mar",
    ),
    ChatUsers(
      userId: "PhillipFox",
      name: "Philip Fox",
      messageText: "Busy! Call me in 20 mins",
      imageURL: "https://i.pravatar.cc/300",
      time: "28 Mar",
    ),
    ChatUsers(
      userId: "DebraHawkins",
      name: "Debra Hawkins",
      messageText: "Thankyou, It's awesome",
      imageURL: "https://i.pravatar.cc/300",
      time: "23 Mar",
    ),
  ];

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
              ListView.builder(
                itemCount: chatUsers.length,
                shrinkWrap: true,
                padding: const EdgeInsets.only(top: 16),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return ConversationList(
                    userId: chatUsers[index].userId,
                    name: chatUsers[index].name,
                    messageText: chatUsers[index].messageText,
                    imageUrl: chatUsers[index].imageURL,
                    time: chatUsers[index].time,
                    isMessageRead: (index == 0 || index == 3) ? true : false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
