import 'package:path/path.dart' as p;
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String userCollection = 'users';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Map? currentUser;

  FirebaseService();

  Future<bool> registerUser({
    required String username,
    required String email,
    required String password,
    required String postcode,
    required File image,
  }) async {
    try {
      UserCredential _userCredential =
          await _auth.createUserWithEmailAndPassword(
              email: email, password: password); 

      String _userId =
          _userCredential.user!.uid; 

      String _fileName = Timestamp.now().millisecondsSinceEpoch.toString() +
          p.extension(image
              .path); 

      UploadTask _task = _storage.ref("images/$_userId/$_fileName").putFile(
          image); 

      return _task.then((_snapshot) async {
        String _downloadURL = await _snapshot.ref
            .getDownloadURL(); 
        await http.post(
          Uri.parse('https://nc-project-api.herokuapp.com/api/users'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            "userId": _userId,
            "username": username,
            "email": email,
            "postcode": postcode,
            "img": _downloadURL,
          }),
        );
        return true; 
      });
    } catch (e) {
      return false;
    }
  }

  Future<Map> getUserData({required String uid}) async {
    DocumentSnapshot _doc = await _db.collection(userCollection).doc(uid).get();
    return _doc.data() as Map;
  }

  Future<Map> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential _userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (_userCredential.user != null) {
        currentUser = await getUserData(uid: _userCredential.user!.uid);
        return {"isValid": true, "error": null};
      } else {
        return {"isValid": false, "error": "WHY would this trigger?"};
      }
    } catch (e) {
      return {"isValid": false, "error": "Incorrect email or password"};
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
