import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../providers/auth_provider.dart';

class ConversationList extends StatefulWidget {
  final String name;
  final String imageUrl;
  final String isMessageRead;
  final String id;

  const ConversationList(
      {super.key,
      required this.id,
      required this.name,
      required this.imageUrl,
      required this.isMessageRead});

  @override
  ConversationListState createState() => ConversationListState();
}

class ConversationListState extends State<ConversationList> {
  @override
  Widget build(BuildContext context) {
    if (widget.id != Auth.userid) {
      return Container(
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  if (widget.imageUrl.isNotEmpty)
                    CircleAvatar(
                      backgroundImage: NetworkImage(widget.imageUrl),
                      maxRadius: 30,
                    ),
                  if (widget.imageUrl.isEmpty)
                    CircleAvatar(
                      maxRadius: 30,
                      backgroundColor: Colors.grey[400],
                      child: Text(widget.name[0].capitalized),
                    ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.name,
                              style: GoogleFonts.poppins(
                                  textStyle: Theme.of(context).textTheme.headlineMedium,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: const Color.fromRGBO(19, 15, 38, 1)
                              ),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (widget.isMessageRead != '0')
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.green,
                        border: Border.all(width: 3, color: Colors.transparent),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(100)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Text(
                          widget.isMessageRead,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 20.0),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}
