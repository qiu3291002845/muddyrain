import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import 'package:flutter_app/config/index.dart';
import 'package:flutter_app/provide/cart_provide.dart';
import 'package:flutter_app/model/cart_info_model.dart';
import 'cart_count.dart';
// 购物车商品列表项
class CartItem extends StatelessWidget {
  final CartInfoModel item;

  CartItem(this.item);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: EdgeInsets.only(left: 5.0, top: 2.0, right: 5.0, bottom: 2.0),
      padding: EdgeInsets.only(left: 5.0, top: 10.0, right: 5.0, bottom: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: KColor.defaultBorderColor,
          ),
        ),
      ),
      child: Row(
        children: <Widget>[
          _CartCheckBt(context, item),
          _CartImage(item),
          _CartGoodsName(item),
          _CartPrice(context, item),
        ],
      ),
    );
  }

  // 多选按钮
  Widget _CartCheckBt(BuildContext context, CartInfoModel item) {
    return Container(
      child: Checkbox(
        value: item.isCheck,
        activeColor: KColor.checkBoxColor,
        onChanged: (bool val) {
          item.isCheck = val;
          Provide.value<CartProvide>(context).changeCheckState(item);
        },
      ),
    );
  }

  // 商品图片
  Widget _CartImage(CartInfoModel item) {
    return Container(
      width: ScreenUtil().setWidth(150),
      padding: EdgeInsets.all(3.0),
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: KColor.defaultBorderColor)),
      child: Image.network('${item.images}'),
    );
  }

  // 商品名称
  Widget _CartGoodsName(CartInfoModel item) {
    return Container(
      width: ScreenUtil().setWidth(300),
      padding: EdgeInsets.all(10.0),
      alignment: Alignment.topLeft,
      child: Column(
        children: <Widget>[
          Text(
            '${item.goodsName}',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          // TODO 加减组件
          CartCount(item),
        ],
      ),
    );
  }
  Widget _CartPrice(BuildContext context,CartInfoModel item) {
    return Container(
      width: ScreenUtil().setWidth(150),
      padding: EdgeInsets.all(10.0),
      alignment: Alignment.centerRight,
      child: Column(
        children: <Widget>[
          Text(
            '￥${item.price}',
            style: TextStyle(
              color: KColor.presentPriceColor,
              fontSize: ScreenUtil().setSp(30.0),
            ),
          ),
          Container(
            child: InkWell(
              onTap: (){
                // 删除商品
                Provide.value<CartProvide>(context).deleteOneGoods(item.goodsId);
              },
              child: Icon(
                Icons.delete_forever,
                color: KColor.deleteColor,
                size: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
