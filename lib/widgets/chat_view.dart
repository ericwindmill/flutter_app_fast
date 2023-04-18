import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_fast/widgets/utils.dart';

import '../message.dart';

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
            return Scrollbar(
              child: ListView.builder(
                reverse: true,
                itemCount: snapshot.data!.size,
                itemBuilder: (BuildContext context, int idx) {
                  final message = snapshot.data!.docs[idx].data() as Message;
                  return ListTile(
                    title: Text(message.message),
                    subtitle: Text(
                        'from ${message.displayName} @ ${message.time!.toDate().toLocal().toString()}'),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class ChatViewScaffold extends StatelessWidget {
  final Widget child;

  ChatViewScaffold({super.key, required this.child});

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.userChanges(),
        builder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                child,
                Divider(
                  height: 40.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: const Border.fromBorderSide(BorderSide()),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'User: ${snapshot.data?.displayName ?? 'Loading...'}',
                            style: Theme.of(context).textTheme.labelSmall!,
                          ),
                          IconButton(
                            iconSize: 15,
                            icon: const Icon(Icons.refresh),
                            onPressed: () {
                              final displayName = generateRandomPlayerName();
                              FirebaseAuth.instance.currentUser!
                                  .updateDisplayName(displayName);
                            },
                          )
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            decoration: InputDecoration(
                              label: Text('Message'),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection('messages')
                                  .add(
                                    Message(
                                      uid: snapshot.data!.uid,
                                      displayName: snapshot.data!.displayName!,
                                      message: _controller.value.text,
                                    ).toFirestore(),
                                  );
                              _controller.clear();
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }
}
