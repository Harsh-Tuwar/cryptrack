import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? onAuthChanged() {
    return _firebaseAuth.currentUser;
  }

  Future<User?> signInWithEmailPassword(String email, String password) async {
    UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);

    return result.user;
  }

  FirebaseAuth getAuthInstace() {
    return _firebaseAuth;
  }

  Future<User?> signInWithGoogle() async {
    await _googleSignIn.signOut();
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await _firebaseAuth.signInWithCredential(credential);

    User? user = _firebaseAuth.currentUser;

    return user;
  }

  Future<bool> isLoggedIn() async {
    return _firebaseAuth.currentUser != null;
  }

  Future<User?> signUp(
    String email,
    String password,
    String name,
  ) async {
    UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return result.user;
  }

  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  Future<void> signOut() {
    return Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }
}
