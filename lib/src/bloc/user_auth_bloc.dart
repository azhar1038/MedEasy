import 'package:rxdart/rxdart.dart';

enum AuthState{Uninitialised, Authenticated, Unauthenticated, FirstLogin}

class UserAuthBloc{
  AuthState authState = AuthState.Uninitialised;
  BehaviorSubject<AuthState> _userAuthDetector;

  static UserAuthBloc _userAuthBloc;

  factory UserAuthBloc(){
    if(_userAuthBloc == null) _userAuthBloc = UserAuthBloc._();
    return _userAuthBloc;
  }

  UserAuthBloc._(){
    _userAuthDetector = BehaviorSubject<AuthState>();
  }

  Stream<AuthState> get userAuthStream => _userAuthDetector.stream;

  void uninitialise(){
    authState = AuthState.Uninitialised;
    _userAuthDetector.add(authState);
  }

  void authenticate(){
    authState = AuthState.Authenticated;
    _userAuthDetector.add(authState);
  }

  void unauthenticate(){
    authState = AuthState.Unauthenticated;
    _userAuthDetector.add(authState);
  }

  void firstLogin(){
    authState = AuthState.FirstLogin;
    _userAuthDetector.add(authState);
  }

  void dispose(){
    if(!_userAuthDetector.isClosed){
      _userAuthDetector.close();
      _userAuthBloc = null;
    }
  }
}