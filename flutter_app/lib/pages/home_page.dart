import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/model/navigator_model.dart';
import 'package:provide/provide.dart';
import 'package:flutter_app/config/index.dart';
import 'package:flutter_app/service/http_service.dart';
import 'package:flutter_app/model/slide_model.dart';
import 'package:flutter_app/model/girl_model.dart';
import 'dart:async';
import 'dart:convert';

// 屏幕尺寸
import 'package:flutter_screenutil/screenutil.dart';

// 上拉加载刷新模块
import 'package:flutter_easyrefresh/easy_refresh.dart';

// 轮播图模块
import 'package:flutter_swiper/flutter_swiper.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomePageState();
  }
}

// AutomaticKeepAliveClientMixin 当前页不会刷新
class HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  // 轮播图数据模型
  SlideListModel slideList = SlideListModel([]);

  //初始化数据模型
  GirlListModel girlsList = GirlListModel([]);

  //初始化分类模型
  NavigatorListModel navigatorList = NavigatorListModel([]);
  // 火爆专区模型
  GirlListModel hotsList = GirlListModel([]);
  // 火爆专区页面
  int hotsIndex = 1;
  // diff 只刷新有变化的数据
  GlobalKey<RefreshFooterState> _footkey = GlobalKey<RefreshFooterState>();

  @override
  void initState() {
    super.initState();
    // 获取轮播图数据
    getSlide();
    // 获取 商品数据
    getGirls();
    // 获取 分类数据
    getNavigator();
    // 获取 火爆专区数据
    getHots();
  }

  // 请求轮播图数据
  void getSlide() async {
    await requestData('slide').then((value) {
      var data = json.decode(value.toString());
      // 设置状态刷新数据
      setState(() {
        // 将返回的数据转换成 Model
        slideList = SlideListModel.formJson(data);
      });
    });
  }

  // 获取分类数据
  void getNavigator() async {
    await requestData('first').then((value) {
      var data = json.decode(value.toString());
      // 给状态变量赋值
      setState(() {
        this.navigatorList = NavigatorListModel.fromJson(data);
      });
    });
  }

  //获取商品数据
  void getGirls() async {
    //调用请求方法传入url及表单数据
    await requestData('girl').then((value) {
      //返回数据进行Json解码
      var data = json.decode(value.toString());
      //设置状态刷新数据
      setState(() {
        //将返回的Json数据转换成Model
        girlsList = GirlListModel.fromJson(data);
      });
    });
  }
  //获取商品数据
  void getHots() async {
    //调用请求方法传入url及表单数据
    await requestUrl('girl?count=${this.hotsIndex}&sort=true').then((value) {
      //返回数据进行Json解码
      var data = json.decode(value.toString());
      //设置状态刷新数据
      setState(() {
        //将返回的Json数据转换成Model
        this.hotsList.data.addAll(GirlListModel.fromJson(data).data);
      });
    });
  }
  Widget build(BuildContext context) {
    if (slideList.data.length > 0) {
      return Scaffold(
        backgroundColor: Color.fromRGBO(244, 245, 245, 1.0),
        appBar: AppBar(
          title: Text(
            KString.homeTile,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        body: EasyRefresh(
          refreshFooter: ClassicsFooter(
            key: _footkey,
            bgColor: Colors.white,
            textColor: KColor.refreshColor,
            moreInfoColor: KColor.refreshColor,
            showMore: true,
            noMoreText: '',
            moreInfo: KString.loading,
            // 加载中
            loadReadyText: KString.loadReadyText, // 上拉加载
          ),
          child: ListView(
            children: <Widget>[
              SwiperDiy(
                slideDataList: this.slideList.data,
              ),
              TopNavigator(
                navigatorDataList: this.navigatorList.data,
              ),
              RecommedUi(
                recommedList: this.girlsList.data,
              ),
              FloorPic(
                floorPic: this.slideList.data,
              ),
              Floor(
                floor: this.slideList.data,
              ),
              _hotGoods(),
            ],
          ),
          loadMore: () async {
            this.hotsIndex++;
            this.getHots();
          },
        ),
      );
    } else {
      // TODO: 商品列表没有数据时返回空
      return Center(
        child: Text('加载中...'),
      );
    }
  }

  // TODO  火爆专区标题
  Widget hotTitle = Container(
    margin: EdgeInsets.only(top: 10.0),
    padding: EdgeInsets.all(5.0),
    alignment: Alignment.center,
    decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
            bottom: BorderSide(
          width: 0.5,
          color: KColor.defaultBorderColor,
        ))),
    child: Text(
      KString.hotGoodsTitleText,
      style: TextStyle(
        color: KColor.primaryColor,
      ),
    ),
  );
