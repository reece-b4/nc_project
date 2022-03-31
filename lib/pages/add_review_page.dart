import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nc_project/pages/profile_page.dart';

class AddReviewPage extends StatefulWidget {
  final String? _profileOwner;
  const AddReviewPage(this._profileOwner, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AddReviewState();
  }
}

class _AddReviewState extends State<AddReviewPage> {
  final _addReviewStateKey = GlobalKey<FormState>();
  double? _deviceHeight;
  double? _deviceWidth;
  String? _review;

  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add a Review"),
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
                  _addReviewForm(),
                  const SizedBox(
                    height: 20,
                  ),
                  _addReviewButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _addReviewForm() {
    return SizedBox(
      height: _deviceHeight! * 0.75,
      child: Form(
        key: _addReviewStateKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _reviewTextField(),
          ],
        ),
      ),
    );
  }

  Widget _reviewTextField() {
    return TextFormField(
      maxLines: 5,
      decoration: const InputDecoration(hintText: "Write a review?"),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (_value) => _value!.length > 20 && _value.length < 300
          ? null
          : "Must be greater than 20 and less than 300 characters ",
      onChanged: (_value) {
        setState(() {
          _review = _value;
        });
      },
    );
  }

  Widget _addReviewButton() {
    String? _profileOwner = widget._profileOwner;
    return SizedBox(
      width: _deviceWidth! * 0.5,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          textStyle: const TextStyle(fontSize: 18),
        ),
        onPressed: () {
          if (_addReviewStateKey.currentState!.validate()) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Adding Review...')),
            );
            addReview(
              _profileOwner,
              _review,
            );
          }
        },
        child: const Text("Add Review"),
      ),
    );
  }

  addReview(
    _profileOwner,
    _review,
  ) async {
    final uid = auth.currentUser!.uid;
    await http.post(
      Uri.parse(
          'https://nc-project-api.herokuapp.com/api/users/$_profileOwner/reviews'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "reviewerId": uid,
        "content": _review,
      }),
    );
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return ProfilePage(
          _profileOwner,
        );
      }),
    );
  }
}
