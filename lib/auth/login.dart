import 'package:chat_app/auth/signup.dart';
import 'package:chat_app/chat/chat_screen.dart';
import 'package:chat_app/homepage.dart';
import 'package:chat_app/utils/snacks.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  bool _isObscure = true;

  _loginUser(String email, String password) async {
    try {
      final result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (result.user != null) {
        Navigator.of(context).pushAndRemoveUntil(
            CupertinoPageRoute(builder: (context) => ChatScreen()),
            (route) => false);
        //showSuccessSnack("Logged in Successfully");
      } else {
        showErrorSnack("Something went wrong");
      }
    } on FirebaseAuthException catch (e) {
      showErrorSnack(e.message.toString());
    } catch (e) {
      showErrorSnack(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(
                  "https://imgs.search.brave.com/Sq0qOvuJLX4TC2T9tW-yqtkmLC_EchDCOKbC2nglgkw/rs:fit:266:225:1/g:ce/aHR0cHM6Ly90c2Uy/Lm1tLmJpbmcubmV0/L3RoP2lkPU9JUC54/SUFKS2dBVDJ4b0cz/WnhIeDN0dFVBSGFO/SyZwaWQ9QXBp"),
              fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('My Chat'),
          centerTitle: true,
        ),
        body: Form(
          key: _loginFormKey,
          child: Container(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.1,
                right: 20,
                left: 20),
            child: Column(
              children: [
                TextFormField(
                  style: TextStyle(color: Colors.white),
                  controller: _emailController,
                  decoration: InputDecoration(
                    fillColor: Colors.white30,
                    filled: true,
                    labelText: "Email",
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value != null &&
                        RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value)) {
                      return null;
                    } else {
                      return "Please enter valid email";
                    }
                    ;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      fillColor: Colors.white30,
                      filled: true,
                      labelText: "Password",
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(10)),
                      prefixIcon: Icon(Icons.password),
                      suffixIcon: GestureDetector(
                        child: Icon(Icons.visibility),
                        onLongPressStart: (val) {
                          setState(() {
                            _isObscure = false;
                          });
                        },
                        onLongPressEnd: (val) {
                          setState(() {
                            _isObscure = true;
                          });
                        },
                      )),
                  obscureText: _isObscure,
                  controller: _passwordController,
                  validator: (value) {
                    if (value != null && value.length > 7) {
                      return null;
                    } else {
                      return "Password should be greater than 8 character";
                    }
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_loginFormKey.currentState!.validate()) {
                      _loginUser(
                          _emailController.text, _passwordController.text);
                    }
                  },
                  child: const Text('LOGIN'),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SignupScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Dont have an account ? SIGN UP',
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
