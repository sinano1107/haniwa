import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SigninViewModel extends ChangeNotifier {
  final _progressAction = StreamController<ProgressEvent>();
  StreamController<ProgressEvent> get progressAction => _progressAction;

  final _googleSigninAction = StreamController<GoogleSigninEvent>();
  StreamController<GoogleSigninEvent> get googleSigninAction =>
      _googleSigninAction;

  // Googleサインインを開始
  Future<void> startGoogleSignin() async {
    try {
      _progressAction.sink.add(ProgressEvent(pleaseOpen: true));
      final userCredential = await signInWithGoogle();
      print('サインインに成功');
      print('uid: ${userCredential.user.uid}');
      _googleSigninAction.sink.add(GoogleSigninEvent(isSucceed: true));
      _progressAction.sink.add(ProgressEvent(pleaseOpen: false));
    } catch (e) {
      print('サインインに失敗しました $e');
      _googleSigninAction.sink.add(GoogleSigninEvent(isSucceed: false));
      _progressAction.sink.add(ProgressEvent(pleaseOpen: false));
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  void dispose() {
    _progressAction.close();
    _googleSigninAction.close();
    super.dispose();
  }
}

class ProgressEvent {
  final pleaseOpen;
  ProgressEvent({this.pleaseOpen});
}

class GoogleSigninEvent {
  final isSucceed;
  GoogleSigninEvent({this.isSucceed});
}