//
//  // TODO  火爆专区子项
  Widget _wrapList() {
    if (this.hotsList.data.length != 0) {
      List<Widget> listWidget = this.hotsList.data.map((e) {
        return InkWell(
          onTap: () {},
          child: Container(
            width: ScreenUtil().setWidth(360),
            color: Colors.white,
            padding: EdgeInsets.all(5.0),
            margin: EdgeInsets.only(bottom: 3.0),
            child: Column(
              children: <Widget>[
                Image.network(
                  e.goodsDetail[0][0],
                  width: ScreenUtil().setWidth(350),
                  height: ScreenUtil().setHeight(360),
                  fit: BoxFit.cover,
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  e.goodsName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: ScreenUtil().setSp(26.0)),
                ),
                Row(
                  children: <Widget>[
                    Text(
                      '￥${e.presentPrice}',
                      style: TextStyle(
                        color: KColor.presentPriceColor,
                      ),
                    ),
                    Text(
                      '￥${e.oriPrice}',
                      style: KFont.oriPriceStyle,
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      }).toList();
      return Wrap(
        spacing: 2,
        children: listWidget,
      );
    } else {
      return Text('');
    }
  }

  // 火爆专区页面
  Widget _hotGoods() {
    return Container(
      child: Column(
        children: <Widget>[
          hotTitle,
          _wrapList(),
        ],
      ),
    );
  }
  // 保持 数据
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class SwiperDiy extends StatelessWidget {
  final List slideDataList;

  SwiperDiy({Key key, this.slideDataList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      color: Colors.white,
      height: ScreenUtil().setHeight(333),
      width: ScreenUtil().setWidth(750),
      child: Swiper(
        itemCount: slideDataList.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
            },
            child: Image.network(
              "${slideDataList[index].imgUrl[0][0]}",
              fit: BoxFit.cover,
            ),
          );
        },
        pagination: SwiperPagination(),
        autoplay: true,
      ),
    );
  }
}

// 分类图标展示
class TopNavigator extends StatelessWidget {
  final List navigatorDataList;

  TopNavigator({Key key, this.navigatorDataList}) : super(key: key);

  Widget _girdViewItemUi(BuildContext context, item, index) {
    return InkWell(
      onTap: () {
        // 跳转到分类页面
      },
      child: Column(
        children: <Widget>[
          Image.network(
            item.image,
            width: ScreenUtil().setWidth(95),
          ),
          Text(item.firstCategoryName),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (navigatorDataList.length > 10) {
      navigatorDataList.removeRange(10, navigatorDataList.length);
    }
    var tempIndex = -1;
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 5.0),
      height: ScreenUtil().setHeight(300.0),
      padding: EdgeInsets.all(3.0),
      child: GridView.count(
        crossAxisCount: 5,
        padding: EdgeInsets.all(4.0),
        // 禁止 网格布局滚动
        physics: NeverScrollableScrollPhysics(),
        children: navigatorDataList.map((item) {
          tempIndex++;
          return _girdViewItemUi(context, item, tempIndex);
        }).toList(),
      ),
    );
  }
}

// 推荐商品
class RecommedUi extends StatelessWidget {
  final List recommedList;

  RecommedUi({Key key, this.recommedList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (recommedList.length > 16) {
      recommedList.removeRange(16, recommedList.length);
    }
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: Column(
        children: <Widget>[
          _titleWidget(),
          _recommedList(context),
        ],
      ),
    );
  }

// 推荐商品标题
  Widget _titleWidget() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(10.0, 2.0, 0, 5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            width: 0.5,
            color: KColor.defaultBorderColor,
          ),
        ),
      ),
      child: Text(
        KString.recommendText, // 商品推荐
        style: TextStyle(
          color: KColor.homeSubtitleColor,
        ),
      ),
    );
  }

  // 商品推荐列表
  Widget _recommedList(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(380),
      child: ListView.builder(
        // 横向
        scrollDirection: Axis.horizontal,
        itemCount: recommedList.length,
        itemBuilder: (context, index) {
          return _item(index, context);
        },
      ),
    );
  }

  Widget _item(index, context) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: ScreenUtil().setWidth(300.0),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            left: BorderSide(
              color: KColor.defaultBorderColor,
              width: 0.5,
            ),
          ),
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Image.network(
                "${recommedList[index].goodsDetail[0][0]}",
                fit: BoxFit.cover,
              ),
            ),
            Text(
              "￥${recommedList[index].presentPrice}",
              style: TextStyle(
                color: KColor.presentPriceColor,
              ),
            ),
            Text(
              "￥${recommedList[index].oriPrice}",
              style: KFont.oriPriceStyle,
            ),
          ],
        ),
      ),
    );
  }
}

