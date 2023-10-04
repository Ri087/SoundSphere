import 'package:firebase_auth/firebase_auth.dart';

class User {
  late String uid;
  late String mail;
  late String displayName;
  late bool state; // Connecté ou non

  Future<dynamic> signIn(String emailAddress, String password) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailAddress,
          password: password
      );
      final user = credential.user;
      if (user != null) {
        uid = user.uid;
        if (user.email != null) {
          mail = user.email!;
        }

        displayName = user.displayName!;
      }


      return this;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      return false;
    }
  }

  Future<bool> signOut() async {
    await FirebaseAuth.instance.signOut();
    state = false;
    return true;
  }
}