import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:on_list/tutorial/tutorial.dart';
void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  Future<bool> isFirstTime() async{
    final prefs = await SharedPreferences.getInstance();
    final firstTime = prefs.getBool('welcome') !=null ? true: false;
    if(!firstTime)prefs.setBool('welcome', true);
    print("dentro del metodo $firstTime");
    return firstTime;
  }
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Onlist',
      theme: new ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: _myHome(context),
      localizationsDelegates: [
        FlutterI18nDelegate(false, 'es'),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
    );
  }

  Widget _myHome(BuildContext context){
    return new FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder:
          (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return _loading(context);
          default:
            if (!snapshot.hasError) {
        return snapshot.data.getBool("welcome") != null
        ? new Text("Second Time")
            : Tutorial();
        } else {
        return new Text("Error :(");
        }
      }
      },
    );
  }

  Widget _loading(BuildContext context){
  return Scaffold(
    body: Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width*0.5,
        height: MediaQuery.of(context).size.width*0.5,
        child: CircularProgressIndicator(strokeWidth: 10.0,),
      ),
    ),
  );
  }
}



class MyHomePage extends StatefulWidget {
  @override
  MyHomeState createState() => new MyHomeState();
}

class MyHomeState extends State<MyHomePage> {

  String currentLang = 'en';

  switchLang() {
    setState(() {
      currentLang = currentLang == 'en' ? 'es' : 'en';
    });
  }

  void changeLang(BuildContext context)async{
    print("tu sabe");
    await FlutterI18n.refresh(context, 'es');
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      changeLang(context);
    });
    return new Scaffold(
      appBar:
      new AppBar(title: new Text(FlutterI18n.translate(context, "title"))),
      body: new Builder(builder: (BuildContext context) {
        return new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text(FlutterI18n.translate(context, "label.main",
                  Map.fromIterables(["user"], ["Flutter lover"]))),
              new FlatButton(
                  onPressed: () async {
                    switchLang();
                    await FlutterI18n.refresh(context, currentLang);
                    Scaffold.of(context).showSnackBar(new SnackBar(
                      content: new Text(
                          FlutterI18n.translate(context, "toastMessage")),
                    ));
                  },
                  child: new Text(
                      FlutterI18n.translate(context, "button.clickMe")))
            ],
          ),
        );
      }),
    );
  }
}
