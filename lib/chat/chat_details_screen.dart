import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatDetailScreen extends StatefulWidget {
  final String chatRoomId;
  const ChatDetailScreen({super.key, required this.chatRoomId});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shree Krishna"),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("chats")
                  .doc(widget.chatRoomId)
                  .collection("messages")
                  .orderBy("created_at", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final chats = snapshot.data?.docs ?? [];
                  return ListView.separated(
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 10,
                    ),
                    itemCount: chats.length,
                    reverse: true,
                    itemBuilder: (context, index) {
                      bool isSentByMe = user?.uid == chats[index]['sent_by'];
                      return Row(
                        mainAxisAlignment: isSentByMe
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          //if (!isSentByMe)
                          Visibility(
                            visible: !isSentByMe,
                            child: ClipOval(
                              child: Image.network(
                                "https://imgs.search.brave.com/2__5NHozXQ7y9JVhvB56b_kkOEkhrGSZa2eVAUDYCrI/rs:fit:1000:981:1/g:ce/aHR0cDovL2ltYWdl/czQuZmFucG9wLmNv/bS9pbWFnZS9waG90/b3MvMjM3MDAwMDAv/RnVubnktcmFuZG9t/LTIzNzk3OTE1LTEw/MDAtOTgxLmpwZw",
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: isSentByMe ? Colors.grey : Colors.blue,
                                  borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(5),
                                    topRight: const Radius.circular(5),
                                    bottomLeft: isSentByMe
                                        ? const Radius.circular(5)
                                        : const Radius.circular(0),
                                    bottomRight: isSentByMe
                                        ? const Radius.circular(0)
                                        : const Radius.circular(5),
                                  )),
                              child: Text(
                                chats[index]["message"],
                                style: TextStyle(color: Colors.white),
                              )),
                          SizedBox(
                            width: 10,
                          ),
                          //if (isSentByMe)
                          Visibility(
                            visible: isSentByMe,
                            child: ClipOval(
                              child: Image.network(
                                "https://imgs.search.brave.com/r_1yyCXVolZSkAcypo63Ofr1LmOHnQI9n_WLLCTr4_0/rs:fit:750:1000:1/g:ce/aHR0cDovL3d3dy5k/dW1wYWRheS5jb20v/d3AtY29udGVudC91/cGxvYWRzLzIwMTkv/MDgvdGhlLXJhbmRv/bS1waWNzLTQ5NS5q/cGc",
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          SizedBox(
            height: 50,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                      child: TextFormField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(3),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                          borderSide: BorderSide(color: Colors.blue)),
                      hintText: "Send Message",
                    ),
                  )),
                  IconButton(
                      onPressed: () async {
                        final auth = FirebaseAuth.instance.currentUser;
                        if (_messageController.text.isNotEmpty) {
                          await FirebaseFirestore.instance
                              .collection("chats")
                              .doc(widget.chatRoomId)
                              .collection("messages")
                              .add({
                            "message": _messageController.text,
                            "created_at": DateTime.now().toString(),
                            "chat_Room_Id": widget.chatRoomId,
                            "sent_by": auth?.uid,
                          });
                          _messageController.clear();
                        }
                      },
                      icon: Icon(Icons.send, color: Colors.blue))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
