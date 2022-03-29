import "package:flutter/material.dart";
import "package:flip_card/flip_card.dart";
import 'package:firebase_auth/firebase_auth.dart';
import "dart:convert";
import "package:http/http.dart" as http;

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ProfilePageState();
  }
}

class _ProfilePageState extends State<ProfilePage> {
  Map _userJson = {};
  String _username = "";
  String _postcode = "";
  String _img = "";
  List _pets = [];
  List _reviews = [];

  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  void fetchUser() async {
    try {
      final user = auth.currentUser;
      final uid = user!.uid;
      final response = await http.get(
          Uri.parse('https://nc-project-api.herokuapp.com/api/users/$uid'));
      final jsonData = jsonDecode(response.body) as Map;
      setState(() {
        _userJson = jsonData;

        _username = _userJson['user']['username'];
        _postcode = _userJson['user']['postcode'];
        _img = _userJson['user']['avatar'];
        _pets = _userJson['user']['pets'];
        _reviews = _userJson['user']['reviews'];
      });
    } catch (error) {
      print(error);
    }
  }

  double? _deviceHeight;
  double? _deviceWidth;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: const Color.fromARGB(255, 245, 245, 245),
          child: ListView(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _userCard(),
                    _myPetsTitle(),
                    _userPetsCard(),
                    _myReviewsTitle(),
                    _userReviewsCard(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _userCard() {
    return Container(
      margin: const EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        bottom: 20.0,
        top: 20.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [_userAvatar(), _userInfo()],
      ),
    );
  }

  Widget _userAvatar() {
    return Container(
      margin: EdgeInsets.only(
        bottom: _deviceHeight! * 0.02,
      ),
      height: _deviceHeight! * 0.20,
      width: _deviceHeight! * 0.20,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          100,
        ),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(_img),
        ),
      ),
    );
  }

  Widget _userInfo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          _username,
          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
        ),
        Text(_postcode,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600))
      ],
    );
  }

  Widget _userPetsCard() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: const Color.fromARGB(255, 70, 70, 70))),
      margin: const EdgeInsets.only(
        left: 10.0,
        right: 10.0,
        bottom: 20.0,
      ),
      height: _deviceHeight! * 0.4,
      padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: ListView.separated(
          itemCount: _pets.length,
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            return FlipCard(
              fill: Fill
                  .fillBack, // Fill the back side of the card to make in the same size as the front.
              direction: FlipDirection.VERTICAL, // default
              front: Container(
                margin: EdgeInsets.only(
                  bottom: _deviceHeight! * 0.02,
                  right: _deviceHeight! * 0.02,
                ),
                height: _deviceHeight! * 0.20,
                width: _deviceHeight! * 0.20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  image: DecorationImage(
                    image: NetworkImage("${_pets[index]["petImg"]}"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      gradient: const LinearGradient(
                          colors: [
                            Colors.black12,
                            Colors.black87,
                          ],
                          begin: Alignment.center,
                          stops: [0.4, 1],
                          end: Alignment.bottomCenter)),
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      "${_pets[index]["petName"]}",
                      maxLines: 3,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
              back: Container(
                margin: EdgeInsets.only(
                  bottom: _deviceHeight! * 0.02,
                  right: _deviceHeight! * 0.02,
                ),
                height: _deviceHeight! * 0.20,
                width: _deviceHeight! * 0.20,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 245, 216),
                  borderRadius: BorderRadius.circular(40),
                ),
                padding: const EdgeInsets.fromLTRB(20, 10, 5, 5),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    children: [
                      RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: <TextSpan>[
                            TextSpan(
                                text: "${_pets[index]["petName"]}",
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 30,
                                )),
                            TextSpan(
                                text:
                                    "\nAge: ${_pets[index]["petAge"]}\nSpecies: ${_pets[index]["species"]}\nBreed: ${_pets[index]["breed"]}\nAvailability: ${_pets[index]["availability"]}\nNotes: ${_pets[index]["notes"]}"),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {},
                              child: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                              child: InkWell(
                                onTap: () {},
                                child: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _myPetsTitle() {
    return Container(
      margin: const EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        bottom: 20.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("My Pets",
              style: TextStyle(fontSize: 22.5, fontWeight: FontWeight.w600)),
          const Padding(padding: EdgeInsets.all(5)),
          _addButton()
        ],
      ),
    );
  }

  Widget _addButton() {
    return SizedBox.fromSize(
      size: const Size(50, 50),
      child: ClipOval(
        child: Material(
          color: const Color.fromARGB(255, 236, 68, 68),
          child: InkWell(
            onTap: () => Navigator.pushNamed(context, "addpet"),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.pets,
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

  Widget _myReviewsTitle() {
    return Container(
      margin: const EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        bottom: 20.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text("My Reviews",
              style: TextStyle(fontSize: 22.5, fontWeight: FontWeight.w600)),
          Padding(
            padding: EdgeInsets.all(5),
            child: Icon(
              Icons.reviews,
              color: Color.fromARGB(255, 236, 68, 68),
              size: 40,
            ),
          ),
        ],
      ),
    );
  }

  Widget _userReviewsCard() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: Colors.black)),
      margin: const EdgeInsets.only(
        left: 20.0,
        right: 20.0,
      ),
      height: _deviceHeight! * 0.4,
      padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
      child: ListView.separated(
          itemCount: _reviews.length,
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
          scrollDirection: Axis.vertical,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: const EdgeInsets.only(bottom: 5, top: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "From: ${_reviews[index]["author"]} ${_reviews[index]["date"]}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text("${_reviews[index]["comment"]}"),
                ],
              ),
            );
          }),
    );
  }
}
