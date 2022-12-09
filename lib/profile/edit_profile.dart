import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/utils/snacks.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _nameController = TextEditingController();
  // var data;

  // getCurrentUser() async {
  //   final user = FirebaseAuth.instance.currentUser;
  //   data = await FirebaseFirestore.instance
  //       .collection("users")
  //       .doc(user?.uid)
  //       .get();
  // }

  XFile? _pickedImage;

  _pickImage(ImageSource imageSource) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: imageSource);
    if (image != null) {
      File? croppedImage = await _cropImage(File(image.path));
      if (croppedImage != null) _pickedImage = XFile(croppedImage.path);
      if (mounted) setState(() {});
    }

    Navigator.of(AppSettings.navigatorKey.currentContext!).pop();
  }

  Future<File?> _cropImage(File imageFile) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Cropper',
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    );

    return croppedFile != null ? File(croppedFile.path) : null;
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
    await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
      "image": imgUrl,
      "name": _nameController.text,
    });
    showSuccessSnack("Profile updated successfully");
    Navigator.of(AppSettings.navigatorKey.currentContext!).pop();
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
                    // : data['image'] != null
                    //     ? CachedNetworkImage(
                    //         imageUrl: data['image'],
                    //         fit: BoxFit.cover,
                    //       )
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
            child: TextFormField(
              decoration: InputDecoration(
                  hintText: "Name", border: OutlineInputBorder()),
              controller: _nameController,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () {
                if (_pickedImage != null && _nameController.text.isNotEmpty) {
                  _updateProfile();
                } else {
                  print("nothing to update");
                }
              },
              child: Text("update")),
        ],
      )),
    );
  }
}
