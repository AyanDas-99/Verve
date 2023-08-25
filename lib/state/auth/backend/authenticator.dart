import 'package:flutter/foundation.dart' show immutable;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:verve/state/auth/models/auth_result.dart';
import 'package:verve/state/user_info/typedefs/user_id.dart';

@immutable
class Authenticator {
  UserId? get userId => FirebaseAuth.instance.currentUser?.uid;

  String get displayName =>
      FirebaseAuth.instance.currentUser?.displayName ?? '';

  String? get email => FirebaseAuth.instance.currentUser?.email;

  String? get photoUrl => FirebaseAuth.instance.currentUser?.photoURL;

  bool get isLoggedIn => userId != null;

  // Google auth
  Future<AuthResult> loginWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn().onError((error, stackTrace) async {
      print(error);
      return null;
    });
    if (googleSignInAccount == null) {
      return AuthResult.aborted;
    }
    final googleAuth = await googleSignInAccount.authentication;
    final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      return AuthResult.success;
    } catch (e) {
      return AuthResult.failure;
    }
  }

  // Log out
  Future<void> logOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }
}
