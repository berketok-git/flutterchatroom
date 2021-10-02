import 'package:chatme/auth/widget/auth_form_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthRoute extends StatefulWidget {
  @override
  _AuthRouteState createState() => _AuthRouteState();
}

class _AuthRouteState extends State<AuthRoute> {
  final _auth = FirebaseAuth.instance;
  final _database = FirebaseFirestore.instance;
  var _isLoading = false;

  void _submitAuthForm(
    String email,
    String password,
    String username,
    bool isLogin,
  ) async {
    Future<UserCredential> userCredsFuture;

    if (isLogin) {
      userCredsFuture = _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } else {
      userCredsFuture = _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    }

    setState(() => _isLoading = true);

    try {
      UserCredential userCredential = await userCredsFuture;
      final uid = userCredential.user?.uid;

      if (uid == null) {
        throw Exception('User not created. Try again later!');
      }

      if (!isLogin)
        await _database.collection('users').doc(uid).set({
          'email': email,
          'username': username,
        });
    } on FirebaseAuthException catch (error) {
      String? message = 'An error occurred, please check you credentials!';

      if (error.message != null && error.message!.isNotEmpty)
        message = error.message ?? message;

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).errorColor,
      ));
    } catch (error) {
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.toString()),
        backgroundColor: Theme.of(context).errorColor,
      ));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthFormWidget(
        submitFunction: _submitAuthForm,
        isLoading: _isLoading,
      ),
    );
  }
}
