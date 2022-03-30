import "package:flutter/material.dart";
import "package:flip_card/flip_card.dart";
import 'package:nc_project/pages/chat_detail_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "dart:convert";
import "package:http/http.dart" as http;
import 'package:nc_project/pages/edit_pet_page.dart';
import 'package:get_it/get_it.dart';
import 'package:nc_project/services/firebase_service.dart';

class ProfilePage extends StatefulWidget {
  final String? _passedInData;
  const ProfilePage(this._passedInData, {Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() {
    return _ProfilePageState();
  }
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 2;
  final List<String> _pages = <String>["home", "chat", "profile"];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.popAndPushNamed(context, _pages[_selectedIndex]);
  }

  Map _userJson = {};
  String _username = "";
  String _postcode = "";
  String _area = "";
  String _img = "";
  List _pets = [];
  List _reviews = [];
  String _isBreed = "";
  String _idToUse = "";
  FirebaseService? _firebaseService;

  final FirebaseAuth auth = FirebaseAuth.instance;

  void fetchUser() async {
    try {
      final uid = auth.currentUser!.uid;
      widget._passedInData != null
          ? _idToUse = widget._passedInData!
          : _idToUse = uid;

      final response = await http.get(Uri.parse(
          'https://nc-project-api.herokuapp.com/api/users/$_idToUse'));
      final jsonData = jsonDecode(response.body) as Map;
      setState(() {
        _userJson = jsonData;
        _username = _userJson['user']['username'];
        _postcode = _userJson['user']['postcode'].substring(0, 3);
        _img = _userJson['user']['img'];
        try {
          _area = _userJson['user']['area'];
        } catch (e) {
          _area = "";
        }
        try {
          _pets = _userJson['user']['pets'];
        } catch (error) {
          _pets = [];
        }
        try {
          _reviews = _userJson['user']['reviews'];
        } catch (error) {
          _reviews = [];
        }
      });
    } catch (error) {
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUser();
    _firebaseService = GetIt.instance.get<FirebaseService>();
  }

  double? _deviceHeight;
  double? _deviceWidth;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 83, 167, 245),
        centerTitle: true,
        title: Image.asset('ptp_logolong.png', height: 40, fit: BoxFit.cover),
      ),
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
                    _logoutButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.question_answer_outlined),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.face),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 83, 167, 245),
        onTap: _onItemTapped,
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
          image: _img.isNotEmpty
              ? NetworkImage(_img)
              : const NetworkImage(
                  "https://cdn.pixabay.com/photo/2019/09/14/09/44/cat-4475583_960_720.png"),
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
        Text(_area != "" ? _area : _postcode,
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
            _isBreed = _pets[index]["breed"] == null
                ? ""
                : "\nBreed: ${_pets[index]["breed"]}";

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
                    image: _pets[index]["img"].isNotEmpty
                        ? NetworkImage(_pets[index]["img"])
                        : const NetworkImage("https://i.pravatar.cc/300"),
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
                      "${_pets[index]["name"]}",
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
                            //turn to widget
                            //change to Text widgets

                            TextSpan(
                                text:
                                    "\nAge: ${_pets[index]["age"]}\nSpecies: ${_pets[index]["species"]}"),
                            TextSpan(
                              text: _isBreed,
                            ),
                            TextSpan(
                                text:
                                    "\nAvailability: ${_pets[index]["availability"]}\nNotes: ${_pets[index]["desc"]}"),
                          ],
                        ),
                      ),
                      widget._passedInData == null
                          ? Padding(
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        deletePet(_pets[index]["petId"]);
                                        _pets.removeAt(index);
                                      });
                                    },
                                    child: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(30, 0, 0, 0),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return EditPetPage(_pets[index]);
                                        }));
                                      },
                                      child: const Icon(
                                        Icons.edit,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const Text(''),
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
          const Text("Pets",
              style: TextStyle(fontSize: 22.5, fontWeight: FontWeight.w600)),
          const Padding(padding: EdgeInsets.all(5)),
          widget._passedInData == null
              ? _addButton()
              : _messageButton(_username, _img)
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

  Widget _messageButton(_username, _img) {
    return SizedBox.fromSize(
      size: const Size(50, 50),
      child: ClipOval(
        child: Material(
          color: Colors.blue,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return ChatDetailPage(
                    name: _username,
                    otherUser: _idToUse,
                    image: _img,
                    fromChat: false,
                  );
                }),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.chat,
                  color: Colors.white,
                ), // <-- Icon
                Text("Chat", style: TextStyle(color: Colors.white)), // <-- Text
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
          Text("Reviews",
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

  Widget _logoutButton() {
    return Container(
      margin: const EdgeInsets.only(top: 10.0, bottom: 5),
      child: Visibility(
        visible: widget._passedInData != null ? false : true,
        child: MaterialButton(
          onPressed: () async {
            await _firebaseService!.logout();
            Navigator.popAndPushNamed(context, 'login');
          },
          minWidth: _deviceWidth! * 0.30,
          height: _deviceHeight! * 0.05,
          color: Colors.red,
          child: const Text(
            "Logout",
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
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
            String reviewTextHeader;
            String reviewTextBody;
            if (_reviews.isEmpty) {
              reviewTextHeader =
                  "From: ${_reviews[index]["author"]} ${_reviews[index]["date"]}";
              reviewTextBody = "${_reviews[index]["comment"]}";
            } else {
              reviewTextHeader = "";
              reviewTextBody = "";
            }
            return Container(
              margin: const EdgeInsets.only(bottom: 5, top: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reviewTextHeader,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(reviewTextBody),
                ],
              ),
            );
          }),
    );
  }

  void deletePet(_petId) async {
    final uid = auth.currentUser!.uid;
    await http.delete(
        Uri.parse('https://nc-project-api.herokuapp.com/api/pets/$_petId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "userId": uid,
        }));
  }
}
