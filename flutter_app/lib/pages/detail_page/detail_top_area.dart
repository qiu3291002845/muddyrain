import 'package:flutter/material.dart';
import 'package:flutter_app/provide/detail_info_provide.dart';
import 'package:provide/provide.dart';
import 'package:flutter_app/model/goods_model.dart';
import 'package:flutter_app/config/index.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
//商品详情页的首屏区域  图片 价格 UI展示
class DetailTopArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Provide<DetailsInfoProvide>(
      builder: (context, child, value) {
        GoodsModel goodsInfo =
            Provide.value<DetailsInfoProvide>(context).goodsInfo;
        if (goodsInfo != null) {
          return Container(
            color: Colors.white,
            padding: EdgeInsets.all(2.0),
            child: Column(
              children: <Widget>[
                _goodsImage(goodsInfo.goodsDetail),
                _goodsName(goodsInfo.goodsName),
                _goodsNum(goodsInfo.id),
                _goodsPrice(goodsInfo.presentPrice, goodsInfo.oriPrice),
              ],
            ),
          );
        } else {
          return Text(KString.loading);
        }
      },
    );
  }

  // 商品缩略图片
  Widget _goodsImage(url) {
    return Container(
      color: Colors.white,
      height: ScreenUtil().setHeight(900),
      width: ScreenUtil().setWidth(750),
      child: Swiper(
        itemCount: url.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
            },
            child: Image.network(
              "${url[index][0]}",
              fit: BoxFit.cover,
            ),
          );
        },
        pagination: SwiperPagination(),
        autoplay: true,
      ),
    );
  }

  // 商品名称
  Widget _goodsName(name) {
    return Container(
      width: ScreenUtil().setWidth(730),
      padding: EdgeInsets.only(left: 10.0,top: 10.0),
      child: Text(
        name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: ScreenUtil().setSp(30.0),
        ),
      ),
    );
  }

  // 商品编号
  Widget _goodsNum(num) {
    return Container(
      width: ScreenUtil().setWidth(730),
      padding: EdgeInsets.only(left: 10.0),
      margin: EdgeInsets.only(top: 8.0),
      child: Text(
        '编号:' + num,
        style: TextStyle(
          color: KColor.detailGoodIdColor,
        ),
      ),
    );
  }

  // 商品价格
  Widget _goodsPrice(present, ori) {
    return Container(
      width: ScreenUtil().setWidth(730),
      padding: EdgeInsets.only(left: 10.0),
      margin: EdgeInsets.only(top: 8.0),
      child: Row(
        children: <Widget>[
          Text(
            "￥${present}",
            style: TextStyle(
              color: KColor.presentPriceColor,
              fontSize: ScreenUtil().setSp(40.0),
            ),
          ),
          Text(
            "￥${ori}",
            style:TextStyle(
              color:Colors.black26,
              decoration: TextDecoration.lineThrough,
              fontSize: ScreenUtil().setSp(32.0),
            ),
          ),
        ],
      ),
    );
  }
}
