import 'package:flutter/material.dart';
import 'package:flutter_app/provide/detail_info_provide.dart';
import 'package:provide/provide.dart';
import 'package:flutter_app/model/goods_model.dart';
import 'package:flutter_app/config/index.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

//商品详情页的商品说明
class DetailExplain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 10.0),
      padding: EdgeInsets.all(10.0),
      width: ScreenUtil().setWidth(750),
      child: Text(
        KString.detailsPageExplain, // 说明: > 急速送达 > 正品保证
        style: TextStyle(
          color: Colors.red,
          fontSize: ScreenUtil().setSp(30.0),
        ),
      ),
    );
  }
}
