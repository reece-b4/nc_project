import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _registerFormKey = GlobalKey<FormState>();

  double? _deviceHeight;
  double? _deviceWidth;
  String? _username;
  String? _email;
  String? _password;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registration Page"),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: _deviceWidth! * 0.1,
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  _registerForm(),
                  _registerButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _registerForm() {
    return SizedBox(
      height: _deviceHeight! * 0.75,
      child: Form(
        key: _registerFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _usernameTextField(),
            _emailTextField(),
            _passwordTextField(),
            _passwordConfirmTextField(),
          ],
        ),
      ),
    );
  }

  Widget _emailTextField() {
    return TextFormField(
        decoration: const InputDecoration(hintText: "Email..."),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (_value) {
          bool _result = _value!.contains(
            RegExp(
                r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"),
          );
          return _result ? null : "Please enter a valid email";
        },
        onSaved: (_value) {
          setState(() {
            _email = _value;
          });
        });
  }

  Widget _usernameTextField() {
    return TextFormField(
        decoration: const InputDecoration(hintText: "Username..."),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (_value) =>
            _value!.length > 5 ? null : "Must be greater than 5 characters",
        onSaved: (_value) {
          setState(() {
            _username = _value;
          });
        });
  }

  Widget _passwordTextField() {
    return TextFormField(
      obscureText: true,
      decoration: const InputDecoration(hintText: "Password..."),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (_value) => _value!.length > 6
          ? null
          : "Please enter a password greater than 6 characters",
      onChanged: (_value) {
        setState(() {
          _password = _value;
        });
      },
    );
  }

  Widget _passwordConfirmTextField() {
    return TextFormField(
      obscureText: true,
      decoration: const InputDecoration(hintText: "Confirm Password..."),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (_value) =>
          _value! == _password ? null : "Passwords do not match",
    );
  }

  Widget _registerButton() {
    return SizedBox(
      width: _deviceWidth! * 0.5,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          textStyle: const TextStyle(fontSize: 18),
        ),
        onPressed: () {
          if (_registerFormKey.currentState!.validate()) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Registration in progress...')),
            );
          }
        },
        child: const Text("Register"),
      ),
    );
  }
}
