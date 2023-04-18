import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthGuard extends StatelessWidget {
  final Widget signedInWidget;
  final Widget signedOutWidget;

  const AuthGuard({
    Key? key,
    required this.signedInWidget,
    required this.signedOutWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return signedOutWidget;
        return signedInWidget;
      },
    );
  }
}
