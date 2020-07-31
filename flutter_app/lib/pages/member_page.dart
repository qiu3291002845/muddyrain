import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import 'package:flutter_app/config/index.dart';
import 'package:flutter_screenutil/screenutil.dart';

class MemberPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(
          KString.memberTile,
          style: TextStyle(
            color: Colors.white,
          ),
        ), //会员中心
      ),
      body: ListView(
        children: <Widget>[
          _topHeader(),
          _orderTitle(),
          _orderType(),
          _actionList(),
        ],
      ),
    );
  }

  Widget _topHeader() {
    return Container(
      width: ScreenUtil().setWidth(750),
      padding: EdgeInsets.all(20),
      color: KColor.primaryColor,
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 30),
            // 圆角盒子
            child: ClipOval(
              child: SizedBox(
                width: 200,
                height: 200,
                child: Image.asset(
                  'images/avatar.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              '浊雨不语',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(52.0),
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _orderTitle() {
    return Container(
      margin: EdgeInsets.only(top: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: KColor.defaultBorderColor,
          ),
        ),
      ),
      child: ListTile(
        leading: Icon(Icons.list),
        title: Text(KString.orderTitle),// 我的订单
        trailing: Icon(Icons.arrow_right),
      ),
    );
  }

  Widget _orderType() {
    return Container(
      margin: EdgeInsets.only(top: 5),
      width: ScreenUtil().setWidth(750),
      height: ScreenUtil().setHeight(150),
      padding: EdgeInsets.only(top:20.0),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(187),
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.payment,
                  size: 30,
                ),
                Text(KString.toFu), //待付款
              ],
            ),
          ),
          Container(
            width: ScreenUtil().setWidth(187),
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.directions_car,
                  size: 30,
                ),
                Text(KString.toFa), //待发货
              ],
            ),
          ),
          Container(
            width: ScreenUtil().setWidth(187),
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.directions_railway,
                  size: 30,
                ),
                Text(KString.toShou), //待收货
              ],
            ),
          ),
          Container(
            width: ScreenUtil().setWidth(187),
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.message,
                  size: 30,
                ),
                Text(KString.toPing), //待评价
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _myListTitle(String title,icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: KColor.defaultBorderColor,
          ),
        ),
      ),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: Icon(Icons.arrow_right),
      ),
    );
  }

  Widget _actionList() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          _myListTitle('领取优惠券',Icons.pages),
          _myListTitle('已领取优惠券',Icons.beenhere),
          _myListTitle('地址管理',Icons.location_on),
          _myListTitle('客服电话',Icons.phone_in_talk),
          _myListTitle('关于我们',Icons.contact_phone),
        ],
      ),
    );
  }
}
