import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/classes_provider.dart';

class AddClass extends StatefulWidget {
  const AddClass({Key? key}) : super(key: key);

  @override
  State<AddClass> createState() => _AddClassState();
}

class _AddClassState extends State<AddClass> {
  final _formKey = GlobalKey<FormState>();
  var className;

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
                          addNewClass({
                            "className":
                                "class ${className![className!.length - 1].toUpperCase()}"
                          })
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
                          addNewClass({
                            "className":
                                className![className!.length - 1].toUpperCase()
                          });
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

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          showAddClassDialog('');
        },
        child: const Text(
          'Add New Class',
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
        ));
  }
}
