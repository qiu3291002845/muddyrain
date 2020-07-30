import 'package:flutter/material.dart';

// 切换底部导航栏
class CurrentIndexProvide with ChangeNotifier {
  int currentIndex = 0;

  changeIndex(int newIndex) {
    // 将传递过来的索引值 赋值给 页面索引
    currentIndex = newIndex;
    // 通知给监听者
    notifyListeners();
  }
}
