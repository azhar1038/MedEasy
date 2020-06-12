import 'package:flutter/material.dart';
import 'package:medeasy/src/bloc/user_auth_bloc.dart';
import 'package:medeasy/src/resource/user_auth.dart';
import 'package:medeasy/src/resource/user_provider.dart';
import 'package:medeasy/src/widget/loader.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  UserAuth _userAuth;
  UserAuthBloc _userAuthBloc;
  AnimationController _controller;
  Animation<double> _align;

  @override
  void initState() {
    _userAuth = UserAuth();
    _userAuthBloc = UserAuthBloc();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _align = Tween<double>(begin: 0, end: -0.7).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.ease,
      ),
    );
    _controller.forward();
    loadScreen();
    super.initState();
  }

  Future<void> loadScreen() async {
    bool signedIn = await _userAuth.isSignedIn();
    if (signedIn) {
      await UserProvider.instance.user;
      _userAuthBloc.authenticate();
    } else {
      _userAuthBloc.unauthenticate();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('image/splash.jpg'), fit: BoxFit.cover),
            ),
          ),
          AnimatedBuilder(
            animation: _align,
            builder: (context, child) {
              return Container(
                alignment: Alignment(0, _align.value),
                child: Image.asset(
                  'image/logo.png',
                  height: 100,
                  width: 100,
                ),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 200,
              child: Loader(),
            ),
          ),
        ],
      ),
    );
  }
}
