import 'package:flutter/material.dart';
import 'package:flutter_app/provide/detail_info_provide.dart';
import 'package:flutter_app/model/goods_model.dart';
import 'package:provide/provide.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_app/provide/current_index_provide.dart';
import 'package:flutter_app/config/index.dart';
import 'package:flutter_app/provide/cart_provide.dart';
class DetailBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    GoodsModel goodsInfo = Provide.value<DetailsInfoProvide>(context).goodsInfo;
    var goodsId = goodsInfo.id;
    var goodsName = goodsInfo.goodsName;
    var count = 1;
    var price = double.parse(goodsInfo.presentPrice);
    var images = goodsInfo.goodsDetail[0][0];
    return Container(
      width: ScreenUtil().setWidth(750),
      color: Colors.white,
      height: ScreenUtil().setHeight(80),
      child: Row(
        children: <Widget>[
          Stack(
            children: <Widget>[
              InkWell(
                onTap: () {
                  // 跳转到购物车页面
                  Provide.value<CurrentIndexProvide>(context).changeIndex(2);
                  Navigator.pop(context);
                },
                child: Container(
                  width: ScreenUtil().setWidth(110),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.shopping_cart,
                    size: 35.0,
                    color: Colors.red,
                  ),
                ),
              ),
              // TODO 购物车商品数据
              Provide<CartProvide>(
                builder: (context,child,val){
                  int goodsCount = Provide.value<CartProvide>(context).allGoodsCount;
                  return  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(6, 3, 6, 3),
                      decoration: BoxDecoration(
                        color: Colors.deepOrange,
                        border: Border.all(
                          width: 2,
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Text(
                        '${goodsCount}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: ScreenUtil().setSp(22),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          InkWell(
            onTap: ()async {
              // TODO 添加至购物车
              await // 跳转到购物车页面
              Provide.value<CartProvide>(context).save(goodsId, goodsName, count, price, images);
            },
            child: Container(
              alignment: Alignment.center,
              width: ScreenUtil().setWidth(320),
              height: ScreenUtil().setHeight(80),
              color: Colors.orange,
              child: Text(
                '加入购物车',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ScreenUtil().setSp(30.0)
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () async{
              // TODO 马上购买

            },
            child: Container(
              alignment: Alignment.center,
              width: ScreenUtil().setWidth(320),
              height: ScreenUtil().setHeight(80),
              color: Colors.deepOrange,
              child: Text(
                '马上购买',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: ScreenUtil().setSp(30.0)
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
