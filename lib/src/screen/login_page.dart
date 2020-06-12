import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medeasy/src/bloc/user_auth_bloc.dart';
import 'package:medeasy/src/resource/user_auth.dart';
import 'package:medeasy/src/resource/user_database_helper.dart';
import 'package:medeasy/src/resource/user_provider.dart';
import 'package:medeasy/src/widget/wait_dialog.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  UserAuth _userAuth;
  UserAuthBloc _userAuthBloc;
  UserDatabaseHelper _dbHelper;

  @override
  void initState() {
    _userAuth = UserAuth();
    _userAuthBloc = UserAuthBloc();
    _dbHelper = UserDatabaseHelper();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('image/background.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Builder(builder: (context) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Sign In with',
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(height: 16),
                FlatButton(
                  child: Image.asset('image/google.png', width: 120),
                  onPressed: login,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  void login() async {
    WaitDialog wd = WaitDialog(context);
    wd.showWaitDialog(false);
    try {
      FirebaseUser _user = await _userAuth.signInWithGoogle();
      Map<String, dynamic> _userDetails = await _dbHelper.getUser(_user.email);
      if (_userDetails == null) {
        UserProvider.instance.initialiseUser(_user.email, {
          'name': _user.displayName,
          'photoUrl': _user.photoUrl,
          'email': _user.email,
        });
        wd.removeWaitDialog();
        _userAuthBloc.firstLogin();
      } else {
        UserProvider.instance.initialiseUser(_user.email, _userDetails);
        wd.removeWaitDialog();
        _userAuthBloc.authenticate();
      }
    } on UserAuthException catch (e) {
      print('Failed to SignIn: ${e.message}');
      wd.removeWaitDialog();
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Oops! Failed to Sign In.'),
        ),
      );
    }
  }
}
