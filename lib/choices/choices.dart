import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:plasma/Donor/Authenticate1.dart';
import 'package:plasma/Language/language1.dart';
import 'package:plasma/Patient/Authenticate.dart';

String c;

class One1 extends StatefulWidget {
  static void setLocale(BuildContext context, Locale locale) {
    _One1State state = context.findAncestorStateOfType<_One1State>();
    state.setLocale(locale);
  }

  @override
  _One1State createState() => _One1State();
}

class _One1State extends State<One1> {
  Locale _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      supportedLocales: [
        const Locale('en', 'US'), // English, no country code
        const Locale('hi', 'IN'), // Hebrew, no country code
        // Chinese *See Advanced Locales below*
        // ... other locales the app supports
      ],
      locale: _locale,
      localizationsDelegates: [
        DemoLocalization.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (devicelocale, supportedlocale) {
        for (var locale in supportedlocale) {
          if (locale.languageCode == devicelocale.languageCode &&
              locale.countryCode == devicelocale.countryCode) {
            return devicelocale;
          }
        }
        return supportedlocale.first;
      },
      home: Choices(),
    );
  }
}

class Choices extends StatefulWidget {
  @override
  _ChoicesState createState() => _ChoicesState();
}

class _ChoicesState extends State<Choices> {
  void _changelanguage(String change1) {
    Locale _temp;
    switch (change1) {
      case 'en':
        _temp = Locale(change1, 'US');
        break;
      case 'hi':
        _temp = Locale(change1, 'IN');
        break;
    }

    One1.setLocale(context, _temp);
  }

  List<String> a = ["English", "हिंदी", "தமிழ்", "বাংলা", "ਪੰਜਾਬੀ"];
  List<String> b = ["en", "hi"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF9F000F),
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0, actions: [
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                icon: Icon(
                  Icons.language_outlined,
                  size: 29,
                  color: Colors.black,
                ),
                onPressed: () {
                  showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20))),
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 1.5,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Please Select Your Language",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15)),
                                  ),
                                  Text("कृपया अपनी भाषा चुनें",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15)),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height /
                                        2.5,
                                    child: ListView.builder(
                                        itemCount: a.length,
                                        itemBuilder: (context, index) {
                                          return Column(
                                            children: [
                                              ListTile(
                                                focusColor: Colors.blue,
                                                hoverColor: Colors.blue,
                                                onTap: () {
                                                  c = b[index];
                                                },
                                                title: Center(
                                                    child: Text(a[index])),
                                              ),
                                              Divider()
                                            ],
                                          );
                                        }),
                                  ),
                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height / 40,
                                  ),
                                  SizedBox(
                                    width: 100,
                                    height: 50,
                                    child: RaisedButton(
                                        color: Colors.black,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        child: Center(
                                          child: Text(
                                            "Next",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        onPressed: () {
                                          _changelanguage(c);
                                          Navigator.pop(context);
                                        }),
                                  )
                                  /* DropdownButton(
                              underline: SizedBox(),
                              icon: Icon(
                                Icons.language,
                                color: Colors.black,
                              ),
                              items: Change.languageList()
                                  .map<DropdownMenuItem<Change>>(
                                      (e) => DropdownMenuItem(
                                          value: e,
                                          child: Center(
                                            child: Text(
                                              e.name,
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          )))
                                  .toList(),
                              onChanged: (Change change) {
                                _changelanguage(change);
                              }),*/
                                ]));
                      });
                })),
      ]),
      body: Center(
        child: Column(
          children: [
            Container(
              height: 250,
              width: 500,
              color: Colors.white,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 170,
                      width: 170,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        image: DecorationImage(
                            image: AssetImage("images/logo.png")),
                      ),
                    )
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Authenticate()));
              },
              child: Container(
                height: 250,
                color: Colors.blue[900],
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DemoLocalization.of(context)
                            .gettranslatedvalue('CONTINUE AS PATIENT'),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            letterSpacing: 2),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Authenticate1()));
              },
              child: Container(
                height: 200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DemoLocalization.of(context)
                          .gettranslatedvalue('CONTINUE AS DONOR'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white, fontSize: 25, letterSpacing: 2),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
