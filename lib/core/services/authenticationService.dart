import 'package:Aol_docProvider/core/models/usermodel.dart';
import 'package:Aol_docProvider/core/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthenticationService {
  // final firebaseAuth variable

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create User object

  UserModel _userfromAuthentication(User user) {
    return user != null
        ? UserModel(
            uid: user.uid,
            userEmail: user.email ?? null,
            userPhoneNo: user.phoneNumber ?? null)
        : null;
  }

  // Stream if user is Signed in or Signed out
  Stream<UserModel> get user {
    return _auth.authStateChanges().map(_userfromAuthentication);
  }

  // Sign up using email password

  Future signupEmailId(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      await DatabaseService(
        userID: user.uid,
      ).updateUserData(
        folderName: user.email,
      );
      return _userfromAuthentication(user);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  // Sign in using emailId password

  Future signinEmailId(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      DatabaseService(
        userID: user.uid,
      );

      return _userfromAuthentication(user);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  // User Signs out

  Future signoutEmailId() async {
    try {
      await _auth.signOut();
      return _userfromAuthentication(null);
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  // Sign in with phone

  siginInwithPhone(
      {String phoneNo, String password, BuildContext context}) async {
    TextEditingController _otpContorller = new TextEditingController();

    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNo,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async {
          // Navigator.of(context).pop();
          UserCredential result = await _auth.signInWithCredential(credential);
          User user = result.user;
          DatabaseService(
            userID: user.uid,
          ).updateUserData(
            folderName: user.phoneNumber,
          );
          return _userfromAuthentication(user);
        },
        verificationFailed: (FirebaseAuthException exception) {
          print(exception);
        },
        codeSent: (String verificationId, [int forceResendingToken]) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Enter the OTP"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                        controller: _otpContorller,
                      )
                    ],
                  ),
                  actions: <Widget>[
                    FlatButton(
                        onPressed: () async {
                          final _otpContollerText = _otpContorller.text.trim();
                          AuthCredential credential =
                              PhoneAuthProvider.credential(
                                  verificationId: verificationId,
                                  smsCode: _otpContollerText);
                          UserCredential result =
                              await _auth.signInWithCredential(credential);
                          User user = result.user;

                          await DatabaseService(
                            userID: user.uid,
                          ).updateUserData(
                            folderName: user.phoneNumber,
                          );
                          Navigator.pop(context);
                          return _userfromAuthentication(user);
                        },
                        child: Text("confirm"))
                  ],
                );
              });
        },
        codeAutoRetrievalTimeout: (String verificationId) {});
  }
}
