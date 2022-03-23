import "package:flutter/material.dart";
import 'package:flutter/services.dart';

class AddPetPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddPetState();
  }
}

class _AddPetState extends State<AddPetPage> {
  final _AddPetStateKey = GlobalKey<FormState>();
  double? _deviceHeight;
  double? _deviceWidth;
  String? _name;

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
                  _addPictureButton(),
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
    return Container(
      height: _deviceHeight! * 0.75,
      child: Form(
        key: _AddPetStateKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _nameTextField(),
            _ageTextField(),
            _speciesTextField(),
            _breedTextField(),
            _descriptionTextField(),
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
        onSaved: (_value) {
          setState(() {
            _name = _value;
          });
        });
  }

  Widget _ageTextField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (_value) =>
          _value!.length > 0 ? null : "Must be greater than 0",
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
        decoration:
            const InputDecoration(hintText: "What species is your pet?"),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (_value) =>
            _value!.length > 2 ? null : "Must be greater than 2 characters",
        onSaved: (_value) {
          setState(() {
            _name = _value;
          });
        });
  }

  Widget _breedTextField() {
    return TextFormField(
        decoration: const InputDecoration(
            hintText: "If applicable, what breed is your pet?"),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onSaved: (_value) {
          setState(() {
            _name = _value;
          });
        });
  }

  Widget _descriptionTextField() {
    return TextFormField(
        decoration:
            const InputDecoration(hintText: "Please add short description"),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (_value) =>
            _value!.length > 20 ? null : "Must be greater than 20 characters",
        onSaved: (_value) {
          setState(() {
            _name = _value;
          });
        });
  }

  Widget _addPictureButton() {
    return SizedBox.fromSize(
      size: const Size(55, 55),
      child: ClipOval(
        child: Material(
          color: Colors.purple,
          child: InkWell(
            splashColor: Colors.green,
            onTap: () => {},
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.add_a_photo,
                  color: Colors.white,
                ), // <-- Icon
                Text("Add", style: TextStyle(color: Colors.white)), // <-- Text
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
        onPressed: () {},
        child: const Text("Add Pet"),
      ),
    );
  }
}
