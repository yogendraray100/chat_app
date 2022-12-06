import 'dart:io';
import 'package:chat_app/main.dart';
import 'package:chat_app/utils/snacks.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _nameController = TextEditingController();
  XFile? _pickedImage;

  _pickImage(ImageSource imageSource) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: imageSource);
    _pickedImage = image;
    if (mounted) setState(() {});
    Navigator.of(AppSettings.navigatorKey.currentContext!).pop();
  }

  _handleImage() async {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: () {
                  _pickImage(ImageSource.camera);
                },
                title: Text("Camera"),
                leading: Icon(Icons.camera),
              ),
              ListTile(
                onTap: () {
                  _pickImage(ImageSource.gallery);
                },
                title: const Text("Gallery"),
                leading: const Icon(Icons.photo),
              )
            ],
          );
        });
  }

  _updateProfile() async {
    final ref = FirebaseStorage.instance
        .ref()
        .child(DateTime.now().toString() + ".jpg");
    await ref.putFile(File(_pickedImage!.path));
    final String imgUrl = await ref.getDownloadURL();
    final user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.email)
        .update({
      "image": imgUrl,
      "name": _nameController.text,
    });
    showSuccessSnack("Profile updated successfully");
  }

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
            child: InkWell(
                onTap: () {
                  _handleImage();
                },
                child: _pickedImage != null
                    ? Image.file(
                        File(_pickedImage!.path),
                        fit: BoxFit.cover,
                      )
                    : const Icon(
                        Icons.add,
                        size: 40,
                      )),
          )),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                      hintText: "Name", border: OutlineInputBorder()),
                  controller: _nameController,
                ),
                ElevatedButton(
                    onPressed: () {
                      if (_pickedImage != null &&
                          _nameController.text.isNotEmpty) {
                        _updateProfile();
                      } else {
                        print("nothing to update");
                      }
                    },
                    child: Text("update")),
              ],
            ),
          )
        ],
      )),
    );
  }
}
