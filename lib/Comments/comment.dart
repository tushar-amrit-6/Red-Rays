import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:plasma/global.dart';
import 'package:uuid/uuid.dart';

DatabaseReference database1;
final databaseReference = FirebaseDatabase.instance.reference();
String abc;
bool check = true;

class Comment1 extends StatefulWidget {
  final String comment1;

  const Comment1({Key key, this.comment1}) : super(key: key);
  @override
  _CommentState createState() => _CommentState();
}

class _CommentState extends State<Comment1> {
  bool isLoading = false;
  TextEditingController _comment = TextEditingController();
  @override
  void initState() {
    super.initState();
    database1 = FirebaseDatabase.instance
        .reference()
        .child("Comments")
        .child(widget.comment1);
  }

  Future<String> add(String comment, String image, String name) async {
    setState(() {
      isLoading = true;
    });
    var uuid = new Uuid().v1();
    DatabaseReference _color2 =
        databaseReference.child("Comments").child(widget.comment1).child(uuid);
    final TransactionResult transactionResult =
        await _color2.runTransaction((MutableData mutableData) async {
      mutableData.value = (mutableData.value ?? 0) + 1;

      return mutableData;
    });
    if (transactionResult.committed) {
      setState(() {
        isLoading = false;
      });
      _color2.push().set(<String, String>{
        "image": "true",
        "postname": "true",
        "comment": "true",
        "uid": "true"
      }).then((_) {
        print('Transaction  committed.');

        abc = "success";
      });
    } else {
      print('Transaction not committed.');
      if (transactionResult.error != null) {
        print(transactionResult.error.message);
      }
    }
    _color2
        .set({"image": image, "username": name, "post": comment, "uid": uuid});

    return abc;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            "Comments",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: isLoading
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ),
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      //color: Colors.red,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 1.3,
                      child: FirebaseAnimatedList(
                          sort: (a, b) => (b.key.compareTo(a.key)),
                          defaultChild: Center(
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.black,
                            ),
                          ),
                          query: database1,
                          itemBuilder: (_, DataSnapshot snapshot,
                              Animation<double> animation, int index) {
                            return FutureBuilder<DataSnapshot>(
                              future: database1
                                  .reference()
                                  .child(snapshot.key)
                                  .once(),
                              builder: (context, snapshot1) {
                                return snapshot1.hasData
                                    ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 30,
                                              backgroundImage: NetworkImage(
                                                  snapshot1
                                                      .data.value['image']),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Text(
                                              snapshot1.data.value['username'] +
                                                  ": ",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            Flexible(
                                              child: Text(
                                                snapshot1.data.value['post'],
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    : Container();
                              },
                            );
                          }),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          color: Colors.transparent,
                          child: Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 1.2,
                                child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(
                                      controller: _comment,
                                      decoration: InputDecoration.collapsed(
                                          border: InputBorder.none,
                                          hintText: "Comments",
                                          hintStyle: TextStyle(
                                              color: Colors.grey[500])),
                                    )),
                              ),
                              IconButton(
                                  icon: Icon(
                                    Icons.send,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    add(_comment.text, globalimage, globalname);
                                    _comment.clear();
                                  })
                            ],
                          )),
                    )
                  ],
                ),
              ));
  }
}
