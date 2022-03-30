import "package:flutter/material.dart";
import "package:flip_card/flip_card.dart";
import 'package:nc_project/pages/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double? _deviceHeight;
  double? _deviceWidth;
  final List<Map> entries = <Map>[
    {
      "pet_name": "Rover",
      "age": 3,
      "species": "dogs",
      "image":
          "https://images.unsplash.com/photo-1644614398468-06fad5e8f8f6?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=502&q=80",
      "availabilty": true,
      "distance": "0.5 miles away",
      "owner": "OAUZRZuauxfPKXZdslTGmrehFnA2",
      "notes": "Likes chicken"
    },
    {
      "pet_name": "Timmy",
      "age": 87,
      "species": "tortoises and turtles",
      "image":
          "https://images.unsplash.com/photo-1508455858334-95337ba25607?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=876&q=80",
      "availabilty": true,
      "distance": "2 miles away",
      "notes": "A game of fetch takes forever"
    },
    {
      "pet_name": "Blobby",
      "age": 7,
      "species": "other",
      "image":
          "https://images.unsplash.com/photo-1575485670541-824ff288aaf8?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=774&q=80",
      "availabilty": true,
      "distance": "3 miles away",
      "notes": "Will bite you if provoked."
    },
    {
      "pet_name": "Joshua",
      "age": 6,
      "species": "other",
      "image":
          "https://images.unsplash.com/photo-1615087240969-eeff2fa558f2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=580&q=80",
      "availabilty": true,
      "distance": "8 miles away",
      "notes": "Does not like being alone"
    },
    {
      "pet_name": "Apple",
      "age": 87,
      "species": "hamsters",
      "image":
          "https://images.unsplash.com/photo-1425082661705-1834bfd09dca?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=876&q=80",
      "availabilty": true,
      "distance": "10 miles away",
      "notes": "Sensitive"
    },
    {
      "pet_name": "Fang",
      "age": 4,
      "species": "dogs",
      "image":
          "https://images.unsplash.com/photo-1558349699-1e1c38c05eeb?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80",
      "availabilty": true,
      "distance": "51 miles away",
      "notes": "High blood sugar."
    },
    {
      "pet_name": "Jimmy",
      "age": 8,
      "species": "other",
      "image":
          "https://images.unsplash.com/photo-1518796745738-41048802f99a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=869&q=80",
      "availabilty": true,
      "distance": "6 miles away",
      "notes": "Likes eating flowers"
    },
    {
      "pet_name": "Oscar",
      "age": 10,
      "species": "guinea pigs",
      "image":
          "https://images.unsplash.com/photo-1533152162573-93ad94eb20f6?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80",
      "availabilty": true,
      "distance": "4 miles away",
      "notes": "Loves a bit of fuss."
    },
  ];
  String dropdownPetValue = "All pets";
  String dropdownDistanceValue = "Any distance";
  bool _folded = true;
  List filteredEntries = [];

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                  color: const Color.fromARGB(255, 240, 240, 240),
                  height: _deviceHeight! * 0.08,
                  width: _deviceWidth!,
                  child: Stack(children: <Widget>[
                    SizedBox(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Visibility(
                            visible: _folded ? true : false,
                            child: filterDropDown()),
                      ),
                    ),
                    SizedBox(
                      child: Align(
                        alignment: Alignment.center,
                        child: Visibility(
                            visible: _folded ? true : false,
                            child: distanceDropDown()),
                      ),
                    ),
                    SizedBox(
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: searchBar()))
                  ])),
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
    );
  }

  Widget filterDropDown() {
    return SizedBox(
      width: 120,
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
                value: dropdownPetValue,
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
                      dropdownPetValue = newValue!;
                      filteredEntries = entries
                          .where((pet) =>
                              dropdownPetValue.contains(pet["species"]))
                          .toList();
                      if (filteredEntries.isEmpty &&
                          dropdownPetValue != "All pets") {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Sorry!"),
                              content: Text(
                                  "There are currently no $dropdownPetValue"),
                              actions: <Widget>[
                                ElevatedButton(
                                  child: const Text("OK"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                  );
                },
                items: <String>[
                  "All pets",
                  "dogs",
                  "birds",
                  "hamsters",
                  "guinea pigs",
                  "tortoises and turtles",
                  "other"
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
    );
  }

  Widget distanceDropDown() {
    return SizedBox(
      width: 120,
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
                value: dropdownDistanceValue,
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
                    () {},
                  );
                },
                items: <String>[
                  "Any distance",
                  "near me",
                  "a few miles",
                  "quite far",
                  "miles away",
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
    );
  }

  Widget searchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        width: _folded ? 56 : _deviceWidth!,
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
                child: !_folded
                    ? const TextField(
                        decoration: InputDecoration(
                            hintText: "Search",
                            hintStyle:
                                TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                            border: InputBorder.none),
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
                    topLeft: Radius.circular(_folded ? 32 : 0),
                    topRight: const Radius.circular(32),
                    bottomLeft: Radius.circular(_folded ? 32 : 0),
                    bottomRight: const Radius.circular(32),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Icon(
                      _folded ? Icons.search : Icons.close,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  onTap: () {
                    setState(
                      () {
                        _folded = !_folded;
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
      itemCount:
          (filteredEntries.isEmpty ? entries.length : filteredEntries.length),
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemBuilder: (BuildContext context, int index) {
        return FlipCard(
          fill: Fill.fillBack,
          direction: FlipDirection.HORIZONTAL,
          front: Container(
            height: _deviceHeight! * 0.6,
            width: _deviceWidth! * 0.5,
            margin: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              image: DecorationImage(
                image: NetworkImage(
                  (filteredEntries.isEmpty
                      ? "${entries[index]["image"]}"
                      : "${filteredEntries[index]["image"]}"),
                ),
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
                              (filteredEntries.isEmpty
                                  ? "${entries[index]["pet_name"]}, ${entries[index]["age"]}"
                                  : "${filteredEntries[index]["pet_name"]}, ${filteredEntries[index]["age"]}"),
                              style: const TextStyle(
                                  fontFamily: "Roboto",
                                  decoration: TextDecoration.none,
                                  fontSize: 40,
                                  color: Colors.white),
                            ),
                            Text(
                              filteredEntries.isEmpty
                                  ? "${entries[index]["distance"]}"
                                  : "${filteredEntries[index]["distance"]}",
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
              color: const Color.fromARGB(255, 255, 245, 216),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
              ),
              padding: const EdgeInsets.all(8),
              child: Center(
                child: Column(
                  children: <Widget>[
                    Center(
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                            child: Text(
                              (filteredEntries.isEmpty
                                  ? "${entries[index]["pet_name"]}"
                                  : "${filteredEntries[index]["pet_name"]}"),
                              style: const TextStyle(
                                fontFamily: "Roboto",
                                decoration: TextDecoration.none,
                                fontSize: 40,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(40, 5, 0, 0),
                            child: Container(
                              height: 100.0,
                              width: 100.0,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage((filteredEntries.isEmpty
                                      ? "${entries[index]["image"]}"
                                      : "${filteredEntries[index]["image"]}")),
                                  fit: BoxFit.fill,
                                ),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 250,
                      child: Text(
                        filteredEntries.isEmpty
                            ? "Distance: ${entries[index]["distance"]}\nAge: ${entries[index]["age"]}\nSpecies: ${entries[index]["species"]}\nAvailabilty: ${entries[index]["availabilty"]}\nNotes: ${entries[index]["notes"]}"
                            : "Distance: ${filteredEntries[index]["distance"]}\nAge: ${filteredEntries[index]["age"]}\nSpecies: ${filteredEntries[index]["species"]}\nAvailabilty: ${filteredEntries[index]["availabilty"]}\nNotes: ${filteredEntries[index]["notes"]}",
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
                              print(entries[index]["owner"]);
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return ProfilePage(entries[index]["owner"]);
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
        );
      },
    );
  }
}
