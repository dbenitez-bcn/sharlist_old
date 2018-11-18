import 'package:flutter/material.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'dart:io' show Platform;

MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
  keywords: <String>['shop', 'supermarket', 'shopping list', 'family', 'products', 'lists', 'e-commerce'],
  designedForFamilies: true,
  testDevices: ["998B4D8DB36FBE01CD594FE7C555A025"]
);

String getAppId(){
  if (Platform.isIOS) return 'ca-app-pub-9458621217720467~3725135245';
  else if (Platform.isAndroid) return 'ca-app-pub-9458621217720467~9539008203';
  return null;
}
String _getBannerId(){
  if (Platform.isIOS) return 'ca-app-pub-9458621217720467/2479093066';
  else if (Platform.isAndroid) return 'ca-app-pub-9458621217720467/4771280148';
  return null;
}

BannerAd buildBanner(){
  return BannerAd(
    adUnitId: _getBannerId(),
    size: AdSize.banner,
    targetingInfo: targetingInfo,
  );
}

Widget bannerSeparator(BuildContext context) => SizedBox(width: MediaQuery.of(context).size.width, height: 50.0,);