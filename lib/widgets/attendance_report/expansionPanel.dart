import 'package:aelix/providers/attendance_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'calender.dart';

class ExpansionItem extends StatefulWidget {

  const ExpansionItem({Key? key,}) : super(key: key);

  @override
  State<ExpansionItem> createState() => _ExpansionItemState();
}

class _ExpansionItemState extends State<ExpansionItem> {
  bool isExpand = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<Attendance>(context).records;
    return ListView.builder(
      itemCount: data.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: SizedBox(
              child: ExpansionTile(
                tilePadding: null,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        if (data[index]['studentId']['image'] != null &&
                            data[index]['studentId']['image'].contains('https'))
                          CircleAvatar(
                            backgroundImage:
                                NetworkImage(data[index]['studentId']['image']),
                          ),
                        if (data[index]['studentId']['image'] == null)
                          CircleAvatar(
                            backgroundColor: Colors.grey[400],
                            child:  Text(data[index]['studentId']['name'][0]),
                          ),
                        if (data[index]['studentId']['image'] != null &&
                            !data[index]['studentId']['image']
                                .contains('https'))
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                                "https://api-aelix.mangoitsol.com/${data[index]['studentId']['image']}"),
                          ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          "${data[index]['studentId']['name']} ${data[index]['studentId']['lastName']}",
                          style: GoogleFonts.poppins(
                              textStyle:
                                  Theme.of(context).textTheme.headlineMedium,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: const Color.fromRGBO(25, 40, 56, 1)),
                        ),
                      ],
                    ),
                    Row(
                      children: const [
                        Padding(
                          padding: EdgeInsets.only(right: 8, bottom: 11),
                          child: Text(
                            '.',
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w900,
                                color: Colors.blue),
                          ),
                        ),
                        Text('Present'),
                        Padding(
                          padding:
                              EdgeInsets.only(left: 8, right: 8, bottom: 11),
                          child: Text(
                            '.',
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w900,
                                color: Colors.red),
                          ),
                        ),
                        Text('Absent')
                      ],
                    )
                  ],
                ),
                children: [Calender(data: data[index]['attandan'], classId: data[index]['studentId']['assignClass'],)],
                onExpansionChanged: (newExpanded) {
                  setState(() {
                    isExpand = newExpanded;
                  });
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
