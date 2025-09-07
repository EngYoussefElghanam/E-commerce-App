import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ecommerce/Models/user_info.dart';

abstract class AuthServices {
  Future<bool> login(String email, String password);
  Future<bool> register(String email, String password, String name);
  User? currentUser();
  Future<void> logOut();
  Future<bool> googleLogin();
  Future<bool> facebookLogin();
  Future<UserData?> getUserData();
  Future<void> updateUserData({required String name, required String imgUrl});
}

class AuthServicesImpl implements AuthServices {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<bool> login(String email, String password) async {
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = userCredential.user;
    if (user != null) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<bool> register(String email, String password, String name) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = userCredential.user;
    if (user != null) {
      final userData = UserData(
        name: name,
        email: email,
        id: user.uid,
        createdAt: DateTime.now().toIso8601String(),
      );
      await FirestoreServices.createCollectionWithDoc(
        collectionName: 'users',
        docName: user.uid,
        data: userData.toMap(),
      );
      return true;
    } else {
      return false;
    }
  }

  @override
  User? currentUser() {
    return _firebaseAuth.currentUser;
  }

  @override
  Future<void> logOut() async {
    await _firebaseAuth.signOut();
    await GoogleSignIn.instance.signOut();
    await FacebookAuth.instance.logOut();
  }

  @override
  Future<bool> googleLogin() async {
    final googleSignIn = GoogleSignIn.instance;
    await googleSignIn.initialize(
      serverClientId:
          '427616826448-kbbldb2qfo4ld3d9un3jii0gqljpsd63.apps.googleusercontent.com',
    );
    final gUser = await googleSignIn.authenticate();
    final gAuth = gUser.authentication;
    final credential = GoogleAuthProvider.credential(idToken: gAuth.idToken);
    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    final user = userCredential.user;
    if (user != null) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<bool> facebookLogin() async {
    final loginResult = await FacebookAuth.instance.login();
    if (loginResult.status != LoginStatus.success) {
      return false;
    }
    final credential = FacebookAuthProvider.credential(
      loginResult.accessToken!.tokenString,
    );
    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    final user = userCredential.user;
    if (user != null) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<UserData?> getUserData() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;

    final doc = await FirestoreServices.getDocData(
      collectionName: 'users',
      docName: user.uid,
      fromMap: (data, docId) => UserData.fromMap(data),
    );

    return doc;
  }

  @override
  Future<void> updateUserData({
    required String name,
    required String imgUrl,
  }) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) throw Exception("No user logged in");

    await FirebaseFirestore.instance.collection("users").doc(uid).update({
      "name": name,
      "imgUrl": imgUrl,
    });
  }
}
