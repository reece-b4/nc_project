import 'package:flutter/material.dart';

// import 'package:nc_project/pages/home_page.dart';
// import 'package:nc_project/pages/loading_page.dart';
import 'package:nc_project/pages/login_page.dart';
import 'package:nc_project/pages/profile_page.dart';
// import 'package:nc_project/pages/register_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Partial Pets',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      initialRoute: "profile",
      routes: {
        // "/": (context) => LoadingPage(),
        // "register": (context) => RegisterPage(),
        "login": (context) => LoginPage(),
        // "home": (context) => HomePage(),
        "profile": (context) => ProfilePage(),
      },
    );
  }
}
