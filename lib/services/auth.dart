import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo/exceptions/FailedSignInException.dart';
import 'package:todo/models/user.dart';
import 'package:todo/services/database.dart';

abstract class BaseAuthService {
  Future signUpUserWithEmailPasswordAndDisplayName(String email, String password, String displayName);

  Future signInUserWithEmailAndPassword(String email, String password);

  Future signOut();
}

class AuthService implements BaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User _userFromFireBaseUser(FirebaseUser firebaseUser) {
    return firebaseUser != null
        ? User(uid: firebaseUser.uid, email: firebaseUser.email, displayName: firebaseUser.displayName)
        : null;
  }

  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFromFireBaseUser); // simpler way to accomplish the mapping
  }

  @override
  Future signUpUserWithEmailPasswordAndDisplayName(String email, String password, String displayName) async {
    try {
      // register the user on firebase
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;

      // add the display info
      UserUpdateInfo updateInfo = UserUpdateInfo();
      updateInfo.displayName = displayName;
      await user.updateProfile(updateInfo);
      await user.reload();
      user = await _auth.currentUser();
      
      await DatabaseService().addUserToUsersCollection(_userFromFireBaseUser(user));

      await DatabaseService().createDefaultCategoryOnUserSignUp(_userFromFireBaseUser(user));

      return _userFromFireBaseUser(user);
    } catch (exception) {
      print(exception.toString());
      return null;
    }
  }

  @override
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print("[signOut]: $e");
      return null;
    }
  }

  @override
  Future signInUserWithEmailAndPassword(String email, String password) async {
    AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password).then((error) {
      throw FailedSignInException(cause: error.toString());
    });
    FirebaseUser user = result.user;

    return _userFromFireBaseUser(user);
  }
}
