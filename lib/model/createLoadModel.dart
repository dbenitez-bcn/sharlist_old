import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class CreateLoadModel extends Model{
  bool isCreate=true;
  List<int> passValue = [1, 2, 3, 4]; //1-meat, 2-vegetable, 3-milk, 4-fish

  void changeIsCreate(){
    isCreate=!isCreate;
    notifyListeners();
  }

  void changePassIcon(int index) async{
    if(passValue[index]<4)passValue[index]=passValue[0]+1;
    else if (passValue[index]==4)passValue[index]=1;
    await notifyListeners();
  }

}