import 'package:aelix/widgets/change_pin.dart';
import 'package:flutter/material.dart';

import '../../providers/keys.dart';

class Pin extends StatelessWidget {
  const Pin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue,
      ),
      body: Scaffold(
          key: scaffoldKeyPin,
          body: const ChangePin()),
    );
  }
}
