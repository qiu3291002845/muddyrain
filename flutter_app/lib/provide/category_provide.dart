import 'package:flutter/material.dart';
import 'package:flutter_app/model/category_model.dart';
// 切换底部导航栏
class CategoryProvide with ChangeNotifier {
  List<SecondCategoryVO> secondCategoryList = []; // 二级分类列表
  int secondCategoryIndex = 0;// 二级分类索引
  int firstCategoryIndex = 0; // 一级分类索引
  String secondCategoryId = '';// 二级分类ID
  String firstCategoryId = '5f216620a7aef58b9c9dfcb4'; // 一级分类Id
  int page = 1; // 列表页面
  String noMoreText = '显示更多'; // 显示更多
  bool isNewCategory = true;
  // 首页点击类别更改
  changeFirstCategory(String id,int index){
    firstCategoryId = id;
    firstCategoryIndex = index;
    secondCategoryId = '';
    notifyListeners();
  }
  // 获取二级分类
  getSecondCategory(List<SecondCategoryVO> list,String id){
    isNewCategory = true;
    firstCategoryId = id;
    secondCategoryIndex = 0;
    page= 1;
    secondCategoryId = ""; //点击一级分类时 二级分类清空
    noMoreText ="";
    SecondCategoryVO all = SecondCategoryVO();
    all.secondCategoryId = "";
    all.secondCategoryName = "全部";
    secondCategoryList = [all];
    secondCategoryList.addAll(list);
    notifyListeners();
  }
  // 改变二类索引
  changeSecondCategory(String id,int index){
    isNewCategory = true;
    secondCategoryIndex = index;
    secondCategoryId = id;
    page = 1;
    noMoreText = '';
    notifyListeners();
  }
  addPage(){
    page++;
  }
  // 改变 noMore Text 数据
  changeNoMore(String text){
    noMoreText = text;
    notifyListeners();
  }
  // 改变是否是新数据
  changeFale(){
    isNewCategory = false;
  }
}
