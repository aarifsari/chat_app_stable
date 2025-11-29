import 'package:flutter/material.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  String? _currentUserId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args =
        ModalRoute.of(context)?.settings.arguments as Map<dynamic, dynamic>?;

    if (args != null && _currentUserId == null) {
      final id = args['currentUserId'];
      if (id is String && id.isNotEmpty) {
        _currentUserId = id;
      }
    }
  }

  void _signOut() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final current = _currentUserId ?? 'Undefined';

    final allUsers = List.generate(10, (index) => 'user_$index');

    final visibleUsers =
        allUsers.where((userId) => userId != _currentUserId).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats"),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'sign_out') {
                  _signOut();
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem<String>(
                  value: 'sign_out',
                  child: Text('Sign out'),
                ),
              ],
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    current,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: visibleUsers.length,
        padding: const EdgeInsets.all(12),
        itemBuilder: (context, index) {
          final userId = visibleUsers[index];

          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/chatDetail',
                arguments: {
                  'userId': userId,
                  'userName': userId,
                  'currentUserId': _currentUserId ?? 'user_me',
                },
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.blue.shade300,
                    child: Text(
                      userId.split('_').last,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userId,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Tap to open chat",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
