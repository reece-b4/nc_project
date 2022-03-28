import "package:flutter/material.dart";

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  double? _deviceHeight;
  double? _deviceWidth;

  final GlobalKey<FormState> _loginFormKey =
      GlobalKey<FormState>();

  String? _email;
  String? _password;

  @override
  Widget build(BuildContext context) {
    _deviceHeight =
        MediaQuery.of(context).size.height;
    _deviceWidth =
        MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Color(0xfffcaf0f8),
                    Color(0xfff90e0ef),
                  ],
                  begin: Alignment.center,
                  stops: [0.1, 1000],
                  end: Alignment.bottomCenter)),
          padding: const EdgeInsets.fromLTRB(
              20, 0, 20, 0),
          child: Center(
              child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment:
                  CrossAxisAlignment.center,
              children: [
                // _titleWidget(),
                _logoWidget(),
                _loginForm(),
                _loginButton(),
                _registerPageLink(),
              ],
            ),
          )),
        ),
      ),
    );
  }

  Widget _logoWidget() {
    return Container(
      margin:
          const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: SizedBox(
          height: _deviceHeight! * 0.5,
          child: Image.asset(
            'ptp_logocardsglow.png',
            fit: BoxFit.cover,
          )),
    );
  }

  Widget _loginForm() {
    return Padding(
      padding:
          const EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: SizedBox(
        height: _deviceHeight! * 0.22,
        child: Form(
          key: _loginFormKey,
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment:
                CrossAxisAlignment.center,
            children: [
              _emailTextField(),
              _passwordTextField(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emailTextField() {
    return TextFormField(
      decoration: const InputDecoration(
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.grey, width: 0.0),
          ),
          hintText: "Email..."),
      onSaved: (_value) {
        setState(() {
          _email = _value;
        });
      },
      validator: (_value) {
        bool _result = _value!.contains(
          RegExp(
              r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"),
        );
        return _result
            ? null
            : "Please enter a valid email";
      },
    );
  }

  Widget _passwordTextField() {
    return TextFormField(
      obscureText: true,
      decoration: const InputDecoration(
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.grey, width: 0.0),
          ),
          hintText: "Password..."),
      onSaved: (_value) {
        setState(() {
          _password = _value;
        });
      },
      validator: (_value) => _value!.length > 6
          ? null
          : "Please enter a password greater than 6 characters.",
    );
  }

  Widget _loginButton() {
    return Container(
      margin: const EdgeInsets.only(
          top: 10.0, bottom: 5),
      child: MaterialButton(
        onPressed: _loginUser,
        minWidth: _deviceWidth! * 0.30,
        height: _deviceHeight! * 0.05,
        color: Colors.red,
        child: const Text(
          "Login",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _loginUser() {
    if (_loginFormKey.currentState!.validate()) {
      _loginFormKey.currentState!.save();
      Navigator.pushNamed(context, 'nav');
      // if (_result) Navigator.popAndPushNamed(context, 'nav');
    }
  }

  Widget _registerPageLink() {
    return GestureDetector(
      // onTap: () => Navigator.pushNamed(context, 'register'),
      child: const Text(
        "Don't have an account?",
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
