import 'package:flutter/material.dart';
import '../../widgets/chat/chat_list_page.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.blue,
          backgroundColor: Colors.white,
          title: const Text('My Chats'),
        ),
        body: const ChatListPage());
  }
}
