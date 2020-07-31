import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/provide/category_provide.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import 'package:flutter_app/config/index.dart';
import 'package:flutter_app/provide/cart_provide.dart';
import 'package:flutter_app/model/cart_info_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
// 购物车底部组件
class CartBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: EdgeInsets.all(5.0),
      color: Colors.white,
      width: ScreenUtil().setWidth(750),
      child: Provide<CartProvide>(
        builder: (context, child, cartProvide) {
          return Row(
            children: <Widget>[
              selectAllBtn(context),
              allPriceArea(context),
              goBtn(context),
            ],
          );
        },
      ),
    );
  }

  // 全选按钮
  Widget selectAllBtn(BuildContext context) {
    bool isAllCheck = Provide.value<CartProvide>(context).isAllCheck;
    return Container(
      child: Row(
        children: <Widget>[
          Checkbox(
            value: isAllCheck,
            activeColor: KColor.checkBoxColor,
            onChanged: (bool val) {
              Provide.value<CartProvide>(context).changeAllCheckBtnState(val);
            },
          ),
          Text(KString.allCheck), //全选
        ],
      ),
    );
  }

  // 合计区域
  Widget allPriceArea(BuildContext context) {
    double allPrice = Provide.value<CartProvide>(context).allPrice;
    String allPriceStr = allPrice.toStringAsFixed(2);
    return Container(
      width: ScreenUtil().setWidth(430),
      alignment: Alignment.centerRight,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                alignment: Alignment.centerRight,
                width: ScreenUtil().setWidth(200),
                child: Text(
                  KString.allPrice, // 合计'
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(36),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                width: ScreenUtil().setWidth(230),
                child: Text(
                  '￥${allPriceStr}',
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(36),
                      color: KColor.presentPriceColor),
                ),
              ),
            ],
          ),
          Container(
            alignment: Alignment.centerRight,
            width: ScreenUtil().setWidth(430),
            child: Text(
              KString.allPriceAdv, // 满66元免费配送，预购免费配送
              style: TextStyle(
                fontSize: ScreenUtil().setSp(22),
                color: Colors.black26,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 结算按钮
  Widget goBtn(BuildContext context) {
    int allGoodsCount = Provide.value<CartProvide>(context).allGoodsCount;
    double allPrice = Provide.value<CartProvide>(context).allPrice;
    String allPriceStr = allPrice.toStringAsFixed(2);
    return Container(
      width: ScreenUtil().setWidth(160),
      padding: EdgeInsets.only(left: 10),
      child: InkWell(
        onTap: () {
          Fluttertoast.showToast(
            msg: '您需要支付:${allPriceStr}元',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 1,
            backgroundColor: KColor.refreshColor,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        },
        child: Container(
          padding: EdgeInsets.all(10.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: KColor.primaryColor,
            borderRadius: BorderRadius.circular(3.0),
          ),
          child: Text(
            '结算(${allGoodsCount})',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
