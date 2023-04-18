import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_fast/widgets/utils.dart';

class SignInButtonView extends StatelessWidget {
  const SignInButtonView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          await FirebaseAuth.instance.signInAnonymously();
          final displayName = generateRandomPlayerName();
          await FirebaseAuth.instance.currentUser!
              .updateDisplayName(displayName);
        },
        child: const Text('Sign In'),
      ),
    );
  }
}
