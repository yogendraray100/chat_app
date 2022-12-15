import 'package:chat_app/auth/login.dart';
import 'package:chat_app/chat/chat_details_screen.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/profile/profile_screen.dart';
import 'package:chat_app/utils/app_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final user = FirebaseAuth.instance.currentUser;

  // @override
  // void initState() {
  //   FirebaseCrashlytics.instance.setCustomKey('user_id', user!.uid);
  //   FirebaseCrashlytics.instance.setCustomKey('user_email', user!.email!);

  //   FirebaseCrashlytics.instance.crash();

  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(AppSettings.navigatorKey.currentContext!)
                    .pushAndRemoveUntil(
                        CupertinoPageRoute(builder: (context) => LoginScreen()),
                        (route) => false);
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users")
              .where(
                "email",
                isNotEqualTo: user?.email,
              )
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final users = snapshot.data?.docs ?? [];
              return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        String loggedInUserId = user!.email ?? "";
                        String otherUserId = users[index]['email'];
                        String chatRoomId =
                            createChatRoom(loggedInUserId, otherUserId);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ChatDetailScreen(
                                  chatRoomId: chatRoomId,
                                )));
                      },
                      title: Text(
                        users[index]['name'],
                        style: TextStyle(fontSize: 20),
                      ),
                      subtitle: Padding(
                        padding: EdgeInsets.only(top: 6),
                        child: Text(
                          "Recent messages",
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      leading: InkWell(
                        onTap: () {
                          Navigator.of(context).push(CupertinoPageRoute(
                              builder: (context) => ProfileScreen()));
                        },
                        child: ClipOval(
                            child: Image.network(
                          "https://imgs.search.brave.com/83Ern_UwWSpzNWG2sc7ngv_OaTdjUVLyQKG0UrBXQNI/rs:fit:840:871:1/g:ce/aHR0cHM6Ly9jbGlw/Z3JvdW5kLmNvbS9p/bWFnZXMvcmFuZG9t/LXBuZy01LmpwZw",
                          height: 50,
                          width: 50,
                        )),
                      ),

                      //
                    );
                  });
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }
}
