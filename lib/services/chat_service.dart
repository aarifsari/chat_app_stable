import 'package:chat_app/models/message.dart';

abstract class ChatService {
  Stream<List<Message>> getMessagesStream({
    required String currentUserId,
    required String otherUserId,
  });

  Future<void> sendMessage({
    required String senderId,
    required String receiverId,
    required String text,
  });
}
