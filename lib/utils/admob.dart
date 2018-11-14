import 'package:flutter/material.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'dart:io' show Platform;

MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
  keywords: <String>['shop', 'supermarket', 'shopping list', 'family', 'products', 'lists', 'e-commerce'],
  designedForFamilies: true,
);

String getAppId(){
  if (Platform.isIOS) return 'ca-app-pub-9458621217720467~3725135245';
  else if (Platform.isAndroid) return 'ca-app-pub-9458621217720467~3725135245';
  return null;
}

BannerAd buildBanner(){
  return BannerAd(
    adUnitId: BannerAd.testAdUnitId,
    size: AdSize.smartBanner,
    targetingInfo: targetingInfo,
  );
}

Widget bannerSeparator(BuildContext context) => SizedBox(width: MediaQuery.of(context).size.width, height: 50.0,);