import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:plasma/Donor/Show/chat1.dart';
import 'package:plasma/global.dart';
import 'package:uuid/uuid.dart';

final databaseReference = FirebaseDatabase.instance.reference();
String abc;

class Show extends StatefulWidget {
  final String image;
  final String report;
  final String name;
  final String post;
  final String uid;
  const Show({Key key, this.image, this.report, this.name, this.post, this.uid})
      : super(key: key);
  @override
  _ShowState createState() => _ShowState();
}

class _ShowState extends State<Show> {
  Future<String> add(String posttext, String image, String name, String report,
      String check) async {
    //var uuid = new Uuid().v1();
    DatabaseReference _color2 =
        databaseReference.child("Request").child(widget.uid);
    final TransactionResult transactionResult =
        await _color2.runTransaction((MutableData mutableData) async {
      mutableData.value = (mutableData.value ?? 0) + 1;

      return mutableData;
    });
    if (transactionResult.committed) {
      _color2.push().set(<String, String>{
        "image": "true",
        "username": "true",
        "request": "true",
        "report": "true",
        "check": "true",
        "donarname": "true",
        "donarimage": "true",
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
    _color2.set({
      "image": image,
      "username": name,
      "request": posttext,
      "report": report,
      "check": check,
      "donarimage": globalimage1,
      "donarname": globalname1,
      "uid": widget.uid
    });

    return abc;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          " REQUEST",
          style: TextStyle(
              letterSpacing: 20,
              color: Colors.black,
              fontSize: 25,
              fontWeight: FontWeight.w400),
        ),
      ),
      body: Container(
        color: Color(0xFFFFC0CB),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.transparent,
                    backgroundImage: NetworkImage(widget.image),
                  ),
                  Text(widget.name),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Covid Report",
                style: TextStyle(color: Colors.black),
              ),
            ),
            Image.network(
              widget.report,
              filterQuality: FilterQuality.high,
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
            ),
            Center(
              child: RaisedButton(
                  child: Text("Accepted"),
                  onPressed: () {
                    add(widget.post, widget.image, widget.name, widget.report,
                            "true")
                        .then((value) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Chat2(
                                    image: widget.image,
                                    name: widget.name,
                                    uid: widget.uid,
                                  )));
                    });
                  }),
            )
          ],
        ),
      ),
    );
  }
}
