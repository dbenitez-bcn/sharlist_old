import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Tutorial extends StatefulWidget {
  @override
  _TutorialState createState() => new _TutorialState();
}

class _TutorialState extends State<Tutorial> {
  int currentPage = 0;
  final pageController = PageController(
    initialPage: 0,
  );
  final List<String> textTutorials = ["tutorial_one","tutorial_two","tutorial_three","tutorial_four"];

  void nextPageModel() {
    pageController.nextPage(
        duration: Duration(milliseconds: 200), curve: Curves.ease);
    changePage(pageController.page.round());
  }

  void changePage(int page){
    currentPage = page;
    setState(loadPoints);
  }
  List<Widget> points = [];

  void loadPoints() {
    points=[];
    for (var i = 0; i < 4; i++) {
      if (i != currentPage)
        points.add(_buildPointOff(context));
      else
        points.add(_buildPointOn(context));
    }
  }

  @override
  void initState() {
    loadPoints();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          pageViewPictures(context),
          _buildUi(context),
        ],
      ),
    );
  }

  Widget pageViewPictures(BuildContext context){
    return SizedBox.expand(
      child: Container(
        color: Colors.teal[700],
        child: PageView(
          controller: pageController,
          onPageChanged: (page) {
            changePage(page);
          },
          children: <Widget>[
            _buildPage(context, "assets/images/screen1.png"),
            _buildPage(context, "assets/images/screen2.png"),
            _buildPage(context, "assets/images/screen3.png"),
            _buildPage(context, "assets/images/screen4.png"),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(BuildContext context, String img) {
    return SafeArea(
      child: Container(
        color: Colors.teal[700],
        child: Image.asset(
          img,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
        ),
      ),
    );
  }

  Widget _buildUi(BuildContext context){
    return SafeArea(
      child: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(FlutterI18n.translate(context, "appName"), style: TextStyle(color: Colors.white, fontSize: 80.0, fontFamily: 'brush')),
            Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(FlutterI18n.translate(context, textTutorials[currentPage]), style: TextStyle(color: Colors.white, fontSize: 24.0, fontFamily: 'brush', ), textAlign: TextAlign.center,),
              ),
              currentPage<3? twoButtons(context) : EmpezarApp(),
              _buildPoints(context),
            ],
            )
          ],
        ),
      ),
    );
  }

  Widget twoButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        FlatButton(
          splashColor: Colors.transparent,
          textColor: Colors.white,
          child: Text(FlutterI18n.translate(context, "skip_tutorial")),
          onPressed: () async {
            SharedPreferences preferences =
            await SharedPreferences.getInstance();
            await preferences.setBool("firstTime", false);
            Navigator.pushReplacementNamed(context, '/index');
          },
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          child: RaisedButton(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  FlutterI18n.translate(context, "next"),
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Icon(
                    Icons.arrow_forward,
                    color: Theme.of(context).primaryColor,
                  ),
                )
              ],
            ),
            onPressed: () {
              nextPageModel();
            },
          ),
        )
      ],
    );
  }

  Widget _buildPoints(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: points,
      ),
    );
  }

  Widget _buildPointOn(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Container(
        width: 10.0,
        height: 10.0,
        decoration: BoxDecoration(
          color: Colors.teal[100],
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _buildPointOff(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Container(
        width: 10.0,
        height: 10.0,
        decoration: BoxDecoration(
          color: Colors.grey[400],
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class EmpezarApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      child: new RaisedButton(
        color: Colors.white,
        child: Text(
          FlutterI18n.translate(context, "start_app"),
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        onPressed: () async {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          await preferences.setBool("firstTime", false);
          Navigator.pushReplacementNamed(context, '/index');
        },
      ),
    );
  }
}
