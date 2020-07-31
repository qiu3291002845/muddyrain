import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import 'package:flutter_app/config/index.dart';
import 'package:flutter_app/provide/cart_provide.dart';
import 'package:flutter_app/model/cart_info_model.dart';

// 购物车计数
class CartCount extends StatelessWidget {
  final CartInfoModel item;

  CartCount(this.item);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: ScreenUtil().setWidth(165),
      margin: EdgeInsets.only(top: 5.0),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: KColor.defaultBorderColor),
      ),
      child: Row(
        children: <Widget>[
          _reduceBtn(context),
          _showBtn(),
          _addBtn(context),
        ],
      ),
    );
  }

  Widget _reduceBtn(BuildContext context) {
    return InkWell(
      onTap: () {
        if (item.count > 1) {
          Provide.value<CartProvide>(context).addOrReduceAction(item, 'reduce');
        }
      },
      child: Container(
        width: ScreenUtil().setWidth(45),
        height: ScreenUtil().setHeight(45),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: item.count > 1 ? Colors.white : Colors.black12,
          border: Border(
            right: BorderSide(
              width: 1,
              color: KColor.defaultBorderColor,
            ),
          ),
        ),
        child: item.count > 1 ? Text('-') : Text('-'),
      ),
    );
  }

  Widget _addBtn(BuildContext context) {
    return InkWell(
      onTap: () {
        Provide.value<CartProvide>(context).addOrReduceAction(item, 'add');
      },
      child: Container(
        width: ScreenUtil().setWidth(45),
        height: ScreenUtil().setHeight(45),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            right: BorderSide(
              width: 1,
              color: KColor.defaultBorderColor,
            ),
          ),
        ),
        child: Text('+'),
      ),
    );
  }

  Widget _showBtn() {
    return Container(
      width: ScreenUtil().setWidth(70),
      height: ScreenUtil().setHeight(45),
      alignment: Alignment.center,
      color: Colors.white,
      child: Text('${item.count}'),
    );
  }
}
