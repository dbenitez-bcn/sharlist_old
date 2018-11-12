import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class TutorialModel extends Model {
  bool twoButtons = true;
  int currentPage = 0;
  final pageController = PageController(
    initialPage: 0,
  );

  void nextPageModel() {
    pageController.nextPage(
        duration: Duration(milliseconds: 500), curve: Curves.ease);
    changePage(pageController.page.round());
  }

  void changeButtons() {
    twoButtons = false;
    notifyListeners();
  }

  void changePage(int currentPage) {
    currentPage = pageController.page.round();
    if (currentPage == 6)
      twoButtons = false;
    else {
      twoButtons = true;
    }
    print(currentPage);
    notifyListeners();
  }
}
