import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:on_list/model/tutorialModel.dart';
import 'package:scoped_model/scoped_model.dart';

class Tutorial extends StatefulWidget {
  @override
  _TutorialState createState() => new _TutorialState();
}

class _TutorialState extends State<Tutorial> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: ScopedModel<TutorialModel>(
        model: TutorialModel(),
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: <Widget>[
            PageViewPictures(),
            ScopedModelDescendant<TutorialModel>(
              builder: (context, _, model) => SafeArea(
                child: model.twoButtons ? TwoButtons() : EmpezarApp(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PageViewPictures extends StatefulWidget {
  @override
  _PageViewPicturesState createState() => new _PageViewPicturesState();
}

class _PageViewPicturesState extends State<PageViewPictures> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<TutorialModel>(
      builder: (context, _, model) => SizedBox.expand(
            child: PageView(
              controller: model.pageController,
              onPageChanged: (currentPage) {
                model.changePage(currentPage);
              },
              children: <Widget>[
                Container(
                  color: Colors.red,
                ),
                Container(
                  color: Colors.blue,
                ),
                Container(
                  color: Colors.green,
                ),
                /*
                  _buildPage(context, "assets/images/page1.jpg"),
                  _buildPage(context, "assets/images/page2.jpg"),
                  _buildPage(context, "assets/images/page3.jpg"),
                  */
              ],
            ),
          ),
    );
  }

  Widget _buildPage(BuildContext context, String img) {
    return Container(
      color: Colors.pink[400],
      child: Image.asset(
        img,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
      ),
    );
  }
}

class TwoButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<TutorialModel>(
      builder: (context, _, model) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              FlatButton(
                textColor: Colors.white,
                child: Text(FlutterI18n.translate(context, "skip_tutorial")),
                onPressed: () {},
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
                          color: Colors.pinkAccent,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.pinkAccent,
                        ),
                      )
                    ],
                  ),
                  onPressed: () {
                    //model.pageController.nextPage(duration: null, curve: null);
                    model.nextPageModel();
                  },
                ),
              )
            ],
          ),
    );
  }
}

class EmpezarApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width*0.7,
      child: new RaisedButton(
          color: Colors.white,
          child: Text("To app", style: TextStyle(color: Colors.pinkAccent),),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/createLoad');
          }),
    );
  }
}