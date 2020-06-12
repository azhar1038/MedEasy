import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medeasy/src/resource/user_provider.dart';

class UserDatabaseHelper {
  Future<void> addUser(String email, Map<String, dynamic> details) {
    return Firestore.instance
        .collection('users')
        .document(email)
        .setData(details)
        .then((_) => print("ADDED USER"))
        .catchError((e) {
      return Future.error(UserDatabaseHelperException(
        "USER_DATABASE_HELPER_EXCEPTION: $e",
      ));
    });
  }

  Future<void> updateUser(String email, Map<String, dynamic> details) {
    return Firestore.instance
        .collection('users')
        .document(email)
        .setData(details)
        .then((_) {
      UserProvider.instance.updateUser(details);
      print('Updated Details');
    }).catchError((e) {
      return Future.error(UserDatabaseHelperException(
        "USER_DATABASE_HELPER_EXCEPTION: $e",
      ));
    });
  }

  Future<Map> getUser(String email) {
    return Firestore.instance
        .collection('users')
        .document(email)
        .get()
        .then((DocumentSnapshot snapshot) => snapshot.data)
        .catchError((e) {
      return Future.error(UserDatabaseHelperException(
        "USER_DATABASE_HELPER_EXCEPTION: $e",
      ));
    });
  }
}

class UserDatabaseHelperException implements Exception {
  String message;
  UserDatabaseHelperException(this.message);
}
