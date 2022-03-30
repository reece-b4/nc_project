import "package:flutter/material.dart";
import "package:flip_card/flip_card.dart";
import "package:firebase_auth/firebase_auth.dart";
import "dart:convert";
import "package:http/http.dart" as http;
import 'package:nc_project/pages/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final List<String> _pages = <String>["home", "chat", "profile"];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.popAndPushNamed(context, _pages[_selectedIndex]);
  }

  double? _deviceHeight;
  double? _deviceWidth;
  bool _foldedSearchBar = true;
  List? _allPets;
  final _allSpeciesFromCards = ["All pets"];
  String _dropdownPetValue = "All pets";
  String _dropdownDistanceValue = "Any distance";
  String _searchValue = "Search";

  final FirebaseAuth auth = FirebaseAuth.instance;

  static set home(String home) {}
  @override
  void initState() {
    super.initState();
    fetchPets(_dropdownPetValue, _dropdownDistanceValue, _searchValue);
  }

  void fetchPets(
      _dropdownPetValue, _dropdownDistanceValue, _searchValue) async {
    try {
      final user = auth.currentUser;
      final uid = user!.uid;
      var splitValue = _dropdownDistanceValue!.split(" ");
      var dropdownDistanceNumber = splitValue[0];
      var httpAddress = 'https://nc-project-api.herokuapp.com/api/pets';

      if (_dropdownPetValue != "All pets" ||
          _dropdownDistanceValue != "Any distance" ||
          _searchValue != "Search") {
        httpAddress = httpAddress + '?';
      }
      if (_dropdownPetValue != "All pets") {
        httpAddress = httpAddress + 'species=' + _dropdownPetValue + '&&';
      }
      if (_dropdownDistanceValue != "Any distance") {
        httpAddress = httpAddress + 'limit=' + dropdownDistanceNumber + '&&';
      }
      if (_searchValue != "Search") {
        httpAddress = httpAddress + 'search=' + _searchValue;
      }
      var splitHttpAddress = httpAddress.split('');
      if (splitHttpAddress.last == '&') {
        splitHttpAddress.removeLast();
        splitHttpAddress.removeLast();
        httpAddress = splitHttpAddress.join('');
      }

      final response = await http.patch(
        Uri.parse(httpAddress),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "userId": uid,
        }),
      );
      final jsonData = jsonDecode(response.body) as Map;
      setState(() {
        _allPets = [...jsonData["pets"]];
        [...jsonData["pets"]].forEach((pet) => _allSpeciesFromCards.add(
            "${pet["species"][0].toUpperCase()}${pet["species"].substring(1).toLowerCase()}"));
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 83, 167, 245),
        centerTitle: true,
        title: Image.asset('ptp_logolong.png', height: 40, fit: BoxFit.cover),
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 215, 216, 218),
                ),
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        child: Visibility(
                          visible: _foldedSearchBar ? true : false,
                          child: filterDropDown(),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 100, 0),
                        child: Visibility(
                            visible: _foldedSearchBar ? true : false,
                            child: distanceDropDown()),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(100, 0, 0, 0),
                        child: Visibility(
                            visible: _foldedSearchBar ? true : false,
                            child: searchTerm()),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        child: searchBar(),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(255, 240, 240, 240),
                          Color.fromARGB(255, 240, 240, 240),
                        ],
                        begin: Alignment.center,
                        stops: [0.1, 1000],
                        end: Alignment.bottomCenter)),
                height: _deviceHeight! * 0.90,
                width: _deviceWidth!,
                child: petCards(),
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

  Widget filterDropDown() {
    List<String> _uniqueAllSpeciesFromCards =
        _allSpeciesFromCards.toSet().toList();
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
      child: SizedBox(
        width: 100,
        child: DropdownButtonHideUnderline(
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: DropdownButton<String>(
                  value: _dropdownPetValue,
                  isExpanded: true,
                  icon: Image.asset(
                    "paw_icon.png",
                    color: Colors.grey,
                    height: 20,
                  ),
                  elevation: 60,
                  style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  underline: Container(
                    height: 2,
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                  onChanged: (String? newValue) {
                    setState(
                      () {
                        _dropdownPetValue = newValue!;
                        fetchPets(_dropdownPetValue, _dropdownDistanceValue,
                            _searchValue);
                      },
                    );
                  },
                  items:
                      _uniqueAllSpeciesFromCards.map<DropdownMenuItem<String>>(
                    (String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    },
                  ).toList(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget distanceDropDown() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(60, 5, 5, 5),
      child: SizedBox(
        width: 130,
        child: DropdownButtonHideUnderline(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: DropdownButton<String>(
                  value: _dropdownDistanceValue,
                  isExpanded: true,
                  icon: const Icon(
                    Icons.map_outlined,
                    color: Colors.grey,
                  ),
                  elevation: 60,
                  style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  underline: Container(
                    height: 2,
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                  onChanged: (String? newValue) {
                    setState(
                      () {
                        _dropdownDistanceValue = newValue!;
                        fetchPets(_dropdownPetValue, _dropdownDistanceValue,
                            _searchValue);
                      },
                    );
                  },
                  items: <String>[
                    "Any distance",
                    "3 miles",
                    "6 miles",
                    "10 miles",
                    "50 miles",
                    "100 miles"
                  ].map<DropdownMenuItem<String>>(
                    (String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    },
                  ).toList(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget searchTerm() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(55, 10, 10, 10),
      child: SizedBox(
          width: 90,
          height: 40,
          child: Visibility(
            visible: _searchValue != 'Search' ? true : false,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: const Color.fromARGB(255, 230, 112, 112),
              ),
              child: TextButton(
                style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 255, 255, 255))),
                onPressed: () {
                  setState(
                    () {
                      _searchValue = 'Search';
                      fetchPets(_dropdownPetValue, _dropdownDistanceValue,
                          _searchValue);
                    },
                  );
                },
                child: Row(children: <Widget>[
                  const Icon(Icons.clear),
                  Text((_searchValue.length > 3
                      ? _searchValue.substring(0, 4) + '...'
                      : _searchValue))
                ]),
              ),
            ),
          )),
    );
  }

  Widget searchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        width: _foldedSearchBar ? 56 : _deviceWidth!,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          color: Colors.white,
          boxShadow: kElevationToShadow[6],
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 16, bottom: 5),
                child: !_foldedSearchBar
                    ? TextField(
                        decoration: const InputDecoration(
                            hintText: "Search",
                            hintStyle:
                                TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                            border: InputBorder.none),
                        onSubmitted: (value) {
                          setState(
                            () {
                              _searchValue = value;
                              fetchPets(_dropdownPetValue,
                                  _dropdownDistanceValue, _searchValue);
                              _foldedSearchBar = !_foldedSearchBar;
                            },
                          );
                        },
                      )
                    : null,
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(_foldedSearchBar ? 32 : 0),
                    topRight: const Radius.circular(32),
                    bottomLeft: Radius.circular(_foldedSearchBar ? 32 : 0),
                    bottomRight: const Radius.circular(32),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Icon(
                      _foldedSearchBar ? Icons.search : Icons.close,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  onTap: () {
                    setState(
                      () {
                        _foldedSearchBar = !_foldedSearchBar;
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget petCards() {
    return ListView.separated(
      itemCount: _allPets?.length ?? 0,
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
              0, 0, 0, (index == _allPets!.length - 1 ? 150 : 0)),
          child: FlipCard(
            fill: Fill.fillBack,
            direction: FlipDirection.HORIZONTAL,
            front: Container(
              height: _deviceHeight! * 0.6,
              width: _deviceWidth! * 0.5,
              margin: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                image: DecorationImage(
                  image: NetworkImage("${_allPets?[index]["img"]}"),
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
                      end: Alignment.bottomCenter),
                ),
                padding: const EdgeInsets.all(8),
                child: Stack(
                  children: [
                    Positioned(
                      right: 10,
                      left: 30,
                      bottom: 10,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                ("${_allPets?[index]["name"]}, ${_allPets?[index]["age"]}"),
                                style: TextStyle(
                                    fontFamily: "Roboto",
                                    decoration: TextDecoration.none,
                                    fontSize:
                                        (_allPets![index]["name"].length > 7
                                            ? 35
                                            : 40),
                                    color: Colors.white),
                              ),
                              Text(
                                "${_allPets?[index]["distance"]} miles away",
                                style: const TextStyle(
                                    fontFamily: "Roboto",
                                    decoration: TextDecoration.none,
                                    fontSize: 20,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 16, right: 20),
                            child: Icon(
                              Icons.favorite,
                              color: Color.fromARGB(255, 228, 93, 69),
                              size: 40.0,
                              semanticLabel: "Heart",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            back: Container(
              height: _deviceHeight! * 0.65,
              width: _deviceWidth! * 0.5,
              margin: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 253, 247, 227),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 255, 245, 216),
                        Color.fromARGB(255, 255, 245, 216),
                      ],
                      begin: Alignment.center,
                      stops: [0.4, 1],
                      end: Alignment.bottomCenter),
                ),
                padding: const EdgeInsets.all(8),
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(50, 20, 0, 0),
                          child: Row(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "${_allPets?[index]["name"]}",
                                  style: TextStyle(
                                    fontFamily: "Roboto",
                                    fontWeight: FontWeight.w700,
                                    decoration: TextDecoration.none,
                                    fontSize:
                                        (_allPets![index]["name"].length > 7
                                            ? 30
                                            : 40),
                                    color: const Color.fromARGB(255, 0, 0, 0),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                    height: 100.0,
                                    width: 100.0,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            "${_allPets?[index]["img"]}"),
                                        fit: BoxFit.fill,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 250,
                        child: Text(
                          "Distance: ${_allPets![index]["distance"]} miles\nAge: ${_allPets![index]["age"]}\nSpecies: ${_allPets![index]["species"]}\nBreed: ${_allPets![index]["breed"]}\nAvailability: ${_allPets![index]["availability"]}\nNotes: ${_allPets![index]["desc"]}",
                          style: const TextStyle(
                            fontFamily: "Roboto",
                            decoration: TextDecoration.none,
                            fontSize: 20,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                        child: SizedBox(
                          width: 180,
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return ProfilePage(_allPets![index]["owner"]);
                                }));
                              },
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<
                                          Color>(
                                      const Color.fromARGB(255, 83, 167, 245))),
                              child: const Text("Contact owner",
                                  style: TextStyle(
                                      fontFamily: "Roboto",
                                      decoration: TextDecoration.none,
                                      fontSize: 20,
                                      color:
                                          Color.fromARGB(255, 255, 255, 255)))),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
