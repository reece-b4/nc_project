import "package:flutter/material.dart";
import 'package:nc_project/pages/home_page.dart';
import 'package:nc_project/pages/chat_page.dart';
import 'package:nc_project/pages/profile_page.dart';

class NavHomePage extends StatefulWidget {
  const NavHomePage({Key? key}) : super(key: key);

  @override
  State<NavHomePage> createState() => _NavHomePageState();
}

class _NavHomePageState extends State<NavHomePage> {
  int _selectedIndex = 0;
  String _appBarName = "Home";

  final List<Widget> _pages = <Widget>[
    const HomePage(),
    const ChatPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (_selectedIndex) {
        case 0:
          _appBarName = "Home";
          break;
        case 1:
          _appBarName = "Conversations";
          break;
        case 2:
          _appBarName = "Profile";
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (_appBarName == "Home")
          ? AppBar(
              backgroundColor: const Color.fromARGB(255, 83, 167, 245),
              centerTitle: true,
              title: Image.asset('ptp_logolong.png',
                  height: 40, fit: BoxFit.cover),
            )
          : AppBar(
              backgroundColor: const Color.fromARGB(255, 83, 167, 245),
              centerTitle: true,
              title: Text(_appBarName),
            ),
      body: Center(
        child: _pages.elementAt(_selectedIndex),
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