// 商品推荐中间广告
class FloorPic extends StatelessWidget {
  final List floorPic;

  FloorPic({Key key, this.floorPic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(250),
      margin: EdgeInsets.only(top: 10.0),
      child: InkWell(
        onTap: () {},
        child: Image.network(
          floorPic[6].imgUrl[0][0],
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

// TODO  商品推荐下层
class Floor extends StatelessWidget {
  final List floor;

  Floor({Key key, this.floor}) : super(key: key);

  void jumpDetail(context, String goodId) {
    // TODO  跳转到商品详情
  }

  @override
  Widget build(BuildContext context) {
// TODO     double width = ScreenUtil.defaultWidth as double;
    return Container(
      child: Row(
        children: <Widget>[
          // TODO  左侧商品
          Expanded(
            child: Column(
              children: <Widget>[
                // TODO  左上角图片
                Container(
                  padding: EdgeInsets.only(top: 3),
                  height: ScreenUtil().setHeight(400),
                  child: InkWell(
                    child: Image.network(
                      floor[0].imgUrl[0][0],
                      fit: BoxFit.cover,
                    ),
                    onTap: () {
                      jumpDetail(context, floor[0].id);
                    },
                  ),
                ),
                // TODO  左下图
                Container(
                  padding: EdgeInsets.only(),
                  height: ScreenUtil().setHeight(200),
                  child: InkWell(
                    child: Image.network(
                      floor[1].imgUrl[0][0],
                      fit: BoxFit.cover,
                    ),
                    onTap: () {
                      jumpDetail(context, floor[1].id);
                    },
                  ),
                ),
              ],
            ),
          ),
          // TODO  右侧商品
          Expanded(
            child: Column(
              children: <Widget>[
                // TODO  右上图
                Container(
                  padding: EdgeInsets.only(top: 3, left: 1, bottom: 1),
                  height: ScreenUtil().setHeight(200),
                  child: InkWell(
                    child: Image.network(
                      floor[2].imgUrl[0][0],
                      fit: BoxFit.cover,
                    ),
                    onTap: () {
                      jumpDetail(context, floor[2].id);
                    },
                  ),
                ),
                // TODO  右中图
                Container(
                  padding: EdgeInsets.only(top: 1, left: 1),
                  height: ScreenUtil().setHeight(200),
                  child: InkWell(
                    child: Image.network(
                      floor[3].imgUrl[0][0],
                      fit: BoxFit.cover,
                    ),
                    onTap: () {
                      jumpDetail(context, floor[3].id);
                    },
                  ),
                ),
                // TODO  右下图
                Container(
                  padding: EdgeInsets.only(top: 1, left: 1),
                  height: ScreenUtil().setHeight(200),
                  child: InkWell(
                    child: Image.network(
                      floor[4].imgUrl[0][0],
                      fit: BoxFit.cover,
                    ),
                    onTap: () {
                      jumpDetail(context, floor[4].id);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
      ),
    );
  }
// TODO  推荐商品标题
}
