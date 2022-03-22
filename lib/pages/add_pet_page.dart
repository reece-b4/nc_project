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
                  _addPetForm(),
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
          ],
        ),
      ),
    );
  }

  Widget _nameTextField() {
    return TextFormField(
        decoration: const InputDecoration(hintText: "Whats your pets name?"),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (_value) =>
            _value!.length > 1 ? null : "Must be greater than 1 charachter",
        onSaved: (_value) {
          setState(() {
            _name = _value;
          });
        });
  }

  Widget _ageTextField() {
    return TextField(
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      decoration: InputDecoration(
        hintText: 'Please enter your pets age',
      ),
    );
  }
}
