import "package:flutter/material.dart";
import "package:flip_card/flip_card.dart";

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ProfilePageState();
  }
}

class _ProfilePageState
    extends State<ProfilePage> {
  double? _deviceHeight;
  double? _deviceWidth;
  final List<Map> entries = <Map>[
    {
      "username": "Jess64",
      "location": "Leeds",
      "profileURL":
          "https://images.unsplash.com/photo-1514315384763-ba401779410f?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=383&q=80",
      "pets": [
        {
          "pet_name": "Rover",
          "age": 3,
          "species": "dogs",
          "image":
              "https://images.unsplash.com/photo-1644614398468-06fad5e8f8f6?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=502&q=80",
          "availability": true,
          "distance": "0.5 miles away",
          "notes": "Likes chicken"
        },
        {
          "pet_name": "Timmy",
          "age": 87,
          "species": "tortoises and turtles",
          "image":
              "https://images.unsplash.com/photo-1508455858334-95337ba25607?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=876&q=80",
          "availability": true,
          "distance": "2 miles away",
          "notes": "A game of fetch takes forever"
        },
        {
          "pet_name": "Blobby",
          "age": 7,
          "species": "other",
          "image":
              "https://images.unsplash.com/photo-1575485670541-824ff288aaf8?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=774&q=80",
          "availability": true,
          "distance": "3 miles away",
          "notes": "Will bite you if provoked."
        },
        {
          "pet_name": "Joshua",
          "age": 6,
          "species": "other",
          "image":
              "https://images.unsplash.com/photo-1615087240969-eeff2fa558f2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=580&q=80",
          "availability": true,
          "distance": "8 miles away",
          "notes": "Does not like being alone"
        },
        {
          "pet_name": "Apple",
          "age": 87,
          "species": "hamsters",
          "image":
              "https://images.unsplash.com/photo-1425082661705-1834bfd09dca?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=876&q=80",
          "availability": true,
          "distance": "10 miles away",
          "notes": "Sensitive"
        }
      ],
      "reviews": [
        {
          "fromUser": "Andy123",
          "date": "25/02/2022",
          "comment":
              "Rover is the devil. He ate my piglet! Avoid at all cost. Jess is hot though",
        },
        {
          "fromUser": "TomUser",
          "date": "1/02/2022",
          "comment": "Great person! ",
        },
        {
          "fromUser": "Andy123",
          "date": "25/02/2022",
          "comment":
              "In publishing and graphic design, Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document or a typeface without relying on meaningful content. Lorem ipsum may be used as a placeholder before the final copy is available.",
        }
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    _deviceHeight =
        MediaQuery.of(context).size.height;
    _deviceWidth =
        MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: const Color.fromARGB(
              255, 245, 245, 245),
          child: ListView(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment
                          .spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment:
                      CrossAxisAlignment.center,
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
        mainAxisAlignment:
            MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment:
            CrossAxisAlignment.center,
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
          image: NetworkImage(
              "${entries[0]["profileURL"]}"),
        ),
      ),
    );
  }

  Widget _userInfo() {
    return Column(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment:
          CrossAxisAlignment.center,
      children: [
        Text(
          "${entries[0]["username"]}",
          style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w600),
        ),
        Text("${entries[0]["location"]}",
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600))
      ],
    );
  }

  Widget _userPetsCard() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
          border: Border.all(
              color: const Color.fromARGB(
                  255, 70, 70, 70))),
      margin: const EdgeInsets.only(
        left: 10.0,
        right: 10.0,
        bottom: 20.0,
      ),
      height: _deviceHeight! * 0.4,
      padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
            0, 10, 0, 10),
        child: ListView.separated(
          itemCount: entries[0]["pets"].length,
          separatorBuilder:
              (BuildContext context, int index) =>
                  const Divider(),
          scrollDirection: Axis.horizontal,
          itemBuilder:
              (BuildContext context, int index) {
            return FlipCard(
              fill: Fill
                  .fillBack, // Fill the back side of the card to make in the same size as the front.
              direction: FlipDirection
                  .VERTICAL, // default
              front: Container(
                margin: EdgeInsets.only(
                  bottom: _deviceHeight! * 0.02,
                  right: _deviceHeight! * 0.02,
                ),
                height: _deviceHeight! * 0.20,
                width: _deviceHeight! * 0.20,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(40),
                  image: DecorationImage(
                    image: NetworkImage(
                        "${entries[0]["pets"][index]["image"]}"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(
                              40),
                      gradient:
                          const LinearGradient(
                              colors: [
                                Colors.black12,
                                Colors.black87,
                              ],
                              begin: Alignment
                                  .center,
                              stops: [0.4, 1],
                              end: Alignment
                                  .bottomCenter)),
                  padding:
                      const EdgeInsets.fromLTRB(
                          0, 0, 0, 10),
                  child: Align(
                    alignment:
                        Alignment.bottomCenter,
                    child: Text(
                      "${entries[0]["pets"][index]["pet_name"]}",
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
                  color: const Color.fromARGB(
                      255, 255, 245, 216),
                  borderRadius:
                      BorderRadius.circular(40),
                ),
                padding:
                    const EdgeInsets.fromLTRB(
                        20, 10, 5, 5),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    children: [
                      RichText(
                        text: TextSpan(
                          style:
                              DefaultTextStyle.of(
                                      context)
                                  .style,
                          children: <TextSpan>[
                            TextSpan(
                                text:
                                    "${entries[0]["pets"][index]["pet_name"]}",
                                style:
                                    const TextStyle(
                                  color: Color
                                      .fromARGB(
                                          255,
                                          0,
                                          0,
                                          0),
                                  fontSize: 30,
                                )),
                            TextSpan(
                                text:
                                    "\nAge: ${entries[0]["pets"][index]["age"]}\nSpecies: ${entries[0]["pets"][index]["species"]}\nAvailability: ${entries[0]["pets"][index]["availability"]}\nNotes: ${entries[0]["pets"][index]["notes"]}"),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets
                            .fromLTRB(0, 5, 0, 0),
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
                              padding:
                                  const EdgeInsets
                                          .fromLTRB(
                                      30,
                                      0,
                                      0,
                                      0),
                              child: InkWell(
                                onTap: () {},
                                child: const Icon(
                                  Icons.edit,
                                  color:
                                      Colors.blue,
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
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          const Text("My Pets",
              style: TextStyle(
                  fontSize: 22.5,
                  fontWeight: FontWeight.w600)),
          const Padding(
              padding: EdgeInsets.all(5)),
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
          color: Color.fromARGB(255, 236, 68, 68),
          child: InkWell(
            onTap: () => Navigator.pushNamed(
                context, "addpet"),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.pets,
                  color: Colors.white,
                ), // <-- Icon
                Text("Add",
                    style: TextStyle(
                        color: Colors
                            .white)), // <-- Text
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
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: const [
          Text("My Reviews",
              style: TextStyle(
                  fontSize: 22.5,
                  fontWeight: FontWeight.w600)),
          Padding(
            padding: EdgeInsets.all(5),
            child: Icon(
              Icons.reviews,
              color: Color.fromARGB(
                  255, 236, 68, 68),
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
          border:
              Border.all(color: Colors.black)),
      margin: const EdgeInsets.only(
        left: 20.0,
        right: 20.0,
      ),
      height: _deviceHeight! * 0.4,
      padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
      child: ListView.separated(
          itemCount: entries[0]["reviews"].length,
          separatorBuilder:
              (BuildContext context, int index) =>
                  const Divider(),
          scrollDirection: Axis.vertical,
          itemBuilder:
              (BuildContext context, int index) {
            return Container(
              margin: const EdgeInsets.only(
                  bottom: 5, top: 5),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    "From: ${entries[0]["reviews"][index]["fromUser"]} ${entries[0]["reviews"][index]["date"]}",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                      "${entries[0]["reviews"][index]["comment"]}"),
                ],
              ),
            );
          }),
    );
  }
}
