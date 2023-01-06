import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

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
  TextEditingController textEditingController = TextEditingController();
  // StreamController<ErrorAnimationType>? errorController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // errorController = StreamController<ErrorAnimationType>();
  }

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
              children: [
                const Icon(Icons.pin_rounded,size: 29,),
                const SizedBox(width: 10,),
                Text(
                  "Manage Pin",
                    style: GoogleFonts.poppins(
                        textStyle: Theme.of(context).textTheme.headlineMedium,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: const Color.fromRGBO(0, 92, 179, 1)
                    ),
                ),
              ],
            ),
            Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 24,
                  ),
                  const Text('Old Pin',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(
                    height: 17,
                  ),
                  PinCodeTextField(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    appContext: context,
                    pastedTextStyle: TextStyle(
                      color: Colors.green.shade600,
                      fontWeight: FontWeight.bold,
                    ),
                    length: 4,
                    obscureText: true,
                    obscuringCharacter: '*',
                    blinkWhenObscuring: true,
                    animationType: AnimationType.fade,
                    validator: (v) {
                      if (v!.length < 3) {
                        return "Please enter pin";
                      } else {
                        return null;
                      }
                    },
                    pinTheme: PinTheme(
                      activeColor: Colors.white,
                      inactiveFillColor: Colors.white,
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 47,
                      fieldWidth: 75,
                      activeFillColor: Colors.white,
                      inactiveColor: Colors.white,
                    ),
                    cursorColor: Colors.black,
                    // enableActiveFill: true,
                    // errorAnimationController: errorController,
                    keyboardType: TextInputType.number,
                    boxShadows: const [
                      BoxShadow(
                        offset: Offset(0, 1),
                        color: Color.fromRGBO(237, 240, 243, 1),
                        blurRadius: 10,
                      )
                    ],
                    onChanged: (value) {
                      debugPrint(value);
                      setState(() {
                        oldPin = value;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  const Text('New Pin',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(
                    height: 17,
                  ),
                  PinCodeTextField(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    appContext: context,
                    pastedTextStyle: TextStyle(
                      color: Colors.green.shade600,
                      fontWeight: FontWeight.bold,
                    ),
                    length: 4,
                    obscureText: true,
                    obscuringCharacter: '*',
                    blinkWhenObscuring: true,
                    animationType: AnimationType.fade,
                    validator: (v) {
                      if (v!.length < 3) {
                        return "Please enter pin";
                      } else {
                        return null;
                      }
                    },
                    pinTheme: PinTheme(
                      activeColor: Colors.white,
                      inactiveFillColor: Colors.white,
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 47,
                      fieldWidth: 75,
                      activeFillColor: Colors.white,
                      inactiveColor: Colors.white,
                    ),
                    cursorColor: Colors.black,
                    // enableActiveFill: true,
                    // errorAnimationController: errorController,
                    keyboardType: TextInputType.number,
                    boxShadows: const [
                      BoxShadow(
                        offset: Offset(0, 1),
                        color: Color.fromRGBO(237, 240, 243, 1),
                        blurRadius: 10,
                      )
                    ],
                    onChanged: (value) {
                      debugPrint(value);
                      setState(() {
                        newPin = value;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  const Text('Confirm Pin',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(
                    height: 17,
                  ),
                  PinCodeTextField(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    appContext: context,
                    pastedTextStyle: TextStyle(
                      color: Colors.green.shade600,
                      fontWeight: FontWeight.bold,
                    ),
                    length: 4,
                    obscureText: true,
                    obscuringCharacter: '*',
                    blinkWhenObscuring: true,
                    animationType: AnimationType.fade,
                    validator: (v) {
                      if (v!.length < 3) {
                        return "Please enter pin";
                      } else if(newPin != confirmPin) {
                        return "Pin not matched";
                      }else {
                        return null;
                      }
                    },
                    pinTheme: PinTheme(
                      activeColor: Colors.white,
                      inactiveFillColor: Colors.white,
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 47,
                      fieldWidth: 75,
                      activeFillColor: Colors.white,
                      inactiveColor: Colors.white,
                    ),
                    cursorColor: Colors.black,
                    // enableActiveFill: true,
                    // errorAnimationController: errorController,
                    keyboardType: TextInputType.number,
                    boxShadows: const [
                      BoxShadow(
                        offset: Offset(0, 1),
                        color: Color.fromRGBO(237, 240, 243, 1),
                        blurRadius: 10,
                      )
                    ],
                    onChanged: (value) {
                      debugPrint(value);
                      setState(() {
                        confirmPin = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(0, 92, 179, 1 ),
                      ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {}
                        },
                        child: const Text('Update')))
              ],
            )
          ],
        ),
      ),
    );
  }
}
