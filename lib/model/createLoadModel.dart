import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class CreateLoadModel extends Model{
  bool isCreate=true;

  void changeIsCreate(){
    isCreate=!isCreate;
    notifyListeners();
  }
}