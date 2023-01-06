import 'package:aelix/providers/classes_provider.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class ManageClass extends StatefulWidget {
  const ManageClass({Key? key}) : super(key: key);

  @override
  State<ManageClass> createState() => _ManageClassState();
}

class _ManageClassState extends State<ManageClass> {
  var _isInit = true;
  String? className;
  final _formKey = GlobalKey<FormState>();

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
      Provider.of<Classes>(context).fetchClasses();
    }
    _isInit = false;
  }

  showAddClassDialog(id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder:
              (BuildContext context, void Function(void Function()) setState) {
            return AlertDialog(
                title: Text(
                    id == null || id == '' ? 'Add New Class' : 'update class'),
                content: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter ClassName';
                      }
                      return null;
                    },
                    initialValue: className,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      hintText: "Enter name",
                      labelText: "Class Name",
                    ),
                    onChanged: (value) {
                      className = value;
                      setState(() {});
                    },
                    onFieldSubmitted: (_) => {
                      if (_formKey.currentState!.validate())
                        {
                          if (id == null || id == '')
                            {
                              addNewClass({
                                "className": "class ${className![className!.length - 1]
                                    .toUpperCase()}"
                              })
                            }
                          else
                            {
                              updateClass(id, {
                                "className": "class ${className![className!.length - 1]
                                    .toUpperCase()}"
                              })
                            }
                        }
                    },
                  ),
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel')),
                  TextButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (id == null || id == '') {
                            addNewClass({
                              "className": className![className!.length - 1]
                                  .toUpperCase()
                            });
                          } else {
                            updateClass(id, {
                              "className": className![className!.length - 1]
                                  .toUpperCase()
                            });
                          }
                        }
                      },
                      child: const Text('Submit'))
                ]);
          },
        );
      },
    );
  }

  addNewClass(data) async {
    var result = await Provider.of<Classes>(context, listen: false)
        .addClassToDatabase(data);
    if (!mounted) return;
    if (result['message'] == 'class create successfully') {
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        messageSize: 20,
        message: "class added successfully",
        duration: const Duration(seconds: 3),
        leftBarIndicatorColor: Colors.green,
      ).show(context).then((value) => Navigator.pop(context));
    } else if (result['message'] == 'class already exists') {
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        messageSize: 20,
        message: "Class already exist",
        duration: const Duration(seconds: 3),
        leftBarIndicatorColor: Colors.red,
      ).show(context);
    } else {
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        messageSize: 20,
        message: "Classname must be start with class then space ex: 'class G'",
        duration: const Duration(seconds: 3),
        leftBarIndicatorColor: Colors.red,
      ).show(context);
    }
  }

  updateClass(id, data) async {
    var result = await Provider.of<Classes>(context, listen: false)
        .updateClass(id, data);
    if (!mounted) return;
    if (result == 200) {
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        messageSize: 20,
        message: "class updated successfully",
        duration: const Duration(seconds: 3),
        leftBarIndicatorColor: Colors.green,
      ).show(context).then((value) => Navigator.pop(context));
    } else {
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        messageSize: 20,
        message: "Class already exist",
        duration: const Duration(seconds: 3),
        leftBarIndicatorColor: Colors.red,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<Classes>(context).fetchClasses();
    if (Provider.of<Classes>(context).classesData.isNotEmpty) {
      var classes = Provider.of<Classes>(context).classesData;
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
                      'Manage Classes',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                TextButton(
                    onPressed: () {
                      showAddClassDialog('');
                    },
                    child: const Text(
                      'Add New Class',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ))
              ],
            ),
            DataTable(
                dataRowHeight: 110,
                columnSpacing: MediaQuery.of(context).size.width * 0.5,
                columns: const [
                  DataColumn(
                    label: Text('Class Name'),
                  ),
                  DataColumn(
                    label: Text('Action'),
                  ),
                ],
                rows: classes
                    .map<DataRow>((data) => DataRow(cells: [
                          DataCell(Text(data['className'])),
                          DataCell(Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    className = data['className'];
                                  });
                                  showAddClassDialog(data['_id']);
                                },
                                icon: const Icon(Icons.edit_note),
                              ),
                            ],
                          ))
                        ]))
                    .toList())
          ],
        ),
      ));
    } else {
      return const CircularProgressIndicator().centered();
    }
  }
}
