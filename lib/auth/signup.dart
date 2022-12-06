import 'package:chat_app/utils/snacks.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _signupFormKey = GlobalKey<FormState>();

  _signupUser(String email, String password) async {
    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        FirebaseFirestore.instance
            .collection("users")
            .doc(userCredential.user!.uid)
            .set(
          {
            "name": _nameController.text,
            "email": _emailController.text,
            "password": _passwordController.text
          },
        );
        showSuccessSnack("User Created Successfully");

        if (kDebugMode) print(userCredential.user?.email);
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
          automaticallyImplyLeading: false,
          title: Text("SIGN UP"),
          centerTitle: true,
        ),
        body: Form(
          key: _signupFormKey,
          child: Column(
            children: [
              SizedBox(
                height: 5,
              ),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                    fillColor: Colors.white30,
                    filled: true,
                    labelText: "Name",
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
                validator: (value) {
                  if (value != null && value.length >= 3) {
                    return null;
                  } else {
                    return "Name should be greater than three characters";
                  }
                  ;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: InputDecoration(
                    fillColor: Colors.white30,
                    filled: true,
                    labelText: "Email",
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
                controller: _emailController,
                validator: (value) {
                  if (value != null &&
                      RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value)) {
                    return null;
                  } else {
                    return "please enter valid email";
                  }
                  ;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: InputDecoration(
                    fillColor: Colors.white30,
                    filled: true,
                    labelText: "Password",
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
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
                    if (_signupFormKey.currentState!.validate()) {
                      _signupUser(
                          _emailController.text, _passwordController.text);
                    }
                  },
                  child: const Text('SIGN UP')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Already have an account',
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
