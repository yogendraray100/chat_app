import 'package:chat_app/add_page.dart';
import 'package:chat_app/auth/login.dart';
import 'package:chat_app/dummypage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _editingController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          //FirebaseFirestore.instance.collection("todos").add({"name": "hehe"});
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddPage(),
            ),
          );
        },
      ),
      appBar: AppBar(
        title: Text("HomePage"),
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushAndRemoveUntil(
                    CupertinoPageRoute(
                        builder: (context) => const LoginScreen()),
                    (route) => false);
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("todos")
            .where("created_by", isEqualTo: user?.uid)
            .snapshots(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            List data = snapshot.data?.docs ?? [];
            return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(data[index]['name']),
                    trailing: SizedBox(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: Text("Confirm delete?"),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                FirebaseFirestore.instance
                                                    .collection("todos")
                                                    .doc(data[index].id)
                                                    .delete();

                                                Navigator.pop(context);
                                              },
                                              child: Text("yes")),
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text("Cancel"))
                                        ],
                                      ));
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: Colors.blue,
                            ),
                            onPressed: () {
                              // showDialog(
                              //     context: context,
                              //     builder: (context) => AlertDialog(
                              //           title: TextFormField(
                              //             validator: (value) {
                              //               if (value != null &&
                              //                   value.length > 3) {
                              //                 return null;
                              //               } else {
                              //                 return "task should be bigger";
                              //               }
                              //             },
                              //             controller: _editingController,
                              //           ),
                              //           actions: [
                              //             ElevatedButton(
                              //                 onPressed: () {
                              //                   FirebaseFirestore.instance
                              //                       .collection("todos")
                              //                       .doc(data[index].id)
                              //                       .update({
                              //                     "name":
                              //                         _editingController.text
                              //                   });
                              //                   Navigator.pop(context);
                              //                 },
                              //                 child: Text("update"))
                              //           ],
                              //         ));
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: ((context) => AddPage(
                                        documentId: data[index].id,
                                        title: data[index]['name'],
                                      ))));
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                });
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }),
      ),
    );
  }
}
