import 'package:flutter/material.dart';

class ChangePin extends StatefulWidget {
  const ChangePin({Key? key}) : super(key: key);

  @override
  State<ChangePin> createState() => _ChangePinState();
}

class _ChangePinState extends State<ChangePin> {
  final _formKey = GlobalKey<FormState>();
  var oldPin;
  var newPin;
  var confirmPin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Icon(Icons.pin_rounded),
                Text(
                  "Manage Pin",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
              ],
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24,),
                    const Text('Old Pin',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 17,),
                    TextFormField(
                      maxLength: 4,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Pin';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20))),
                        hintText: "Enter pin",
                        labelText: "Pin",
                      ),
                      onChanged: (value) {
                        oldPin = value;
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 24,),
                    const Text('New Pin',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 17,),
                    TextFormField(
                      maxLength: 4,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Pin';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20))),
                        hintText: "Enter pin",
                        labelText: "Pin",
                      ),
                      onChanged: (value) {
                        newPin = value;
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 24,),
                    const Text('Confirm Pin',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 17,),
                    TextFormField(
                      maxLength: 4,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Pin';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20))),
                        hintText: "Enter pin",
                        labelText: "Pin",
                      ),
                      onChanged: (value) {
                        confirmPin = value;
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton(onPressed: () {Navigator.pop(context);}, child: const Text('Cancel')),
                const SizedBox(width: 20,),
                ElevatedButton(onPressed: () {}, child: const Text('Update'))
              ],
            )
          ],
        ),
      ),
    );
  }
}
