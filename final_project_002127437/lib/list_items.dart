import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'post_item.dart';
import 'item_detail.dart';
import 'display_picture.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  int _itemCount = 0;
  final items = List<Map<String, String>>.generate(
      100,
      (i) => {
            'title': 'Item $i',
            'description': 'Description $i',
            'price': '\$10'
          });

  Future<void> _addItem(BuildContext context) async {
    final result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => const NewPost()));

    if (!mounted) return;

    if (result != null) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('$result')));

      setState(() {
        ++_itemCount;
      });
    }
  }

  Future _getItems() async {
    return await db.collection('002127437_docs').get();
  }

  void _getInfo(String docId) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ItemDetail(docId: docId)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Items for Sale"),
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  _addItem(context);
                },
                child: const Icon(
                  Icons.add,
                ),
              )),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Hyper Garage Sale',
                style: TextStyle(fontSize: 36, color: Color(0xFFFFFFFF)),
              ),
            ),
            ListTile(
              title: const Text("New Post"),
              onTap: () {
                _addItem(context);
              },
            ),
            ListTile(
              title: const Text("Sign Out"),
              onTap: () async {
                await _firebaseAuth.signOut();
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder(
        future: _getItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            QuerySnapshot snapshotData = snapshot.data as QuerySnapshot;
            if (snapshotData.docs.isNotEmpty) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  DocumentSnapshot doc = snapshotData.docs[index];
                  Map<String, dynamic> data =
                      doc.data() as Map<String, dynamic>;
                  return ListTile(
                    leading: GestureDetector(
                      onTap: () async {
                        if (data["images"].length > 0) {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => DisplayPictureScreen(
                                imagePath: data["images"][0],
                                imageTitle: data["title"],
                                screen: "PostDetail",
                              ),
                            ),
                          );
                        }
                      },
                      child: data["images"].length > 0
                          ? Image.network(
                              data["images"][0],
                              width: 50,
                            )
                          : const Icon(Icons.flutter_dash),
                    ),
                    title: Text(data["title"]),
                    subtitle: Text(data['description']),
                    trailing: Text(data['price']),
                    onTap: () {
                      _getInfo(data["title"]);
                    },
                  );
                },
                itemCount: snapshotData.docs.length,
              );
            } else {
              return const Center(
                child: Text(
                  "No Items for Sale",
                  style: TextStyle(fontSize: 24, color: Colors.grey),
                ),
              );
            }
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
