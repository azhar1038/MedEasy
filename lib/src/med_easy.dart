import 'package:flutter/material.dart';
import 'package:medeasy/src/bloc/user_auth_bloc.dart';
import 'package:medeasy/src/screen/home_page.dart';
import 'package:medeasy/src/screen/login_page.dart';
import 'package:medeasy/src/screen/user_details.dart';
import 'package:medeasy/src/splash_screen.dart';

class MedEasy extends StatefulWidget {
  @override
  _MedEasyState createState() => _MedEasyState();
}

class _MedEasyState extends State<MedEasy> {
  UserAuthBloc _userAuthBloc;

  @override
  void initState() {
    _userAuthBloc = UserAuthBloc();
    _userAuthBloc.uninitialise();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MedEasy',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        brightness: Brightness.light,
        cursorColor: Colors.lightGreen,
        textTheme: TextTheme(
          subtitle1: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(width: 3, color: Colors.teal),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(width: 2, color: Colors.grey),
          ),
        ),
      ),
      home: StreamBuilder<AuthState>(
        stream: _userAuthBloc.userAuthStream,
        initialData: AuthState.Uninitialised,
        builder: (context, authState) {
          if (authState.data == AuthState.Unauthenticated)
            return LoginPage();
          else if (authState.data == AuthState.Authenticated)
            return HomePage();
          else if (authState.data == AuthState.FirstLogin)
            return UserDetails();
          else
            return SplashScreen();
        },
      ),
    );
  }
}
