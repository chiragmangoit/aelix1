import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';

class TestMessage extends StatefulWidget {
  const TestMessage({Key? key}) : super(key: key);

  @override
  State<TestMessage> createState() => _TestMessageState();
}

class _TestMessageState extends State<TestMessage> {
  final SmsQuery _query = SmsQuery();
  List<SmsMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    accessMessage();
  }

  accessMessage() async {
    Map<Permission, PermissionStatus> statuses = await [
    Permission.location,
        Permission.storage,
      Permission.sms
    ].request();
    print(statuses[Permission.sms]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _messages.length,
          itemBuilder: (BuildContext context, int i) {
            var message = _messages[i];

            return ListTile(
              title: Text('${message.sender}'),
              subtitle: Text('${message.body}'),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var permission = await Permission.sms.status;
          print(permission);
          if (permission.isGranted) {
            final messages = await _query.querySms(
              kinds: [SmsQueryKind.inbox, SmsQueryKind.sent],
              // address: '+254712345789',
              count: 10,
            );
            debugPrint('sms inbox messages: ${messages.length}');

            setState(() => _messages = messages);
          } else {
            await Permission.sms.request();
          }
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
