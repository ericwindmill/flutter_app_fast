import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_fast/firebase_options.dart';
import 'package:flutter_app_fast/chat_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const ChatPage(),
    );
  }
}

class ChatPage extends StatelessWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Googles Greatest Chat App'),
        centerTitle: false,
        actions: [
          ElevatedButton(
            onPressed: () async {
              final auth = FirebaseAuth.instance;
              if (auth.currentUser != null) {
                await auth.signOut();
              } else {
                await auth.signInAnonymously();
              }
            },
            child: Text(
              'Log In Or Out',
            ),
          ),
        ],
      ),
      body: ChatView(),
    );
  }
}
