import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;

  UserRepository({
    FirebaseAuth firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Future<void> signInWithCredentials(String email, String password) async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _sharedPreferences.setString('userEmail', email);
      _sharedPreferences.setString('userPassword', password);
    } on Exception catch (e) {
      print(e);
      throw Exception;
    }
  }

  Future<void> autoSignIn() async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    try {
      String sEmail = _sharedPreferences.getString('userEmail');
      String sPassword = _sharedPreferences.getString('userPassword');
      assert(sEmail != null);
      assert(sPassword != null);
      await _firebaseAuth.signInWithEmailAndPassword(
        email: sEmail,
        password: sPassword,
      );
    } on Exception catch (e) {
      print(e);
      throw Exception;
    }
  }

  Future<void> signUp({String email, String password}) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    return Future.wait([
      _firebaseAuth.signOut(),
    ]);
  }

  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    return currentUser != null;
  }

  Future<String> getUserEmail() async {
    final current = await _firebaseAuth.currentUser();
    return current.email;
  }

  Future<String> getUserUid() async {
    final current = await _firebaseAuth.currentUser();
    return current.uid;
  }
}
