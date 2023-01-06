import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../model/chatUser.dart';
import '../../providers/chat_provider.dart';
import '../../widgets/chat/conversationList.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  ChatListPageState createState() => ChatListPageState();
}

class ChatListPageState extends State<ChatListPage> {
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
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(Icons.chat,size: 29,),
                  const SizedBox(width: 10,),
                  Text(
                    "Chat",
                      style: GoogleFonts.poppins(
                          textStyle: Theme.of(context).textTheme.headlineMedium,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: const Color.fromRGBO(0, 92, 179, 1)
                      ),
                  ),
                ],
              ),
              // TextButton(onPressed: () {}, child: Text(
              //   '#Create Personal Chat',  style: GoogleFonts.poppins(
              //     textStyle: Theme.of(context).textTheme.headlineMedium,
              //     fontSize: 18,
              //     fontWeight: FontWeight.w400,
              //     color: const Color.fromRGBO(0, 92, 179, 1)
              // ),
              // )),
              ListView.builder(
                itemCount: chatUsers!.length,
                shrinkWrap: true,
                padding: const EdgeInsets.only(top: 8),
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
                    child: Card(
                      child: ConversationList(
                        name: chatUsers![index].name,
                        imageUrl: chatUsers![index].imageURL,
                        isMessageRead: chatUsers![index].isRead ?? '',
                        id: chatUsers![index].id,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );
    } else {
      return const CircularProgressIndicator().centered();
    }
  }
}
