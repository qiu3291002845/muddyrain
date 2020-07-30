import 'package:flutter/material.dart';
import 'package:flutter_app/provide/category_provide.dart';
import 'package:provide/provide.dart';
import 'package:flutter_app/service/http_service.dart';
import 'package:flutter_app/config/index.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'dart:convert';
import 'package:flutter_app/model/category_model.dart';
import 'package:flutter_app/provide/category_provide.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_app/model/goods_model.dart';
import 'package:flutter_app/provide/category_goods_list_provide.dart';

// 分类页面
class CategoryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CategoryPageState();
  }
}

class CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(
          KString.categroyTile,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        child: Row(
          children: <Widget>[
            LeftCategoryPage(),
            Column(
              children: <Widget>[
                RightCategoryPage(),
                CategoryGoodsPage(),
              ],
            )
          ],
        ),
      ),
    );
  }
}

// 左侧导航界面
class LeftCategoryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LeftCategoryPageState();
  }
}

class LeftCategoryPageState extends State<LeftCategoryPage> {
  List list = [];
  var listIndex = 0; // 分类索引
  @override
  void initState() {
    super.initState();
    _getCategory();
  }

  // 获取分类数据
  _getCategory() async {
    await requestData('first', id: null).then((value) {
      var data = json.decode(value.toString());
      CategoryModel category = CategoryModel.fromJson(data);
      setState(() {
        list = category.data;
      });
      Provide.value<CategoryProvide>(context).getSecondCategory(
          list[0].secondCategoryVO, '5f2160f5a7cc898568ea96ac');
    });
  }

  _getGoodList(context, {String firstCategoryId}) {
    var data = {
      'firstCategoryId': firstCategoryId == null
          ? Provide.value<CategoryProvide>(context).firstCategoryId
          : firstCategoryId,
      'secondCategoryId':
          Provide.value<CategoryProvide>(context).secondCategoryId,
      "page": 1
    };
    if (firstCategoryId != null) {
      requestUrl('girl/findFirst?id=${firstCategoryId}').then(
        (value) {
          var data = json.decode(value.toString());
          GoodsListModel goodList = GoodsListModel.fromJson(data);
          Provide.value<CategoryGoodsListProvider>(context)
              .getGoodsList(goodList.data);
        },
      );
    } else {
      requestUrl('girl/findFirst?id=5f216620a7aef58b9c9dfcb4').then(
        (value) {
          var data = json.decode(value.toString());
          GoodsListModel goodList = GoodsListModel.fromJson(data);
          Provide.value<CategoryGoodsListProvider>(context)
              .getGoodsList(goodList.data);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Provide<CategoryProvide>(
      builder: ((context, child, val) {
        // 获取分类商品
        _getGoodList(context);
        // 获取商品列表
        listIndex = val.firstCategoryIndex;
        return Container(
          width: ScreenUtil().setWidth(220),
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                width: 1,
                color: KColor.defaultBorderColor,
              ),
            ),
          ),
          child: ListView.builder(
            itemBuilder: (context, index) {
              return _leftInkWell(index);
            },
            itemCount: list.length,
          ),
        );
      }),
    );
  }

  Widget _leftInkWell(int index) {
    bool isClick = false;
    isClick = (index == listIndex) ? true : false;
    return InkWell(
      onTap: () {
        var secondCategoryList = list[index].secondCategoryVO;
        var firstCategoryId = list[index].firstCategoryId;
        Provide.value<CategoryProvide>(context)
            .changeFirstCategory(firstCategoryId, index);
        Provide.value<CategoryProvide>(context)
            .getSecondCategory(secondCategoryList, firstCategoryId);
        //TODO 获取商品列表
        _getGoodList(context, firstCategoryId: firstCategoryId);
      },
      child: Container(
        height: ScreenUtil().setHeight(90.0),
        padding: EdgeInsets.only(left: 10.0, top: 0),
        decoration: BoxDecoration(
          color: isClick ? Color.fromRGBO(245, 245, 245, 1.0) : Colors.white,
          border: Border(
            bottom: BorderSide(
              width: 1,
              color: KColor.defaultBorderColor,
            ),
            left: BorderSide(
              width: 2,
              color: isClick ? KColor.primaryColor : Colors.white,
            ),
          ),
        ),
        child: Center(
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 0,
              ),
              Image.network(
                '${list[index].image}',
                width: 30,
                height: 30,
                fit: BoxFit.cover,
              ),
              SizedBox(
                width: 10.0,
              ),
              Text(
                list[index].firstCategoryName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isClick ? KColor.primaryColor : Colors.black,
                  fontSize: ScreenUtil().setSp(28.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 右侧导航界面
class RightCategoryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return RightCategoryPageState();
  }
}

class RightCategoryPageState extends State<RightCategoryPage> {
  _getGoodList(context, {String secondCategoryId}) {
    var data = {
      'firstCategoryId':
          Provide.value<CategoryProvide>(context).firstCategoryId,
      'secondCategoryId': secondCategoryId,
      "page": 1
    };
    if(secondCategoryId == ""){
      requestUrl('girl/findFirst?id=${data['firstCategoryId']}').then(
            (value) {
          var data = json.decode(value.toString());
          GoodsListModel goodList = GoodsListModel.fromJson(data);
          Provide.value<CategoryGoodsListProvider>(context)
              .getGoodsList(goodList.data);
        },
      );
    }else {
      requestUrl('girl/findSecond?id=${secondCategoryId}').then(
            (value) {
          var data = json.decode(value.toString());
          GoodsListModel goodList = GoodsListModel.fromJson(data);
          if (goodList == null) {
            Provide.value<CategoryGoodsListProvider>(context).getGoodsList([]);
          } else {
            Provide.value<CategoryGoodsListProvider>(context)
                .getGoodsList(goodList.data);
          }
          print(goodList.data.length);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Provide<CategoryProvide>(
        builder: (context, child, categoryProvide) {
          return Container(
            height: ScreenUtil().setHeight(90),
            width: ScreenUtil().setWidth(520),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  width: 1,
                  color: KColor.defaultBorderColor,
                ),
              ),
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categoryProvide.secondCategoryList.length,
              itemBuilder: (context, index) {
                return _rightInkWel(
                    index, categoryProvide.secondCategoryList[index]);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _rightInkWel(int index, SecondCategoryVO item) {
    bool isClick = false;
    isClick =
        (index == Provide.value<CategoryProvide>(context).secondCategoryIndex)
            ? true
            : false;
    return InkWell(
      onTap: () {
        Provide.value<CategoryProvide>(context)
            .changeSecondCategory(item.secondCategoryId, index);
        // TODO 获取商品列表
        _getGoodList(context, secondCategoryId: item.secondCategoryId);
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
        child: Text(
          item.secondCategoryName,
          style: TextStyle(
            fontSize: ScreenUtil().setSp(28.0),
            color: isClick ? KColor.primaryColor : Colors.black,
          ),
        ),
      ),
    );
  }
}

// 右侧导航界面
class CategoryGoodsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CategoryGoodsPageState();
  }
}

class CategoryGoodsPageState extends State<CategoryGoodsPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Text('商品列表');
  }
}
