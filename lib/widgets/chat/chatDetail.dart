import 'package:aelix/providers/chat_provider.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:velocity_x/velocity_x.dart';

import '../../model/chatMessageModel.dart';
import '../../providers/auth_provider.dart';

class ChatDetailPage extends StatefulWidget {
  const ChatDetailPage({super.key});

  @override
  ChatDetailPageState createState() => ChatDetailPageState();
}

class ChatDetailPageState extends State<ChatDetailPage> {
  late IO.Socket socket;
  List<ChatMessage>? messages;
  late final user;
  var args;
  var _isInit = true;
  String? chatId;
  final _controller = TextEditingController();
  final ScrollController _sc = ScrollController();
  bool _firstAutoscrollExecuted = false;
  bool _shouldAutoscroll = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSocket();
    _sc.addListener(_scrollListener);
  }

  @override
  void dispose() {
    socket.disconnect();
    socket.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    _sc.jumpTo(_sc.position.maxScrollExtent);
  }

  void _scrollListener() {
    _firstAutoscrollExecuted = true;

    if (_sc.hasClients && _sc.position.pixels == _sc.position.maxScrollExtent) {
      _shouldAutoscroll = true;
    } else {
      _shouldAutoscroll = false;
    }
  }

  accessChat(data) async {
    var result = await Provider.of<ChatProvider>(context).accessChat(data);
    return result;
  }

  initSocket() {
    socket = IO.io('http://103.127.29.85:4001', <String, dynamic>{
      'autoConnect': false,
      'transports': ["websocket"],
    });
    socket.connect();
    // socket.onAny((eventName, args) => {print(eventName)});
    socket.onConnect((_) {
      print('Connection established');
      socket.emit("setup", Auth.userid);
    });
    socket.on('message recieved', (newMessage) {
      Provider.of<ChatProvider>(context, listen: false)
          .getNewMessage(newMessage);
      setState(() {
        _scrollToBottom();
      });
    });
    socket.on('count', (newMessage) {
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        messageSize: 20,
        message: "You have recieved new message",
        duration: const Duration(seconds: 3),
        leftBarIndicatorColor: Colors.green,
      ).show(context);
    });
    socket.onDisconnect((_) => {print('Disconnected')});
    socket.onConnectError((err) => print(err));
    socket.onError((err) => print(err));
  }

  sendMessage(messg) async {
    if (messg.isEmpty) return;
    Map messageMap = {
      'content': messg,
      'senderId': Auth.userid,
      'chatId': chatId,
    };
    var result = await Provider.of<ChatProvider>(context, listen: false)
        .sendMessage(messageMap);
    socket.emit('message', [result]);
    if (!mounted) return;
    var data = Provider.of<ChatProvider>(context, listen: false)
        .allUsers
        .where((user) => user['_id'] != Auth.userid)
        .toList();
    setState(() {
      _scrollToBottom();
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didUpdateWidget
    super.didChangeDependencies();
    setState(() {
      if (_sc.hasClients && _shouldAutoscroll) {
        _scrollToBottom();
      }

      if (!_firstAutoscrollExecuted && _sc.hasClients) {
        _scrollToBottom();
      }
    });
    if (_isInit) {
      args = ModalRoute.of(context)!.settings.arguments;
      var res = accessChat({'recieverId': args.id, 'userId': Auth.userid});
      res.then((chatData) => {
            setState(() {
              chatId = chatData['_id'];
            }),
            Provider.of<ChatProvider>(context, listen: false)
                .fetchMessages(chatData['_id'])
          });
      setState(() {});
    }
    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    var msg = Provider.of<ChatProvider>(context).userMessages;
    if (msg != null) {
      messages = msg
          .map<ChatMessage>((data) => ChatMessage(
              messageContent: data['content'],
              messageType:
                  data['sender']['_id'] == Auth.userid ? 'sender' : 'receiver'))
          .toList();
      return Scaffold(
          appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            flexibleSpace: SafeArea(
              child: Container(
                padding: const EdgeInsets.only(right: 16),
                child: Row(
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    if (args.imageURL != '')
                      CircleAvatar(
                        backgroundImage: NetworkImage(args!.imageURL),
                        maxRadius: 20,
                      ),
                    if (args.imageURL == '')
                      CircleAvatar(
                        maxRadius: 20,
                        backgroundColor: Colors.grey[400],
                        child: Text(args.name[0]),
                      ),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            args.name,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.82,
                  child: ListView.builder(
                    controller: _sc,
                    itemCount: messages!.length,
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.only(
                            left: 14, right: 14, top: 10, bottom: 10),
                        child: Align(
                          alignment: (messages![index].messageType == "receiver"
                              ? Alignment.topLeft
                              : Alignment.topRight),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  messages![index].messageType == "receiver"
                                      ? const BorderRadius.only(
                                          bottomLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                          bottomRight: Radius.circular(10))
                                      : const BorderRadius.only(
                                          bottomLeft: Radius.circular(10),
                                          topLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10)),
                              color: (messages![index].messageType == "receiver"
                                  ? Colors.grey.shade200
                                  : Colors.blue[200]),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              messages![index].messageContent,
                              style: const TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    padding:
                        const EdgeInsets.only(left: 10, bottom: 10, top: 10),
                    height: MediaQuery.of(context).size.height * 0.08,
                    width: double.infinity,
                    color: Colors.white,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            decoration: const InputDecoration(
                                hintText: "Write message...",
                                hintStyle: TextStyle(color: Colors.black54),
                                border: InputBorder.none),
                            onSubmitted: (val) {
                              var messg = _controller.text.trim();
                              sendMessage(messg);
                              _controller.clear();
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        FloatingActionButton(
                          onPressed: () {
                            print(msg);
                            var messg = _controller.text.trim();
                            sendMessage(messg);
                            _controller.clear();
                          },
                          backgroundColor: Colors.blue,
                          elevation: 0,
                          child: const Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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
