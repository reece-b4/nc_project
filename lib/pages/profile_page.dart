import "package:flutter/material.dart";

class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProfilePageState();
  }
}

class _ProfilePageState extends State<ProfilePage> {
  double? _deviceHeight;
  double? _deviceWidth;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: _deviceWidth! * 0.05,
            vertical: _deviceHeight! * 0.05,
          ),
          child: ListView(
            children: [
              Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _UserCard(),
                  _myPetsTitle(),
                  _userPetsCard(),
                  _myReviewsTitle(),
                  _userReviewsCard(),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _UserCard() {
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
          children: [_UserAvatar(), _UserInfo()],
        ));
  }

  Widget _UserAvatar() {
    return Container(
      margin: EdgeInsets.only(
        bottom: _deviceHeight! * 0.02,
      ),
      height: _deviceHeight! * 0.15,
      width: _deviceHeight! * 0.15,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          100,
        ),
        image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage("https://i.pravatar.cc/300")),
      ),
    );
  }

  Widget _UserInfo() {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "Jess64",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const Text("Leeds",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600))
      ],
    ));
  }

  Widget _userPetsCard() {
    return Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        margin: const EdgeInsets.only(
          left: 20.0,
          right: 20.0,
          bottom: 20.0,
        ),
        height: _deviceHeight! * 0.4,
        padding: EdgeInsets.symmetric(horizontal: _deviceWidth! * 0.05),
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            _petInfo(),
            _petInfo(),
            _petInfo(),
          ],
        ));
  }

  Widget _petInfo() {
    return Container(
        margin: EdgeInsets.only(
          bottom: _deviceHeight! * 0.02,
          right: _deviceHeight! * 0.02,
        ),
        height: _deviceHeight! * 0.20,
        width: _deviceHeight! * 0.20,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: Image.network("https://i.pravatar.cc/300")),
            const Text("Rover",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            const Text("7",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            const Text("Dog",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            const Text("Dalmatian",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            Icon(
              Icons.delete,
              color: Colors.red,
            ), // <-- Icon
          ],
        ));
  }

  Widget _myPetsTitle() {
    return Container(
      margin: const EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        bottom: 20.0,
      ),
      child: Row(
        children: [
          const Text("My Pets",
              style: TextStyle(fontSize: 22.5, fontWeight: FontWeight.w600)),
          Padding(padding: EdgeInsets.all(5)),
          _addButton()
        ],
      ),
    );
  }

  Widget _addButton() {
    return SizedBox.fromSize(
      size: Size(45, 45),
      child: ClipOval(
        child: Material(
          color: Colors.purple,
          child: InkWell(
            splashColor: Colors.green,
            onTap: () => Navigator.pushNamed(context, 'addpet'),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text("My Reviews",
              style: TextStyle(fontSize: 22.5, fontWeight: FontWeight.w600)),
          Icon(Icons.reviews),
        ],
      ),
    );
  }

  Widget _userReviewsCard() {
    return Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        margin: const EdgeInsets.only(
          left: 20.0,
          right: 20.0,
        ),
        height: _deviceHeight! * 0.4,
        padding: EdgeInsets.symmetric(horizontal: _deviceWidth! * 0.05),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            _reviewInfo(),
            _reviewInfo(),
            _reviewInfo(),
            _reviewInfo(),
            _reviewInfo(),
            _reviewInfo(),
            _reviewInfo(),
            _reviewInfo(),
            _reviewInfo(),
            _reviewInfo(),
          ],
        ));
  }

  Widget _reviewInfo() {
    return Container(
      margin: const EdgeInsets.only(bottom: 5, top: 5),
      child: Column(
        children: [
          const Text(
            "Bobby11 - 12/03/2022 13:02",
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          const Text(
              "Rover is the devil. He ate my piglet! Avoid at all cost. Jess is hot though"),
        ],
      ),
    );
  }
}
