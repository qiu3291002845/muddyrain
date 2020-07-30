import 'package:flutter_app/config/string.dart';
import 'package:flutter_app/pages/category_page.dart';
import 'package:flutter_app/pages/home_page.dart';
import 'package:flutter_app/pages/member_page.dart';
import 'package:flutter_app/pages/shoppingCart_page.dart';
import 'package:provide/provide.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/string.dart';
import 'package:flutter_app/provide/current_index_provide.dart';
import 'package:flutter_screenutil/screenutil.dart';
class IndexPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,width: 750,height: 1334,allowFontScaling: true);
    // TODO: implement build
    return Provide<CurrentIndexProvide>(
      builder: (context, child, val) {
        // 取到当前索引状态值
        int currentIndex =
            Provide.value<CurrentIndexProvide>(context).currentIndex;
        return Scaffold(
          backgroundColor: Color.fromRGBO(244, 245, 245, 1.0),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: currentIndex,
            items: bottomTabs,
            onTap: (index){
              Provide.value<CurrentIndexProvide>(context).changeIndex(index);
            },
          ),
          body: IndexedStack(
            index: currentIndex,
            children: tabBody,
          ),
        );
      },
    );
  }

  final List<BottomNavigationBarItem> bottomTabs = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      title: Text(KString.homeTile), // 首页
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.category),
      title: Text(KString.categroyTile), // 分类
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.shopping_cart),
      title: Text(KString.shoppingCatTile), // 购物车
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      title: Text(KString.memberTile), // 会员中心
    ),
  ];
  final List<Widget> tabBody = [
    HomePage(),
    CategoryPage(),
    ShoppingCartPage(),
    MemberPage(),
  ];
}
