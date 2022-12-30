import 'package:aelix/providers/auth_provider.dart';
import 'package:aelix/screens/wlcome_page/welcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
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
        final profile = Provider.of<Auth>(context, listen: false);
        profile.isAuthenticated = true;
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
    return Material(
        color: context.canvasColor,
        child: Form(
          key: _formKey,
          child: Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.network(
                  "https://aelix.mangoitsol.com/static/media/aelix-logo.fa5be6ee4f133e417cf57892724df96c.svg",
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width * 0.8,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Text(
                  'Manager or Counsellor Login',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800]),
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
                        height: 10.0,
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
                        height: 40.0,
                      ),
                      Material(
                        color: Colors.blue[900],
                        borderRadius: BorderRadius.circular(50),
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
                              width: changeButton ? 50 : 150,
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
        ));
  }
}
