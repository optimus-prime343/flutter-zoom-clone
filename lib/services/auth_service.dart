import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'firestore_service.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  User? get currentUser => _firebaseAuth.currentUser;
  String? get userUid => _firebaseAuth.currentUser?.uid;

  String get currentUserUsername {
    String? usernameFromEmail = currentUser?.email?.split('@')[0].toLowerCase();
    String? username = currentUser?.displayName;

    return username != null && username.isNotEmpty
        ? username
        : (usernameFromEmail ?? 'Anonymous');
  }

  Future<void> signInWithGoogle({
    required void Function() onSuccess,
    required void Function(String error) onError,
  }) async {
    try {
      GoogleSignIn googleSignIn = GoogleSignIn(scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ]);
      GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      OAuthCredential oAuthCredential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );
      UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(oAuthCredential);
      await FirestoreService().saveUserInfo(userCredential: userCredential);
      onSuccess();
    } on FirebaseAuthException catch (e) {
      onError(e.message ?? "Login failed");
    }
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
    required Function(UserCredential userCredential) onSuccess,
    required Function(String message) onError,
  }) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      onSuccess(userCredential);
    } on FirebaseAuthException catch (error) {
      onError(error.message ?? 'Login failed');
    }
  }

  Future<void> signupWithEmailAndPassword({
    required String email,
    required String password,
    required Function(UserCredential userCredential) onSuccess,
    required Function(String message) onError,
  }) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await FirestoreService().saveUserInfo(userCredential: userCredential);
      onSuccess(userCredential);
    } on FirebaseAuthException catch (error) {
      onError(error.message ?? 'Signup failed');
    }
  }

  Future<void> signOut({
    Function? onSuccess,
    Function(String message)? onError,
  }) async {
    try {
      await _firebaseAuth.signOut();
      if (onSuccess != null) onSuccess();
    } on FirebaseAuthException catch (error) {
      if (onError != null) onError(error.message ?? "Signout failed");
    }
  }
}
