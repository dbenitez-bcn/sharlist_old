import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class TutorialModel extends Model {
  bool twoButtons = true;
  final pageController = PageController(
    initialPage: 0,
  );

  void nextPageModel() {
    var newPage = pageController.page.round() + 1;
    pageController.nextPage(
        duration: Duration(milliseconds: 500), curve: Curves.ease);
    changePage(newPage);
  }

  void changeButtons() {
    twoButtons = false;
    notifyListeners();
  }

  void changePage(int currentPage) {
    if (currentPage == 2)
      twoButtons = false;
    else {
      twoButtons = true;
    }
    notifyListeners();
  }
}
