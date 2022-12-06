import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DummyPage extends StatefulWidget {
  const DummyPage({super.key});

  @override
  State<DummyPage> createState() => _DummyPageState();
}

class _DummyPageState extends State<DummyPage> {
  final TextEditingController _fieldController = TextEditingController();
  final GlobalKey<FormState> _addFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("NewPage"),
      ),
      body: Form(
        key: _addFormKey,
        child: Column(
          children: [
            TextFormField(
              controller: _fieldController,
              validator: (value) {
                if (value != null && value.length > 2) {
                  return null;
                } else {
                  return "text should be greater than 8 character";
                }
              },
            ),
            ElevatedButton(
                onPressed: () async {
                  if (_addFormKey.currentState!.validate()) {
                    await FirebaseFirestore.instance
                        .collection("todos")
                        .add({"name": _fieldController.text});
                    Navigator.pop(context);
                  }
                },
                child: Text("ADD"))
          ],
        ),
      ),
    );
  }
}
