import 'package:flutter/material.dart';
import 'package:flutter_app/provide/category_provide.dart';
import 'package:provide/provide.dart';
import 'package:flutter_app/service/http_service.dart';
import 'package:flutter_app/config/index.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'dart:convert';
import 'package:flutter_app/model/category_model.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_app/model/goods_model.dart';
import 'package:flutter_app/provide/category_goods_list_provide.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_app/routes/application.dart';
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
    _getNewGoods();
  }
  _getNewGoods(){
    requestUrl(
        'girl/findFirst?id=5f216620a7aef58b9c9dfcb4&count=1')
        .then(
          (value) {
        var data = json.decode(value.toString());
        GoodsListModel goodList = GoodsListModel.fromJson(data);
        Provide.value<CategoryGoodsListProvider>(context)
            .getGoodsList(goodList.data);
      },
    );
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
          list[0].secondCategoryVO, '5f216620a7aef58b9c9dfcb4');
    });
  }
  _getGoodList(context,  {String firstCategoryId}) {
    var data = {
      'firstCategoryId': firstCategoryId == null
          ? Provide.value<CategoryProvide>(context).firstCategoryId
          : firstCategoryId,
      'secondCategoryId':
          Provide.value<CategoryProvide>(context).secondCategoryId,
      "page": Provide.value<CategoryProvide>(context).page,
    };
    if (firstCategoryId == null) {
      requestUrl(
              'girl/findFirst?id=${data['firstCategoryId']}&count=${data['page']}')
          .then(
        (value) {
          var data = json.decode(value.toString());
          GoodsListModel goodList = GoodsListModel.fromJson(data);
          Provide.value<CategoryGoodsListProvider>(context)
              .getGoodsList(goodList.data);
        },
      );
    } else {
      requestUrl(
              'girl/findFirst?id=${data['firstCategoryId']}&count=${data['page']}')
          .then(
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
//        // 获取分类商品
//        _getGoodList(context);
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
      "page": Provide.value<CategoryProvide>(context).page,
      "page2": Provide.value<CategoryProvide>(context).page2,
    };
    if (secondCategoryId == "") {
      requestUrl(
              'girl/findFirst?id=${Provide.value<CategoryProvide>(context).firstCategoryId}')
          .then(
        (value) {
          var data = json.decode(value.toString());
          GoodsListModel goodList = GoodsListModel.fromJson(data);
          if (goodList.data.length == 0) {
            Provide.value<CategoryGoodsListProvider>(context).getGoodsList([]);
          } else {
            Provide.value<CategoryGoodsListProvider>(context)
                .getGoodsList(goodList.data);
          }
        },
      );
    } else {
      requestUrl(
              'girl/findSecond?id=${secondCategoryId}&count=${data['page2']}')
          .then(
        (value) {
          var data = json.decode(value.toString());
          GoodsListModel goodList = GoodsListModel.fromJson(data);
          if (goodList.data.length == 0) {
            Provide.value<CategoryGoodsListProvider>(context).getGoodsList([]);
          } else {
            Provide.value<CategoryGoodsListProvider>(context)
                .getGoodsList(goodList.data);
          }
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
        Provide.value<CategoryProvide>(context).changeIsSecondCategory();
        // TODO 获取商品列表
        Provide.value<CategoryProvide>(context).page = 1;
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
  // 刷新处理
  GlobalKey<RefreshFooterState> _footerKey = GlobalKey<RefreshFooterState>();

  // 滚动控制
  var scrollContainer = new ScrollController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Provide<CategoryGoodsListProvider>(
      builder: (context, child, data) {
        try {
          if (Provide.value<CategoryProvide>(context).page == 1) {
            // 回到顶部
            scrollContainer.jumpTo(0.0);
          }
        } catch (e) {}
        if (data.goodsList.length > 0) {
          return Expanded(
            child: Container(
              width: ScreenUtil().setWidth(510),
              child: EasyRefresh(
                refreshFooter: ClassicsFooter(
                  key: _footerKey,
                  bgColor: Colors.white,
                  textColor: KColor.refreshColor,
                  moreInfoColor: KColor.refreshColor,
                  showMore: true,
                  noMoreText:
                      Provide.value<CategoryProvide>(context).noMoreText,
                  moreInfo: KString.loading,
                  // 加载中
                  loadReadyText: KString.loadReadyText, // 上拉加载
                ),
                child: ListView.builder(
                  controller: scrollContainer,
                  itemCount: data.goodsList.length,
                  itemBuilder: (context, index) {
                    // 列表项
                    return _ListWidget(data.goodsList, index);
                  },
                ),
                loadMore: () async {
                  if (Provide.value<CategoryProvide>(context).noMoreText ==
                      KString.noMoreText) {
                    Fluttertoast.showToast(
                      msg: KString.toBottomText,
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIos: 1,
                      backgroundColor: KColor.refreshColor,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  } else {
                    _getMoreList();
                  }
                },
              ),
            ),
          );
        } else {
//          _getMoreList();
          return Text(KString.noMoreData);
        }
      },
    );
  }

  // 上拉加载更多的方法
  void _getMoreList() {
    var data = {
      'firstCategoryId':
          Provide.value<CategoryProvide>(context).firstCategoryId,
      'secondCategoryId':
          Provide.value<CategoryProvide>(context).secondCategoryId,
    };
    if (data['secondCategoryId'] != "") {
      Provide.value<CategoryProvide>(context).addPage2();
    } else {
      Provide.value<CategoryProvide>(context).addPage();
    }
    var page = {
      "page": Provide.value<CategoryProvide>(context).page,
      "page2": Provide.value<CategoryProvide>(context).page2,
    };
    if (data['secondCategoryId'] != "") {
      requestUrl(
              'girl/findSecond?id=${data['secondCategoryId']}&count=${page['page2']}')
          .then(
        (value) {
          var data = json.decode(value.toString());
          GoodsListModel goodList = GoodsListModel.fromJson(data);
          if (goodList.data.length == 0) {
            Provide.value<CategoryProvide>(context)
                .changeNoMore(KString.noMoreText);
            Provide.value<CategoryProvide>(context).page = 1;
          } else {
            Provide.value<CategoryGoodsListProvider>(context)
                .addGoodsList(goodList.data);
          }
        },
      );
    } else {
        requestUrl(
              'girl/findFirst?id=${data['firstCategoryId']}&count=${page['page']}')
          .then(
        (value) {
          var data = json.decode(value.toString());
          GoodsListModel goodList = GoodsListModel.fromJson(data);
          if (goodList.data.length == 0) {
            Provide.value<CategoryProvide>(context)
                .changeNoMore(KString.noMoreText);
          } else {
            Provide.value<CategoryGoodsListProvider>(context)
                .addGoodsList(goodList.data);
          }
        },
      );
    }
  }

  Widget _ListWidget(List newList, int index) {
    return InkWell(
      onTap: () {
        // TODO 跳转到商品详情页
        Application.router.navigateTo(
            context, "/details?id=${newList[index].id}");
      },
      child: Container(
        padding: EdgeInsets.only(bottom: 5.0, top: 5.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              width: 1.0,
              color: KColor.defaultBorderColor,
            ),
          ),
        ),
        child: Row(
          children: <Widget>[
            // 商品图片
            _goodsImage(newList, index),
            // 商品列表项
            Column(
              children: <Widget>[
                _goodsName(newList, index),
                _goodsPrice(newList, index),
              ],
            )
          ],
        ),
      ),
    );
  }

  // 商品图片
  Widget _goodsImage(List newList, int index) {
    return Container(
      width: ScreenUtil().setWidth(200),
      child: Image.network(
        newList[index].goodsDetail[0][0],
        fit: BoxFit.cover,
      ),
    );
  }

  // 商品名称
  Widget _goodsName(List newList, int index) {
    return Container(
      padding: EdgeInsets.all(5.0),
      width: ScreenUtil().setWidth(310),
      child: Text(
        newList[index].goodsName,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: ScreenUtil().setSp(28),
        ),
      ),
    );
  }

  // 商品价格
  Widget _goodsPrice(List newList, int index) {
    return Container(
      margin: EdgeInsets.only(top: 20.0, left: 5.0),
      width: ScreenUtil().setWidth(300),
      child: Row(
        children: <Widget>[
          Text(
            "价格：￥${newList[index].presentPrice}",
            style: TextStyle(
              color: KColor.presentPriceColor,
            ),
          ),
          Text(
            "￥${newList[index].oriPrice}",
            style: KFont.oriPriceStyle,
          ),
        ],
      ),
    );
  }
}
