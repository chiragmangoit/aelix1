import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../providers/counsellor_provider.dart';

class EditCounsellor extends StatefulWidget {
  const EditCounsellor({Key? key}) : super(key: key);

  @override
  State<EditCounsellor> createState() => _EditCounsellorState();
}

class _EditCounsellorState extends State<EditCounsellor> {
  var _isInit = true;
  late ScrollController _scrollController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController();

  }

  @override
  void didChangeDependencies() {
    // TODO: implement didUpdateWidget
    super.didChangeDependencies();
    if (_isInit) {
      Provider.of<Counsellor>(context).fetchCounsellors();
    }
    _isInit = false;
  }

  deleteCounsellor(id) async {
    var result = await Provider.of<Counsellor>(context, listen: false)
        .deleteCounsellors(id);
    if (!mounted) return;
    if (result == 201) {
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        messageSize: 20,
        message: "counsellor deleted successfully",
        duration: const Duration(seconds: 3),
        leftBarIndicatorColor: Colors.green,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Provider.of<Counsellor>(context).fetchCounsellors();
    if (Provider.of<Counsellor>(context).counsellors != null) {
      var counsellorData = Provider.of<Counsellor>(context)
          .counsellors
          .where((council) => council['role']['name'] == "counsellor");
      return SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Icon(Icons.class_),
                    SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      'Counsellor',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/addCounsellor');
                    },
                    child: const Text(
                      'Add Counsellor',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ))
              ],
            ),
            Scrollbar(
              controller: _scrollController,
              thumbVisibility: true,
              child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                child: DataTable(
                    dataRowHeight: 110,
                    columns: const [
                      DataColumn(
                        label: Text('Name'),
                      ),
                      DataColumn(
                        label: Text('Class'),
                      ),
                      DataColumn(
                        label: Expanded(
                          child: Text(
                            'Assign Students',
                            softWrap: true,
                            maxLines: 2,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text('Action'),
                      ),
                    ],
                    rows: counsellorData
                        .map<DataRow>((data) => DataRow(cells: [
                              DataCell(
                                  Text(data['name'] + ' ' + data['lastname'])),
                              DataCell(Text(data['classId']['className']
                                  )),
                              DataCell(Text(data['studentCount'].toString())),
                              DataCell(Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/addCounsellor',
                                          arguments: data);
                                    },
                                    icon: const Icon(Icons.edit_note),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      deleteCounsellor(data['_id']);
                                    },
                                    icon:
                                        const Icon(Icons.delete_forever_outlined),
                                  )
                                ],
                              ))
                            ]))
                        .toList()),
              ),
            )
          ],
        ),
      ));
    } else {
      return const CircularProgressIndicator().centered();
    }
  }
}
