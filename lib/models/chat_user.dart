class ChatUser {
  final String id;
  final String name;
  final String? email;
  final String? avatarUrl;

  const ChatUser({
    required this.id,
    required this.name,
    this.email,
    this.avatarUrl,
  });
}
