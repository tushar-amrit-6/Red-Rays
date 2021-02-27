import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:plasma/Donor/Show/show.dart';

DatabaseReference database1;

class Donate1 extends StatefulWidget {
  @override
  _Donate1State createState() => _Donate1State();
}

class _Donate1State extends State<Donate1> {
  @override
  void initState() {
    super.initState();
    database1 = FirebaseDatabase.instance.reference().child("Request");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "LIST OF REQUESTS",
          style: TextStyle(
              letterSpacing: 10,
              color: Colors.black,
              fontSize: 25,
              fontWeight: FontWeight.w400),
        ),
      ),
      body: Container(
        child: FirebaseAnimatedList(
            sort: (a, b) => (b.key.compareTo(a.key)),
            defaultChild: Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
              ),
            ),
            query: database1,
            itemBuilder: (_, DataSnapshot snapshot, Animation<double> animation,
                int index) {
              return FutureBuilder<DataSnapshot>(
                  future: database1.reference().child(snapshot.key).once(),
                  builder: (context, snapshot1) {
                    return snapshot1.hasData
                        ? GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Show(
                                            image:
                                                snapshot1.data.value['image'],
                                            report:
                                                snapshot1.data.value['report'],
                                            name: snapshot1
                                                .data.value['username'],
                                            post:
                                                snapshot1.data.value['request'],
                                            uid: snapshot1.data.value['uid'],
                                          )));
                            },
                            child: Card(
                              elevation: 15,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20)),
                                width: MediaQuery.of(context).size.width / 1.3,
                                height: MediaQuery.of(context).size.height / 9,
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 25,
                                      backgroundColor: Colors.transparent,
                                      backgroundImage: NetworkImage(
                                          snapshot1.data.value['image']),
                                    ),
                                    Text(snapshot1.data.value['username'])
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Container();
                  });
            }),
      ),
    );
  }
}
