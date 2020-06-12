import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserAuth {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  UserAuth({FirebaseAuth firebaseAuth, GoogleSignIn googleSignIn})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  Future<FirebaseUser> signInWithGoogle() async {
    try {
      print("STARTING GOOGLE_SIGN_IN PROCESS......");
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      print("GOT GOOGLE ACCOUNT!");
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      print("GOT AUTHENTICATION!");

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      print("GOT CREDENTIALS!");
      FirebaseUser user =
          (await _firebaseAuth.signInWithCredential(credential)).user;
      print("SIGNED_IN SUCCESSFULLY......");
      return user;
    } catch (e) {
      throw UserAuthException('USER_AUTH_EXCEPTION: Failed to SignIn => $e');
    }
  }

  Future<void> signInWithCredential(String email, String password) {
    return _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password)
        .catchError((e) {
      return Future.error(
        UserAuthException('USER_AUTH_EXCEPTION: Failed to SignIn => $e'),
      );
    });
  }

  Future<void> signUp(String email, String password) async {
    return await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password)
        .catchError((e) {
      return Future.error(
        UserAuthException('USER_AUTH_EXCEPTION: Failed to SignUp => $e'),
      );
    });
  }

  Future<void> signOut() async {
    return Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]).catchError((e) {
      return Future.error(
        UserAuthException('USER_AUTH_EXCEPTION: Failed to SignOut => $e'),
      );
    });
  }

  Future<bool> isSignedIn() async {
    try {
      FirebaseUser _currentUser = await _firebaseAuth.currentUser();
      return _currentUser != null;
    } catch (e) {
      throw UserAuthException(
          'GOOGLE_AUTH_EXCEPTION: Failed to get user => $e');
    }
  }

  Future<String> getUserEmail() async {
    try {
      FirebaseUser _currentUser = await _firebaseAuth.currentUser();
      return _currentUser.email;
    } catch (e) {
      throw UserAuthException(
          'GOOGLE_AUTH_EXCEPTION: Failed to get user => $e');
    }
  }
}

class UserAuthException implements Exception {
  String message;
  UserAuthException(this.message);
}
