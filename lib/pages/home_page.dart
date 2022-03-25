import "package:flutter/material.dart";

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() =>
      _HomePageState();
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
  String dropdownValue = "Sort";
  bool _folded = true;

  //STATE CHANGES
  List filteredEntries = [];

  @override
  Widget build(BuildContext context) {
    _deviceHeight =
        MediaQuery.of(context).size.height;
    _deviceWidth =
        MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                  color: Color.fromARGB(
                      255, 240, 240, 240),
                  height: _deviceHeight! * 0.07,
                  width: _deviceWidth!,
                  child: Row(children: [
                    Padding(
                      padding: const EdgeInsets
                          .fromLTRB(0, 5, 0, 5),
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                          40),
                              color:
                                  Color.fromARGB(
                                      255,
                                      255,
                                      255,
                                      255)),
                          child:
                              filterDropDown()),
                    ),
                    Spacer(),
                    searchBar()
                  ])),
              Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(
                              255, 240, 240, 240),
                          Color.fromARGB(
                              255, 240, 240, 240),
                        ],
                        begin: Alignment.center,
                        stops: [0.1, 1000],
                        end: Alignment
                            .bottomCenter)),
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
    return Container(
      width: 120,
      child: DropdownButtonHideUnderline(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: DropdownButton<String>(
            value: dropdownValue,
            isExpanded: true,
            icon: const Icon(Icons
                .arrow_drop_down_circle_outlined),
            elevation: 60,
            style: const TextStyle(
                color:
                    Color.fromARGB(255, 0, 0, 0)),
            underline: Container(
              height: 2,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue = newValue!;
                filteredEntries = entries
                    .where((pet) => dropdownValue
                        .contains(pet["species"]))
                    .toList();
                if (filteredEntries.isEmpty &&
                    dropdownValue != "Sort") {
                  showDialog(
                    context: context,
                    builder:
                        (BuildContext context) {
                      return AlertDialog(
                        title:
                            const Text("Sorry!"),
                        content: Text(
                            "There are currently no $dropdownValue"),
                        actions: <Widget>[
                          ElevatedButton(
                            child:
                                const Text("OK"),
                            onPressed: () {
                              Navigator.of(
                                      context)
                                  .pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              });
            },
            items: <String>[
              "Sort",
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
    );
  }

  Widget petCards() {
    return ListView.separated(
      itemCount: (filteredEntries.isEmpty
          ? entries.length
          : filteredEntries.length),
      separatorBuilder:
          (BuildContext context, int index) =>
              const Divider(),
      itemBuilder:
          (BuildContext context, int index) {
        return Container(
          height: _deviceHeight! * 0.65,
          width: _deviceWidth! * 0.5,
          margin: const EdgeInsets.all(15.0),
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(40),
            image: DecorationImage(
              image: NetworkImage((filteredEntries
                      .isEmpty
                  ? "${entries[index]["image"]}"
                  : "${filteredEntries[index]["image"]}")),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
              decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(40),
                  gradient: const LinearGradient(
                      colors: [
                        Colors.black12,
                        Colors.black87,
                      ],
                      begin: Alignment.center,
                      stops: [0.4, 1],
                      end: Alignment
                          .bottomCenter)),
              padding: const EdgeInsets.all(8),
              child: Stack(
                children: [
                  Positioned(
                    right: 10,
                    left: 30,
                    bottom: 10,
                    child: Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.end,
                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          mainAxisSize:
                              MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              (filteredEntries
                                      .isEmpty
                                  ? "${entries[index]["pet_name"]}, ${entries[index]["age"]}"
                                  : "${filteredEntries[index]["pet_name"]}, ${filteredEntries[index]["age"]}"),
                              style: const TextStyle(
                                  fontFamily:
                                      "Roboto",
                                  decoration:
                                      TextDecoration
                                          .none,
                                  fontSize: 40,
                                  color: Colors
                                      .white),
                            ),
                            Text(
                              "${entries[index]["distance"]}",
                              style: const TextStyle(
                                  fontFamily:
                                      "Roboto",
                                  decoration:
                                      TextDecoration
                                          .none,
                                  fontSize: 20,
                                  color: Colors
                                      .white),
                            ),
                          ],
                        ),
                        const Padding(
                          padding:
                              EdgeInsets.only(
                                  bottom: 16,
                                  right: 20),
                          child: Icon(
                            Icons.favorite,
                            color: Color.fromARGB(
                                255, 238, 44, 10),
                            size: 40.0,
                            semanticLabel:
                                "Heart",
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        );
      },
    );
  }

  Widget searchBar() {
    return Padding(
      padding:
          const EdgeInsets.fromLTRB(0, 2, 0, 3),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 400),
        width: _folded ? 56 : 250,
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          color: Colors.white,
          boxShadow: kElevationToShadow[6],
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.only(
                    left: 16, bottom: 5),
                child: !_folded
                    ? const TextField(
                        decoration: InputDecoration(
                            hintText: 'Search',
                            hintStyle: TextStyle(
                                color: Color
                                    .fromARGB(255,
                                        0, 0, 0)),
                            border:
                                InputBorder.none),
                      )
                    : null,
              ),
            ),
            AnimatedContainer(
                duration: const Duration(
                    milliseconds: 400),
                child: Material(
                    type:
                        MaterialType.transparency,
                    child: InkWell(
                      borderRadius:
                          BorderRadius.only(
                        topLeft: Radius.circular(
                            _folded ? 32 : 0),
                        topRight:
                            Radius.circular(32),
                        bottomLeft:
                            Radius.circular(
                                _folded ? 32 : 0),
                        bottomRight:
                            Radius.circular(32),
                      ),
                      child: Padding(
                        padding:
                            EdgeInsets.all(16),
                        child: Icon(
                          _folded
                              ? Icons.search
                              : Icons.close,
                          color: Color.fromARGB(
                              255, 0, 0, 0),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _folded = !_folded;
                        });
                      },
                    )))
          ],
        ),
      ),
    );
  }
}
