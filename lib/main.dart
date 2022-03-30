import 'package:flutter/material.dart';
import 'package:nc_project/pages/add_pet_page.dart';
import 'package:nc_project/pages/add_review_page.dart';
// import 'package:nc_project/pages/loading_page.dart';
import 'package:nc_project/pages/login_page.dart';
import 'package:nc_project/pages/nav_home_page.dart';
import 'package:nc_project/pages/profile_page.dart';
import 'package:nc_project/pages/register_page.dart';
import 'package:nc_project/pages/chat_page.dart';
import "package:firebase_core/firebase_core.dart";
import "package:get_it/get_it.dart";
import 'package:nc_project/services/firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  GetIt.instance.registerSingleton<FirebaseService>(
    FirebaseService(),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Part-Time Pets',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: "login",
      routes: {
      
        // "/": (context) => LoadingPage(),
        "nav": (context) => const NavHomePage(),
        "register": (context) => const RegisterPage(),
        "login": (context) => const LoginPage(),
        "addpet": (context) => const AddPetPage(),
        "chat": (context) => const ChatPage(),
        "profile": (context) => const ProfilePage(null),
        "addreview": (context) => const AddReviewPage(null),
      },
    );
  }
}
