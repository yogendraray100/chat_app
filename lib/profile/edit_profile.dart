import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit"),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Center(
            child: Container(
              height: 0.3 * size.width,
              width: 0.3 * size.width,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.withOpacity(0.3),
                border: Border.all(),
              ),
              child: Icon(Icons.add),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(hintText: "Name"),
                ),
                TextFormField(
                  decoration: InputDecoration(hintText: "Email"),
                ),
                TextFormField(
                  decoration: InputDecoration(hintText: "Password"),
                ),
                TextFormField(
                  decoration: InputDecoration(hintText: "Confirm Password"),
                ),
                ElevatedButton(onPressed: () {}, child: Text("Save"))
              ],
            ),
          )
        ],
      )),
    );
  }
}
