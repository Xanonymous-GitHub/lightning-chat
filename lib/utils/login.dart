import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<AuthResult> login({String email, String password}) async {
  SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
  if (email == null || password == null) {
    String sEmail = _sharedPreferences.getString('userEmail');
    String sPassword = _sharedPreferences.getString('userPassword');
    email = sEmail;
    password = sPassword;
  }
  final FirebaseAuth _auth = FirebaseAuth.instance;
  try {
    if (email == null || password == null) {
      return null;
    }
    final _user = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    _sharedPreferences.setString('userEmail', email);
    _sharedPreferences.setString('userPassword', password);
    return _user;
  } on Exception catch (e) {
    print(e);
    return null;
  }
}
