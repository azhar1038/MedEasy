import 'package:medeasy/src/model/user_model.dart';
import 'package:medeasy/src/resource/user_auth.dart';
import 'package:medeasy/src/resource/user_database_helper.dart';

class UserProvider {
  UserProvider._();
  static final UserProvider instance = UserProvider._();
  UserModel _user;

  Future<UserModel> get user async {
    if (_user == null) {
      try{
      String email = await UserAuth().getUserEmail();
      Map<String, dynamic> m = await UserDatabaseHelper().getUser(email);
      m['email'] = email;
      UserModel user = UserModel.fromMap(m);
      _user = user;
      }on UserDatabaseHelperException catch(e){
        return Future.error(e);
      }on UserAuthException catch(e){
        return Future.error(e);
      }
    }
    return _user;
  }

  void initialiseUser(String email, Map<String, dynamic> m){
    m['email'] = email;
    _user = UserModel.fromMap(m);
  }

  void updateUser(Map<String, dynamic> m){
    assert(_user != null);
    _user = UserModel.fromMap(m);
  }
}
