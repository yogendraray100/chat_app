import 'package:chat_app/profile/edit_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  getCurrentUser() async {
    var user = FirebaseAuth.instance.currentUser;

    userData = await FirebaseFirestore.instance
        .collection("users")
        .doc(user?.email)
        .get();

    isloading = false;
    if (mounted) {
      setState(() {});
    }
  }

  var userData;
  bool isloading = true;

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: isloading
          ? Center(child: CircularProgressIndicator())
          : Builder(builder: (context) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: ClipOval(
                      child: Image.network(
                        "https://imgs.search.brave.com/83Ern_UwWSpzNWG2sc7ngv_OaTdjUVLyQKG0UrBXQNI/rs:fit:840:871:1/g:ce/aHR0cHM6Ly9jbGlw/Z3JvdW5kLmNvbS9p/bWFnZXMvcmFuZG9t/LXBuZy01LmpwZw",
                        height: 0.4 * size.width,
                        width: 0.4 * size.width,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Text(
                    userData['name'],
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    userData['email'],
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(CupertinoPageRoute(
                            builder: (context) => EditProfile()));
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.edit),
                          Text("Edit Profile"),
                        ],
                      ))
                ],
              );
            }),
    );
  }
}
