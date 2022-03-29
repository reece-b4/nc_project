import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import "dart:io";
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as p;
import 'package:cloud_firestore/cloud_firestore.dart';

class AddPetPage extends StatefulWidget {
  const AddPetPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AddPetState();
  }
}

class _AddPetState extends State<AddPetPage> {
  final _addPetStateKey = GlobalKey<FormState>();
  double? _deviceHeight;
  double? _deviceWidth;
  String? _name;
  String? _age;
  String? _breed;
  String? _notes;
  File? image;
  String? _species;

  final FirebaseAuth auth = FirebaseAuth.instance;

  Future pickImageFromGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image == null) return;

      final imageTemp = File(image.path);

      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print("Failed to pick image: $e");
    }
  }

  Future pickImageFromCamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);

      if (image == null) return;

      final imageTemp = File(image.path);

      setState(() => this.image = imageTemp);
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
        title: const Text("Add a Pet"),
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
                  _addPetForm(),
                  _pictureButtons(),
                  const SizedBox(
                    height: 20,
                  ),
                  image != null
                      ? Image.file(image!)
                      : const Text("No image selected"),
                  _addPetButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _addPetForm() {
    return SizedBox(
      height: _deviceHeight! * 0.75,
      child: Form(
        key: _addPetStateKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _nameTextField(),
            _ageTextField(),
            _speciesTextField(),
            _breedTextField(),
            _notesTextField(),
          ],
        ),
      ),
    );
  }

  Widget _nameTextField() {
    return TextFormField(
      decoration: const InputDecoration(hintText: "Whats your pet's name?"),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (_value) =>
          _value!.length > 1 ? null : "Must be greater than 1 character",
      onChanged: (_value) {
        setState(() {
          _name = _value;
        });
      },
    );
  }

  Widget _ageTextField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (_value) =>
          _value!.isNotEmpty ? null : "Must be greater than 0",
      onChanged: (_value) {
        setState(() {
          _age = _value;
        });
      },
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      decoration: const InputDecoration(
        hintText: "Please enter your pet's age",
      ),
    );
  }

  Widget _speciesTextField() {
    return TextFormField(
      decoration: const InputDecoration(hintText: "What species is your pet?"),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (_value) =>
          _value!.length > 2 ? null : "Must be greater than 2 characters",
      onChanged: (_value) {
        setState(() {
          _species = _value;
        });
      },
    );
  }

  Widget _breedTextField() {
    return TextFormField(
      decoration: const InputDecoration(
          hintText: "If applicable, what breed is your pet?"),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: (_value) {
        setState(() {
          _breed = _value;
        });
      },
    );
  }

  Widget _notesTextField() {
    return TextFormField(
      decoration:
          const InputDecoration(hintText: "Please add short description"),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (_value) =>
          _value!.length > 20 ? null : "Must be greater than 20 characters",
      onChanged: (_value) {
        setState(
          () {
            _notes = _value;
          },
        );
      },
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

  Widget _addPetButton() {
    return SizedBox(
      width: _deviceWidth! * 0.5,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          textStyle: const TextStyle(fontSize: 18),
        ),
        onPressed: () {
          if (_addPetStateKey.currentState!.validate()) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Adding pet...')),
            );
            addPet(
              _name,
              _notes,
              _age,
              _species,
              _breed,
            );
          }
        },
        child: const Text("Add Pet"),
      ),
    );
  }

  void addPet(
    _name,
    _notes,
    _age,
    _species,
    _breed,
  ) async {
    final uid = auth.currentUser!.uid;
    _age = int.parse(_age);
    String _fileName = Timestamp.now().millisecondsSinceEpoch.toString() +
        p.extension(image!.path);

    UploadTask _task =
        FirebaseStorage.instance.ref("images/$uid/$_fileName").putFile(image!);

    return _task.then((_snapshot) async {
      String _downloadURL = await _snapshot.ref.getDownloadURL();

      await http.post(
        Uri.parse('https://nc-project-api.herokuapp.com/api/users/$uid/pets'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "petName": _name!,
          "availability": true,
          "notes": _notes!,
          "petAge": _age!,
          "petImg": _downloadURL,
          "species": _species!,
          "breed": _breed,
        }),
      );
    });
  }
}
