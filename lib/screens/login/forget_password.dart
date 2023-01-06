import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ForgotPasswordPageState createState() => ForgotPasswordPageState();
}

class ForgotPasswordPageState extends State<ForgotPasswordPage> {
  String email = "";
  String error = "";
  String isSignIn = 'initial';

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
          color: context.canvasColor,
          child: Column(
            children: [
              Container(
                  decoration: const BoxDecoration(
                      color: Color.fromRGBO(0, 92, 179, 1),
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(99))),
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Image.asset('assets/images/OBJECTS.png')),
              const SizedBox(
                height: 20.0,
              ),
              const Text(
                'Forgot Password',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Color.fromRGBO(0, 92, 179, 1)),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Form(
                key: _formKey,
                child: Align(
                  alignment: Alignment.center,
                  child:  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 32.0),
                    child: Column(
                      children: [
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter email';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                            hintText: "Enter email",
                            labelText: "Email",
                          ),
                          readOnly: isSignIn != 'initial',
                          onChanged: (value) {
                            email = value;
                            setState(() {});
                          },
                          onFieldSubmitted: (_) {},
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Material(
                          color: Colors.blue[900],
                          borderRadius: BorderRadius.circular(10),
                          child: InkWell(
                            onTap: () => _formKey.currentState!.validate()
                                ? {
                              setState(() {
                                isSignIn = 'loading';
                              }),
                              // moveToHome(context)
                            }
                                : null,
                            child: AnimatedContainer(
                                duration: const Duration(seconds: 1),
                                width: 400,
                                height: 50,
                                alignment: Alignment.center,
                                child: const Text(
                                  "Submit",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                )),
                          ),
                        ),
                        const SizedBox(height: 12.0),
                        Text(
                          error,
                          style: const TextStyle(
                              color: Colors.red, fontSize: 20.0),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
