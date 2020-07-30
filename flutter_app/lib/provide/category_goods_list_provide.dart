import 'package:flutter/material.dart';
import 'package:flutter_app/model/goods_model.dart';

//分类商品列表数据
class CategoryGoodsListProvider with ChangeNotifier{

  List<GoodsModel> goodsList = [];

  getGoodsList(List<GoodsModel> list){
    goodsList = list;
    notifyListeners();
  }

  //上拉加载列表 追回列表数据
  addGoodsList(List<GoodsModel> list){
    goodsList.addAll(list);
    notifyListeners();
  }

}