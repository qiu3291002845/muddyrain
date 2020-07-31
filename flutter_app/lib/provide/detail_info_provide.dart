import 'package:flutter/material.dart';
import 'package:flutter_app/model/goods_model.dart';
import '../service/http_service.dart';
import 'dart:convert';

// 页面详情
class DetailsInfoProvide with ChangeNotifier {
  GoodsModel goodsInfo;
  bool isLeft = true;
  bool isRight = false;

  getGoodsInfo(String id) async {
    await requestData('girl', id: id).then((value) {
      var responseData = json.decode(value.toString());
      goodsInfo = GoodsModel.fromJson(responseData);
      notifyListeners();
    });
  }

  // 改变 选项卡 tabbar 的状态
  changeLeftAndRight(String changeState) {
    if (changeState == 'left') {
      isLeft = true;
      isRight = false;
    } else {
      isLeft = false;
      isRight = true;
    }
    notifyListeners();
  }
}


