import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String uid;
  final String message;
  final String displayName;
  final Timestamp? time;

  Message({
    required this.uid,
    required this.message,
    required this.displayName,
    this.time,
  });

  factory Message.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return Message(
      uid: data?['uid'],
      message: data?['message'],
      displayName: data?['displayName'] ?? 'CoolName',
      time: data?['time'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'message': message,
      'displayName': displayName,
      'time': time ?? Timestamp.now(),
    };
  }
}

final messagesQuery = FirebaseFirestore.instance
    .collection('messages')
    .withConverter(
      fromFirestore: (snapshot, idx) => Message.fromFirestore(snapshot),
      toFirestore: (message, idx) => message.toFirestore(),
    )
    .orderBy('time', descending: true);
