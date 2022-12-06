import 'package:chat_app/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddPage extends StatefulWidget {
  final String? documentId;
  final String? title;

  const AddPage({super.key, this.documentId, this.title});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final user = FirebaseAuth.instance.currentUser;
  final TextEditingController _fieldController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.title != null) {
      _fieldController.text = widget.title!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.documentId == null ? "ADD" : "Update")),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _fieldController,
              validator: (val) {
                if (val != null && val.length > 1) {
                  return null;
                } else {
                  return "text should be bigger";
                }
              },
            ),
            ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    if (widget.documentId == null) {
                      await FirebaseFirestore.instance.collection("todos").add({
                        "name": _fieldController.text,
                        "created_by": user!.uid,
                      });
                    } else {
                      await FirebaseFirestore.instance
                          .collection("todos")
                          .doc(widget.documentId)
                          .update({
                        "name": _fieldController.text,
                        "created_by": user!.uid,
                      });
                    }
                    Navigator.pop(AppSettings.navigatorKey.currentContext!);
                  }
                },
                child: Text(widget.documentId != null ? "Update" : "Add"))
          ],
        ),
      ),
    );
  }
}
