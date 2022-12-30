import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../model/chatUser.dart';
import '../../providers/chat_provider.dart';
import 'conversationList.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  var _isInit = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didUpdateWidget
    super.didChangeDependencies();
    if (_isInit) {
      Provider.of<ChatProvider>(context).fetchUsers();
    }
    _isInit = false;
  }

  List<ChatUsers>? chatUsers;

  @override
  Widget build(BuildContext context) {
    var chatList = Provider.of<ChatProvider>(context).allUsers;
    if (chatList != null) {
      chatUsers = chatList
          .map<ChatUsers>((chats) => ChatUsers(
              id: chats['_id'],
              name: chats['lastname'] != null
                  ? chats['name'] + chats['lastname']
                  : chats['name'] ?? chats['chatName'],
              imageURL: chats['image'] != null
                  ? "https://api-aelix.mangoitsol.com/${chats['image']}"
                  : '',
              isRead: chats['readBy'].toString()))
          .toList();
      return Scaffold(
          appBar: AppBar(
            foregroundColor: Colors.blue,
            backgroundColor: Colors.white,
          ),
          body: SingleChildScrollView(
            child: ListView.builder(
              itemCount: chatUsers!.length,
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 16),
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      _isInit = true;
                    });
                    Navigator.pushNamed(context, '/chatDetail',
                        arguments: chatUsers![index]);
                  },
                  child: ConversationList(
                    name: chatUsers![index].name,
                    imageUrl: chatUsers![index].imageURL,
                    isMessageRead: chatUsers![index].isRead ?? '',
                    id: chatUsers![index].id,
                  ),
                );
              },
            ),
          ));
    } else {
      return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.blue,
          backgroundColor: Colors.white,
        ),
        body: const CircularProgressIndicator().centered(),
      );
    }
  }
}
