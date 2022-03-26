import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import "dart:io";
import 'package:flutter/services.dart';
import 'package:nc_project/services/firebase_service.dart';

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
  File? imageProfile;
  FirebaseService? _firebaseService;
  Future pickImageFromGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image == null) return;

      final imageTemp = File(image.path);

      setState(() => imageProfile = imageTemp);
    } on PlatformException catch (e) {
      print("Failed to pick image: $e");
    }
  }

  Future pickImageFromCamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);

      if (image == null) return;

      final imageTemp = File(image.path);

      setState(() => imageProfile = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

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
                  _pictureButtons(),
                  const SizedBox(
                    height: 18,
                  ),
                  imageProfile != null
                      ? Image.file(
                          imageProfile!,
                          height: 200,
                          width: 200,
                        )
                      : const Text("No image selected"),
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

  Widget _addCameraPictureButton() {
    return SizedBox.fromSize(
      size: const Size(55, 55),
      child: ClipOval(
        child: Material(
          color: Colors.purple,
          child: InkWell(
            splashColor: Colors.green,
            onTap: () {
              pickImageFromCamera();
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.add_a_photo,
                  color: Colors.white,
                ), // <-- Icon
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _pictureButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: [
        _addCameraPictureButton(),
        _addGalleryPictureButton(),
      ],
    );
  }

  Widget _addGalleryPictureButton() {
    return SizedBox.fromSize(
      size: const Size(55, 55),
      child: ClipOval(
        child: Material(
          color: Colors.purple,
          child: InkWell(
            splashColor: Colors.green,
            onTap: () {
              pickImageFromGallery();
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.collections,
                  color: Colors.white,
                ), // <-- Icon <-- Text
              ],
            ),
          ),
        ),
      ),
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
          _registerUser;
        },
        child: const Text("Register"),
      ),
    );
  }

  void _registerUser() async {
    if (_registerFormKey.currentState!.validate() && imageProfile != null) {
      _registerFormKey.currentState!.save();
      // if (_result) Navigator.pop(context);
    }
    print("image");
    bool _result = await _firebaseService!.registerUser(
        username: _username!,
        email: _email!,
        password: _password!,
        image: imageProfile!);
    if (_result) Navigator.popAndPushNamed(context, 'login');
  }
}
