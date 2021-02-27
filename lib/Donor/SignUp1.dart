import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plasma/Donor/selfdeclarationform/form.dart';
import 'package:plasma/bottombar/bottom.dart';
import 'package:uuid/uuid.dart';

AuthResult authResult;
String user;
int g = 1;
VisionText visiontext;

class SignUp2 extends StatefulWidget {
  final Function toggle;
  SignUp2(this.toggle);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp2> {
  final formkey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _pwd = TextEditingController();
  TextEditingController _pwd1 = TextEditingController();
  TextEditingController _exp = TextEditingController();
  TextEditingController _fee = TextEditingController();
  final _auth = FirebaseAuth.instance;
  bool check = false;
  final picker = ImagePicker();
  String downloadurl;
  String downloadurl1;
  File image1;
  File image2;
  final databaseReference = FirebaseDatabase.instance.reference();
  var uid = Uuid();
  File imagefile;

  Future<void> _trysubmit(BuildContext ctx, String name, String email,
      String pwd, String pwd1) async {
    final isvalid = formkey.currentState.validate();
    FocusScope.of(ctx).unfocus();
    if (isvalid) {
      formkey.currentState.save();
    } else {}
    _submitAuthForm(name.trim(), email.trim(), pwd.trim(), pwd1.trim(), ctx);
  }

  void _submitAuthForm(
    var name1,
    var email1,
    var pwd1,
    var pwd2,
    BuildContext ctx,
  ) async {
    try {
      authResult = await _auth.createUserWithEmailAndPassword(
          email: email1, password: pwd1);
      user = authResult.user.uid;
    } on PlatformException catch (err) {
      var message = "An error occured,please check your credentials";
      if (err.message != null) {
        message = err.message;
      }
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ));
    } catch (err) {
      print(err);
    }
    add(name1, email1, pwd1);
  }

  Future uploadToStorage() async {
    try {
      final DateTime now = DateTime.now();
      final int millSeconds = now.millisecondsSinceEpoch;
      final String month = now.month.toString();
      final String date = now.day.toString();
      final String storageId = (millSeconds.toString() + uid.toString());
      final String today = ('$month-$date');

      final file = await picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      image1 = File(file.path);
      uploadVideo(image1);
    } catch (error) {
      print(error);
    }
  }

  Future<String> uploadVideo(var videofile) async {
    var uuid = new Uuid().v1();
    StorageReference ref =
        FirebaseStorage.instance.ref().child("post_$uuid.jpg");

    await ref.putFile(videofile).onComplete.then((val) {
      val.ref.getDownloadURL().then((val) {
        print(val);
        downloadurl = val;
        // add(downloadurl); //Val here is Already String
        Future.delayed(Duration(seconds: 2), () {
          setState(() {
            check = true;
          });
        });
      });
    });
    return downloadurl;
  }

  Future uploadToStorage1() async {
    try {
      final DateTime now = DateTime.now();
      final int millSeconds = now.millisecondsSinceEpoch;
      final String month = now.month.toString();
      final String date = now.day.toString();
      final String storageId = (millSeconds.toString() + uid.toString());
      final String today = ('$month-$date');

      final file = await picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      image2 = File(file.path);
      uploadVideo1(image2);
    } catch (error) {
      print(error);
    }
  }

  Future<String> uploadVideo1(var videofile) async {
    var uuid = new Uuid().v1();
    StorageReference ref =
        FirebaseStorage.instance.ref().child("post_$uuid.jpg");

    await ref.putFile(videofile).onComplete.then((val) {
      val.ref.getDownloadURL().then((val) {
        print(val);
        downloadurl1 = val;
        // add(downloadurl); //Val here is Already String
        setState(() {
          g = 0;
        });
      });
    });
    return downloadurl1;
  }

  Future<void> add(String username, String useremail, String passwd) async {
    // var uuid = new Uuid().v1();
    DatabaseReference _color2 = databaseReference.child("Donator").child(user);
    final TransactionResult transactionResult =
        await _color2.runTransaction((MutableData mutableData) async {
      mutableData.value = (mutableData.value ?? 0) + 1;

      return mutableData;
    });
    if (transactionResult.committed) {
      _color2.push().set(<String, String>{
        "image": "true",
        "fullname": "true",
        "email": "true",
        "pwd": "true",
        "uid": "true"
      }).then((_) {
        print('Transaction  committed.');
      });
    } else {
      print('Transaction not committed.');
      if (transactionResult.error != null) {
        print(transactionResult.error.message);
      }
    }
    _color2.set({
      "image": downloadurl,
      "fullname": username,
      "email": useremail,
      "pwd": passwd,
      "uid": user
    });
  }

  Future<void> camera() async {
    var pickedfile = await ImagePicker().getImage(source: ImageSource.camera);
    imagefile = File(pickedfile.path);
    var firebasevision = FirebaseVisionImage.fromFile(imagefile);
    var textrecognizer = FirebaseVision.instance.textRecognizer();
    visiontext = await textrecognizer.processImage(firebasevision);
    textrecognizer.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          children: [
            Container(
              color: Color(0xFF9F000F),
              child: Container(
                height: 300,
                child: Center(
                  child: Container(
                    height: 180,
                    width: 240,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        image: DecorationImage(
                            image: AssetImage("images/logo.png"),
                            fit: BoxFit.cover)),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: Form(
                          key: formkey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Upload Profile Picture",
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      uploadToStorage();
                                    },
                                    child: CircleAvatar(
                                      backgroundColor: Colors.red[100],
                                      radius: 30.6,
                                      backgroundImage: check == false
                                          ? ExactAssetImage("images/5.png")
                                          : NetworkImage(downloadurl),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 40, 10, 0),
                                child: Container(
                                  color: Colors.white10,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    child: TextFormField(
                                      controller: _name,
                                      validator: (val) {
                                        return val.isEmpty || val.length < 4
                                            ? "Username is too short"
                                            : null;
                                      },
                                      style: TextStyle(color: Colors.black),
                                      decoration: InputDecoration(
                                        hintText: "Fullname",
                                        hintStyle:
                                            TextStyle(color: Colors.black54),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                child: Container(
                                  color: Colors.white10,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    child: TextFormField(
                                      controller: _email,
                                      validator: (val) {
                                        return RegExp(
                                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                                .hasMatch(val)
                                            ? null
                                            : "Provide a valid Email Address*";
                                      },
                                      style: TextStyle(color: Colors.black),
                                      decoration: InputDecoration(
                                        hintText: "Your Email",
                                        hintStyle:
                                            TextStyle(color: Colors.black54),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                child: Container(
                                  color: Colors.white10,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    child: TextFormField(
                                      controller: _pwd,
                                      obscureText: true,
                                      validator: (val) {
                                        return val.length > 7
                                            ? null
                                            : "Password must be of atleast 8 characters*";
                                      },
                                      style: TextStyle(color: Colors.black),
                                      decoration: InputDecoration(
                                        hintText: "Create new password",
                                        hintStyle:
                                            TextStyle(color: Colors.black54),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                child: Container(
                                  color: Colors.white10,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 0, 10, 10),
                                    child: TextFormField(
                                      controller: _pwd1,
                                      validator: (val) {
                                        return val == _pwd.text
                                            ? null
                                            : "Password is not same*";
                                      },
                                      obscureText: true,
                                      style: TextStyle(color: Colors.black),
                                      decoration: InputDecoration(
                                        hintText: "Confirm password",
                                        hintStyle:
                                            TextStyle(color: Colors.black54),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  camera().then((value) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Bottom()));
                                  });
                                  /*uploadToStorage1().then((value) {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          Future.delayed(Duration(seconds: 5),
                                              () {
                                            Navigator.of(context).pop(true);
                                          });
                                          return AlertDialog(
                                            content: g == 0
                                                ? CircularProgressIndicator()
                                                : Icon(Icons.check,
                                                    color: Colors.green),
                                          );
                                        });
                                  });*/
                                },
                                child: Container(
                                  height: 50,
                                  width: 300,
                                  color: Color(0xFFFFC0CB),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.attachment,
                                        size: 30,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "ATTACH BLOOD REPORT",
                                        style: TextStyle(fontSize: 19),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 13),
                              GestureDetector(
                                onTap: () {
                                  /*uploadToStorage1().then((value) {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          Future.delayed(Duration(seconds: 5),
                                              () {
                                            Navigator.of(context).pop(true);
                                          });
                                          return AlertDialog(
                                            content: g == 0
                                                ? CircularProgressIndicator()
                                                : Icon(Icons.check,
                                                    color: Colors.green),
                                          );
                                        });
                                  });*/
                                },
                                child: Container(
                                  height: 50,
                                  width: 300,
                                  color: Color(0xFFFFC0CB),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.attachment,
                                        size: 30,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "COVID-19 negative certificate",
                                        style: TextStyle(fontSize: 17),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _trysubmit(
                            context,
                            _name.text,
                            _email.text,
                            _pwd.text,
                            _pwd1.text,
                          ).then((value) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Form1(
                                          image: downloadurl,
                                        )));
                            _name.clear();
                            _email.clear();
                            _pwd.clear();
                            _pwd1.clear();
                            _exp.clear();
                            _fee.clear();
                          });
                        },
                        child: Container(
                          height: 40,
                          width: 350,
                          decoration: BoxDecoration(
                              color: Colors.blue[900],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Center(
                              child: Text(
                            "SIGN UP",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                letterSpacing: 5,
                                fontWeight: FontWeight.w800),
                          )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              height: 1,
                              width: 150,
                              color: Colors.black87,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "OR",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              height: 1,
                              width: 150,
                              color: Colors.black87,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Already have an Account?",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 17),
                            ),
                            GestureDetector(
                              onTap: () {
                                widget.toggle();
                              },
                              child: Text(
                                " Sign In.",
                                style: TextStyle(
                                    color: Color(0xFF9F000F),
                                    fontWeight: FontWeight.w900,
                                    fontSize: 17),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
