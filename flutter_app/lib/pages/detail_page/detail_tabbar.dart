import 'package:flutter/material.dart';
import 'package:flutter_app/provide/detail_info_provide.dart';
import 'package:provide/provide.dart';
import 'package:flutter_app/model/goods_model.dart';
import 'package:flutter_app/config/index.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_app/provide/detail_info_provide.dart';

//商品详情页的商品选项卡
class DetailTabbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Provide<DetailsInfoProvide>(
      builder: (context, child, val) {
        var isLeft = Provide.value<DetailsInfoProvide>(context).isLeft;
        var isRight = Provide.value<DetailsInfoProvide>(context).isRight;
        return Container(
          margin: EdgeInsets.only(top: 15.0),
          child: Row(
            children: <Widget>[
              _myTabbarLeft(context, isLeft),
              _myTabbarRight(context, isRight),
            ],
          ),
        );
      },
    );
  }
  // 左侧选项卡
  Widget _myTabbarLeft(BuildContext context, bool isLeft) {
    return InkWell(
      onTap: (){
        Provide.value<DetailsInfoProvide>(context).changeLeftAndRight('left');
      },
      child: Container(
        padding: EdgeInsets.all(10.0),
        alignment: Alignment.center,
        width: ScreenUtil().setWidth(375),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              width: 1.0,
              color: isLeft?KColor.detailTextColor:KColor.defaultBorderColor, // 详情文本颜色
            ),
          ),
        ),
        child: Text(
          '详细',
          style: TextStyle(
            color: isLeft ? KColor.detailTextColor:Colors.black,
          ),
        ),
      ),
    );
  }
 // 右侧选项卡
  Widget _myTabbarRight(BuildContext context, bool isRight) {
    return InkWell(
      onTap: (){
        Provide.value<DetailsInfoProvide>(context).changeLeftAndRight('right');
      },
      child: Container(
        padding: EdgeInsets.all(10.0),
        alignment: Alignment.center,
        width: ScreenUtil().setWidth(375),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              width: 1.0,
              color: isRight?KColor.detailTextColor:KColor.defaultBorderColor, // 详情文本颜色
            ),
          ),
        ),
        child: Text(
          '评论',
          style: TextStyle(
            color: isRight ? KColor.detailTextColor:Colors.black,
          ),
        ),
      ),
    );
  }
}
