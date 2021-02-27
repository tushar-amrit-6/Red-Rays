import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_app_sigma/profiletwo.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:plasma/choices/choices.dart';

class NewApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
    );

    return MaterialApp(
      title: 'Introduction screen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: OnBoardingPage(),
    );
  }
}

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => One1()),
    );
  }

  Widget _buildImage(String assetName) {
    return Align(
      child: Image.asset('images/$assetName.png', width: 500.0),
      alignment: Alignment.bottomCenter,
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white70,
      //pageColor: Color.fromRGBO(255, 192, 203, 50),
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      pages: [
        PageViewModel(
          title: "Feeds Section",
          body:
              "View urgent requirements of blood/plasma from patients across countries.Also share your donations stories with world",
          image: _buildImage('copy1'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Search",
          body: "Find donors according to location and blood group",
          image: _buildImage('copy2'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Request",
          body: "Request blood/plasma from donors and get contacted directly",
          image: _buildImage('copy8'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Donor section",
          body: "Donors can share their info for willingness to donate ",
          image: _buildImage('copy3'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "FAQ section",
          body: "Know more details and facts about blood/ plasma donation",
          image: _buildImage('copy4'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Am I eligible to donate? ",
          body:
              "-You are atleast 17 years old and weigh 110 lbs/50kg.Additional weight requirements apply for donors age 18 or younger\n \t-Have a verified blood and dignostic report and is now symptom free or fully recovered from Corona \n\t -In good health condition",
          image: _buildImage('copy55'),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      skip: const Text('Skip'),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Get Started',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Colors.redAccent,
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
