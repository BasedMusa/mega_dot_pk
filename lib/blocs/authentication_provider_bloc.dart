import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:mega_dot_pk/utils/constants.dart';
import 'package:mega_dot_pk/utils/globals.dart';
import 'package:mega_dot_pk/utils/mixins.dart';
import 'package:mega_dot_pk/utils/models.dart';

class AuthenticationProviderBLOC extends ChangeNotifier with AsyncTaskMixin {
  bool get isAuthorized => user != null;

  String verificationID;

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
    firebaseAuth.signOut();
    user = null;
  }

  Future<void> autoLogin() async => user = await firebaseAuth.currentUser();

  Future<void> sendCodeToPhoneNumber(
      String phoneNumber,
      VoidCallback onCodeSent,
      AuthSuccessCallback onAuthenticationSuccessful) async {
    try {
      codeSent = false;
      verificationID = null;
      autoRetrievalTimedOut = false;
      taskStatus = AsyncTaskStatus.loading();

      PhoneVerificationCompleted _verificationCompleted =
          (AuthCredential authCredential) =>
              signInWithCredential(authCredential, onAuthenticationSuccessful);

      PhoneVerificationFailed _verificationFailed =
          (AuthException authException) {
        bool isNotCancelledByUser =
            !authException.message.contains("cancelled by");
        if (isNotCancelledByUser) {
          String errorMessage = authException.code == "invalidPhoneNumber"
              ? "Invalid phone number format."
              : authException.message;

          taskStatus = AsyncTaskStatus.error(errorMessage);
          print(
              "AuthenticationProviderBLOC: SignIn: PhoneVerificationFailed: ${authException.code} : ${authException.message}");
        } else
          taskStatus = AsyncTaskStatus.clear();
      };

      PhoneCodeSent _codeSent =
          (String verificationId, [int forceResendingToken]) {
        verificationID = verificationId;
        codeSent = true;
        taskStatus = AsyncTaskStatus.clear();
        onCodeSent();
      };

      PhoneCodeAutoRetrievalTimeout _codeAutoRetrievalTimeout =
          (String verificationId) {
        verificationID = verificationId;
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

  void verifyCode(String code, AuthSuccessCallback onAuthenticationSuccessful) {
    assert(verificationID != null);

    AuthCredential authCredential = PhoneAuthProvider.getCredential(
        verificationId: verificationID, smsCode: code);

    signInWithCredential(authCredential, onAuthenticationSuccessful);
  }

  Future<void> signInWithCredential(AuthCredential authCredential,
      AuthSuccessCallback onAuthenticationSuccessful) async {
    try {
      taskStatus = AsyncTaskStatus.loading();

      AuthResult authResult =
          await firebaseAuth.signInWithCredential(authCredential);

      FirebaseUser user = authResult.user;

      if (user != null) {
        taskStatus = AsyncTaskStatus.clear();
        _user = user;
        onAuthenticationSuccessful(user);
      }
    } catch (e) {
      String errorMessage = e.code == "ERROR_INVALID_VERIFICATION_CODE"
          ? "Invalid verification code. Please make sure to use the that is sent code via SMS."
          : e.message;
      taskStatus = AsyncTaskStatus.error(errorMessage);
      print(
          "AuthenticationProvider: SignInWithCredential: UnexpectedErrorOccurred: ${e.code} : ${e.message}");
    }
  }
}

typedef AuthSuccessCallback(FirebaseUser user);
