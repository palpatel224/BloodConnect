import 'package:bloodconnect/login/0_data/models/auth_model.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


abstract class AuthFirebaseService {
  Future<Either<String,String>> signup(UserSignUpReq user);
  Future<Either<String,String>> signin(UserSignInReq user);
  Future<Either<String,String>> signInWithGoogle();
  Future<bool> isLoggedIn();
  Future<Either<String,Map<String,dynamic>>> getUser();
}

class AuthFirebaseServiceImpl implements AuthFirebaseService {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn; // Initialize GoogleSignIn

  AuthFirebaseServiceImpl({FirebaseAuth? auth, GoogleSignIn? googleSignIn})
      : _auth = auth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  @override
  Future<Either<String, String>> signup(UserSignUpReq user) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: user.email ?? '',
        password: user.password ?? '',
      );

      await result.user?.updateDisplayName(user.name);

      return const Right('Sign up was successful');
    } on FirebaseAuthException catch (e) {
      return Left(e.message ?? 'Sign up failed');
    }
  }

  @override
  Future<Either<String, String>> signin(UserSignInReq user) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: user.email ?? '',
        password: user.password ?? '',
      );
      return const Right('Sign in was successful');
    } on FirebaseAuthException catch (e) {
      return Left(e.message ?? 'Sign in failed');
    }
  }

  @override
  Future<Either<String, String>> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return Left('Google sign in aborted');
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google [UserCredential]
      await _auth.signInWithCredential(credential);

      return const Right('Google sign in was successful');
    } on FirebaseAuthException catch (e) {
      return Left(e.message ?? 'Google sign in failed');
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    return _auth.currentUser != null;
  }

  @override
  Future<Either<String, Map<String, dynamic>>> getUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        return Right({
          'uid': user.uid,
          'email': user.email,
          'displayName': user.displayName,
        });
      }
      return const Left('No user found');
    } catch (e) {
      return Left(e.toString());
    }
  }
}
