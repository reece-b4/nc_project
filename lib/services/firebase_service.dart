import 'package:path/path.dart' as p;
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
    required File image,
  }) async {
    try {
      UserCredential _userCredential =
          await _auth.createUserWithEmailAndPassword(
              email: email, password: password); //creates the user in AUTH

      String _userId =
          _userCredential.user!.uid; //we save uid of the newly created user

      String _fileName = Timestamp.now().millisecondsSinceEpoch.toString() +
          p.extension(image
              .path); //create a filename that looks like "1231232131412341" which is timestamp + the extension of the file ie .png

      UploadTask _task = _storage.ref('images/$_userId/$_fileName').putFile(
          image); //uploads the file on storage at the reference(file path) we define

      return _task.then((_snapshot) async {
        //this will be the final return to the whole function

        String _downloadURL = await _snapshot.ref
            .getDownloadURL(); //create the url for the file we just uploaded
        await _db.collection(userCollection).doc(_userId).set({
          "username": username,
          "email": email,
          "image": _downloadURL,
        }); //finally upload to firestore db
        return true; //once done, return true as it's a function that returns a bool. This becomes the value returned from line39
      });
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<Map> getUserData({required String uid}) async {
    DocumentSnapshot _doc = await _db.collection(userCollection).doc(uid).get();
    return _doc.data() as Map;
  }

  Future<bool> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential _userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (_userCredential.user != null) {
        currentUser = await getUserData(uid: _userCredential.user!.uid);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}
