import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz_app/models/user.dart';

class AuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;

  UserModel? _userFromFirebaseUser(User user) {
    return user != null ? UserModel(uid: user.uid) : null;
  }

  Future signInEmailAndPass(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = userCredential.user;
      return _userFromFirebaseUser(user!);
    } catch (e) {
      print(e.toString());
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      return _userFromFirebaseUser(user!);
    } catch (e) {
      print(e.toString());
    }
  }

  // Future signOut() async{
  //   try{
  //     return await _auth.signOut;
  //   }catch(e){
  //     print(e.toString());
  //   }
  // }

}
