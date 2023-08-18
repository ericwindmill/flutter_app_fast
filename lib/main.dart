import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_fast/firebase_options.dart';
import 'package:generic_social_widgets/generic_social_widgets.dart';

import 'message.dart';

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

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'User: ${snapshot.data?.uid}',
              ),
            ),
            // Step 4
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: messagesQuery.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  return ListView.builder(
                    reverse: true,
                    itemCount: snapshot.data!.size,
                    itemBuilder: (BuildContext context, int idx) {
                      final message =
                          snapshot.data!.docs[idx].data() as Message;
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ChatBubble(text: message.message),
                      );
                    },
                  );
                },
              ),
            ),
            // Step 5
            ChatTextInput(
              onSend: (message) {
                FirebaseFirestore.instance.collection('messages').add(
                      Message(
                        uid: snapshot.data!.uid,
                        message: message,
                      ).toFirestore(),
                    );
              },
            ),
          ],
        );
      },
    );
  }
}
