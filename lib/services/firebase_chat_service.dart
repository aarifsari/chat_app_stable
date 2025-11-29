import 'package:chat_app/models/message.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseChatService implements ChatService {
  FirebaseChatService._internal();

  static final FirebaseChatService _instance = FirebaseChatService._internal();

  factory FirebaseChatService() => _instance;

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String _conversationId(String userA, String userB) {
    final users = [userA, userB]..sort();
    return '${users[0]}_${users[1]}';
  }

  @override
  Stream<List<Message>> getMessagesStream({
    required String currentUserId,
    required String otherUserId,
  }) {
    final convId = _conversationId(currentUserId, otherUserId);

    return _db
        .collection('messages')
        .where('conversationId', isEqualTo: convId)
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Message.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }

  @override
  Future<void> sendMessage({
    required String senderId,
    required String receiverId,
    required String text,
  }) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    final convId = _conversationId(senderId, receiverId);

    final docRef = _db.collection('messages').doc();

    final message = Message(
      id: docRef.id,
      conversationId: convId,
      senderId: senderId,
      receiverId: receiverId,
      text: trimmed,
      timestamp: DateTime.now(),
    );

    await docRef.set(message.toMap());
  }
}
