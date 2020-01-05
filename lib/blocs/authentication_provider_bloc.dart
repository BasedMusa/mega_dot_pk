import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:mega_dot_pk/utils/constants.dart';
import 'package:mega_dot_pk/utils/globals.dart';
import 'package:mega_dot_pk/utils/mixins.dart';
import 'package:mega_dot_pk/utils/models.dart';

class AuthenticationProviderBLOC extends ChangeNotifier with AsyncTaskMixin {
  bool get isAuthorized => user == null;

  FirebaseUser _user;

  bool _codeSent = false;
  bool _autoRetrievalTimedOut = false;

  bool get codeSent => _codeSent;

  set codeSent(bool codeSent) {
    _codeSent = codeSent;
    notifyListeners();
  }

  bool get autoRetrievalTimedOut => _autoRetrievalTimedOut;

  set autoRetrievalTimedOut(bool autoRetrievalTimedOut) {
    _autoRetrievalTimedOut = autoRetrievalTimedOut;
    notifyListeners();
  }

  FirebaseUser get user => _user;

  set user(FirebaseUser user) {
    _user = user;
    notifyListeners();
  }

  Future<void> signOut() async {
    user = null;
    firebaseAuth.signOut();
  }

  Future<void> autoLogin() async => user = await firebaseAuth.currentUser();

  Future<void> signIn(String phoneNumber) async {
    try {
      codeSent = false;
      autoRetrievalTimedOut = false;
      taskStatus = AsyncTaskStatus.loading();

      PhoneVerificationCompleted _verificationCompleted =
          (AuthCredential authCredential) async {
        AuthResult authResult =
            await firebaseAuth.signInWithCredential(authCredential);

        user = authResult.user;

        taskStatus = AsyncTaskStatus.clear();
      };

      PhoneVerificationFailed _verificationFailed =
          (AuthException authException) {
        taskStatus = AsyncTaskStatus.clear();
      };

      PhoneCodeSent _codeSent =
          (String verificationId, [int forceResendingToken]) {
        codeSent = true;
        taskStatus = AsyncTaskStatus.clear();
      };

      PhoneCodeAutoRetrievalTimeout _codeAutoRetrievalTimeout =
          (String verificationId) {
        autoRetrievalTimedOut = true;
      };

      await firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: Constants.phoneAuthTimeoutDuration,
        verificationCompleted: _verificationCompleted,
        verificationFailed: _verificationFailed,
        codeSent: _codeSent,
        codeAutoRetrievalTimeout: _codeAutoRetrievalTimeout,
      );
    } catch (e) {
      print("AuthenticationProvider: SignIn: UnexpectedError: $e");
      taskStatus = AsyncTaskStatus.clear();
    }
  }
}
