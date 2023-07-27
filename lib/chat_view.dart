import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:generic_social_widgets/generic_social_widgets.dart';

import 'message.dart';

class ChatView extends StatelessWidget {
  const ChatView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChatViewScaffold(
      child: Expanded(
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
                final message = snapshot.data!.docs[idx].data() as Message;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ChatBubble(text: message.message),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class ChatViewScaffold extends StatelessWidget {
  final Widget child;

  const ChatViewScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        return Column(
          children: [
            child,
            Divider(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'User: ${snapshot.data?.uid}',
                  ),
                ),
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
            )
          ],
        );
      },
    );
  }
}
