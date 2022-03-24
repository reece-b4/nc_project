import 'package:flutter/material.dart';
import 'package:nc_project/pages/add_pet_page.dart';
// import 'package:nc_project/pages/loading_page.dart';
import 'package:nc_project/pages/login_page.dart';
import 'package:nc_project/pages/nav_home_page.dart';
import 'package:nc_project/pages/register_page.dart';

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
      initialRoute: "nav",
      routes: {
        // "/": (context) => LoadingPage(),
        "nav": (context) => const NavHomePage(),
        "register": (context) => const RegisterPage(),
        "login": (context) => const LoginPage(),
        "addpet": (context) => const AddPetPage(),
      },
    );
  }
}
