import 'package:aelix/providers/auth_provider.dart';
import 'package:aelix/screens/wlcome_page/welcome.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  String email = "jhonmanager";
  String password = "123456";
  String error = "";
  bool changeButton = false;
  String isSignIn = 'initial';
  final _priceFocusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _priceFocusNode.dispose();
    super.dispose();
  }

  moveToHome(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      dynamic result;
      result = await Auth().signInWithEmail(email, password);
      if (result != 200) {
        setState(() {
          isSignIn = 'initial';
          error = 'please enter a valid email and password';
        });
        return;
      }
      if (!mounted) return;
      setState(() {
        isSignIn = 'completed';
        changeButton = true;
      });
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const Welcome(),
        ),
      );
    }
  }

  loginButton() {
    if (isSignIn == 'initial') {
      return const Text(
        "Login",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      );
    } else if (isSignIn == 'loading') {
      return const CircularProgressIndicator().centered();
    } else {
      return const Icon(
        Icons.done,
        color: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        decoration: const BoxDecoration(
                            color: Color.fromRGBO(0, 92, 179, 1),
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(99))),
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.55,
                        child: Image.asset('assets/images/login.png')),
                    const SizedBox(
                      height: 20.0,
                    ),
                    const Text(
                      'Manager or Counsellor Login',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Color.fromRGBO(0, 92, 179, 1)),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 32.0),
                      child: Column(
                        children: [
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter username';
                              }
                              return null;
                            },
                            initialValue: 'jhonmanager',
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              hintText: "Enter username",
                              labelText: "username",
                            ),
                            readOnly: isSignIn != 'initial',
                            onChanged: (value) {
                              email = value;
                              setState(() {});
                            },
                            onFieldSubmitted: (_) {
                              FocusScope.of(context).requestFocus(_priceFocusNode);
                            },
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter password';
                              }
                              return null;
                            },
                            readOnly: isSignIn != 'initial',
                            initialValue: '123456',
                            obscureText: true,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              hintText: "Enter password",
                              labelText: "Password",
                            ),
                            onChanged: (value) {
                              password = value;
                              setState(() {});
                            },
                            focusNode: _priceFocusNode,
                            onFieldSubmitted: (_) => {
                              setState(() {
                                isSignIn = 'loading';
                              }),
                              moveToHome(context)
                            },
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
                                      moveToHome(context)
                                    }
                                  : null,
                              child: AnimatedContainer(
                                  duration: const Duration(seconds: 1),
                                  width: 400,
                                  height: 50,
                                  alignment: Alignment.center,
                                  child: loginButton()),
                            ),
                          ),
                          const SizedBox(height: 12.0),
                          Text(
                            error,
                            style:
                                const TextStyle(color: Colors.red, fontSize: 20.0),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
