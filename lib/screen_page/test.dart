import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class TestFireStore extends StatefulWidget {
  const TestFireStore({super.key});

  @override
  State<TestFireStore> createState() => _TestFireStoreState();
}

class _TestFireStoreState extends State<TestFireStore> {
  final CollectionReference _products =
      FirebaseFirestore.instance.collection('users');
  var i = 0;
  var id = 0;
  List<DocumentSnapshot> a = [];
  final user = <String, dynamic>{
    'id': int,
    "name": "Chi",
    'age': 20,
  };
  Future<void> addUser(int id) {
    // Call the user's CollectionReference to add a new user

    return _products
        .doc(id.toString())
        .set({
          'id': id,
          "name": "Chi",
          'age': 20,
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> updateUser(String doc) {
    return _products
        .doc(doc)
        .update({
          // 'id': i,
          "name": "Phuong",
          'age': 23,
        })
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> deleteUser(String doc) {
    return _products
        .doc(doc)
        .delete()
        .then((value) => print("User Deleted"))
        .catchError((error) => print("Failed to delete user: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: StreamBuilder(
                stream: _products.snapshots(),
                builder:
                    (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                  if (streamSnapshot.hasData) {
                    return ListView.builder(
                      itemCount: streamSnapshot.data!.docs.length,
                      itemBuilder: ((context, index) {
                        final DocumentSnapshot documentSnapshot =
                            streamSnapshot.data!.docs[index];
                        a.add(documentSnapshot);
                        for (int i = 0; i < a.length; i++) {
                          print(Text('DATA :' + a[i].id));
                        }
                        return Card(
                          child: ListTile(
                            title: Text(documentSnapshot['name']),
                            subtitle: Text(documentSnapshot['age'].toString()),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                deleteUser(documentSnapshot['id'].toString());
                                // a.remove(documentSnapshot['id']);
                              },
                            ),
                            leading: IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                updateUser(documentSnapshot['id'].toString());
                              },
                            ),
                          ),
                        );
                      }),
                    );
                  }
                  return Card();
                }),
          ),
          Expanded(
            flex: 2,
            child: Container(
              width: 100,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  // a.length == -1 ? id = 0 : id = 0;
                  id = int.parse(a[a.length - 1].id);
                  if (id == null) {
                    id = 0;
                  }
                  id = id + 1;
                  // i = id + 1;
                  addUser(id);

                  print('IDD: ' + a[a.length - 1].id);
                  print('ID: ' + i.toString());
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(20),
                ),
                child: Text('Push'),
              ),
            ),
          )
        ],
      ),
    );
  }
}
