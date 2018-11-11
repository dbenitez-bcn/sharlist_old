import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:on_list/index/faqPage.dart';
import 'package:package_info/package_info.dart';
import 'dart:io' show Platform;
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';

class HelpWindow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(FlutterI18n.translate(context, "help"))),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    void openUrl(String url) async {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    void toRate() {
      if (Platform.isIOS) {
        const url = 'https://www.apple.com';
        openUrl(url);
      } else {
        const url = 'https://www.android.com';
        openUrl(url);
      }
    }

    void shareApp() {
      final RenderBox box = context.findRenderObject();
      final String text = FlutterI18n.translate(context, "shareApp");
      Share.share(text,
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    }

    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (BuildContext context, AsyncSnapshot<PackageInfo> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return CircularProgressIndicator();
          case ConnectionState.done:
            if (!snapshot.hasError)
              return ListView(
                children: <Widget>[
                  ListItem(
                    title: Text(FlutterI18n.translate(context, "faq")),
                    subtitle: Text(FlutterI18n.translate(context, "faq_large")),
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => FaqPage())),
                  ),
                  ListItem(
                    title: Text(FlutterI18n.translate(context, "version")),
                    subtitle: Text("${snapshot.data.version}"),
                  ),
                  ListItem(
                    title: Text(FlutterI18n.translate(context, "contact")),
                    subtitle: Text("homelist.app.contact@gmail.com"),
                  ),
                  ListItem(
                    title: Text(FlutterI18n.translate(context, "rate")),
                    subtitle: Row(
                      children: <Widget>[
                        Icon(
                          Icons.star_border,
                          color: Colors.grey,
                        ),
                        Icon(
                          Icons.star_border,
                          color: Colors.grey,
                        ),
                        Icon(
                          Icons.star_border,
                          color: Colors.grey,
                        ),
                        Icon(
                          Icons.star_border,
                          color: Colors.grey,
                        ),
                        Icon(
                          Icons.star_border,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    onTap: toRate,
                  ),
                  ListItem(
                    title: Text(FlutterI18n.translate(context, "share")),
                    subtitle:
                        Text(FlutterI18n.translate(context, "share_text")),
                    onTap: shareApp,
                  )
                ],
              );
            return Text("Error :(");
          default:
            CircularProgressIndicator();
        }
      },
    );
  }
}

class ListItem extends StatelessWidget {
  final Widget title;
  final Widget subtitle;
  final Function onTap;

  ListItem({this.title, this.subtitle, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: title,
          subtitle: subtitle,
          onTap: onTap != null ? onTap : () {},
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Divider(
            height: 0.0,
          ),
        ),
      ],
    );
  }
}
