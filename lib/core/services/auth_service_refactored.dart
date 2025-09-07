import 'package:ecommerce/core/services/base_service.dart';
import 'package:ecommerce/core/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthRepository {
  Future<UserModel?> signInWithEmail(String email, String password);
  Future<UserModel?> signUpWithEmail(
    String email,
    String password,
    String name,
  );
  Future<UserModel?> signInWithGoogle();
  Future<UserModel?> signInWithFacebook();
  Future<void> signOut();
  UserModel? getCurrentUser();
  Stream<UserModel?> get authStateChanges;
}

class AuthRepositoryImpl extends BaseService implements AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // v7+ uses a singleton:
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  final FacebookAuth _facebookAuth = FacebookAuth.instance;

  @override
  Future<UserModel?> signInWithEmail(String email, String password) async {
    return handleError(() async {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        return UserModel.fromFirebaseUser(credential.user!);
      }
      return null;
    });
  }

  @override
  Future<UserModel?> signUpWithEmail(
    String email,
    String password,
    String name,
  ) async {
    return handleError(() async {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        await credential.user!.updateDisplayName(name);

        final userModel = UserModel(
          id: credential.user!.uid,
          email: email,
          name: name,
          createdAt: DateTime.now(),
        );

        return userModel;
      }
      return null;
    });
  }

  @override
  Future<UserModel?> signInWithGoogle() async {
    return handleError(() async {
      // REQUIRED on v7+: initialize before using.
      // Pass clientId/serverClientId here if you have them configured (recommended for iOS/web).
      await _googleSignIn.initialize();

      // Try a silent/lightweight auth first (if the platform supports it).
      GoogleSignInAccount? account;
      final maybeFuture = _googleSignIn.attemptLightweightAuthentication();
      if (maybeFuture != null) {
        account = await maybeFuture;
      }

      // If still not signed in, start the interactive flow.
      if (account == null) {
        if (_googleSignIn.supportsAuthenticate()) {
          account = await _googleSignIn.authenticate();
        } else {
          // On platforms where authenticate() isn’t supported (notably certain web setups),
          // you must use the platform-specific button/flow from the web SDK.
          throw Exception(
            'Google Sign-In not supported via authenticate() on this platform. '
            'Use the platform-provided button/flow for web.',
          );
        }
      }

      // v7+: GoogleSignInAuthentication only provides idToken.
      final googleAuth = account.authentication;
      if (googleAuth.idToken == null) {
        throw Exception('Google Sign-In failed: missing ID token.');
      }

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final authCredential = await _auth.signInWithCredential(credential);
      if (authCredential.user != null) {
        return UserModel.fromFirebaseUser(authCredential.user!);
      }
      return null;
    });
  }

  @override
  Future<UserModel?> signInWithFacebook() async {
    return handleError(() async {
      final loginResult = await _facebookAuth.login();
      if (loginResult.status != LoginStatus.success) return null;

      final credential = FacebookAuthProvider.credential(
        // flutter_facebook_auth uses tokenString
        loginResult.accessToken!.tokenString,
      );

      final authCredential = await _auth.signInWithCredential(credential);
      if (authCredential.user != null) {
        return UserModel.fromFirebaseUser(authCredential.user!);
      }
      return null;
    });
  }

  @override
  Future<void> signOut() async {
    return handleError(() async {
      await Future.wait([
        _auth.signOut(),
        // Sign out federated providers too.
        _googleSignIn.signOut(),
        _facebookAuth.logOut(),
      ]);
    });
  }

  @override
  UserModel? getCurrentUser() {
    final user = _auth.currentUser;
    return user != null ? UserModel.fromFirebaseUser(user) : null;
  }

  @override
  Stream<UserModel?> get authStateChanges {
    return _auth.authStateChanges().map((user) {
      return user != null ? UserModel.fromFirebaseUser(user) : null;
    });
  }
}
