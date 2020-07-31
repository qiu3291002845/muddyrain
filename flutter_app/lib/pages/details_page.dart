import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import 'package:flutter_app/config/string.dart';
import 'package:flutter_app/service/http_service.dart';
import 'dart:convert';
import 'package:provide/provide.dart';
import 'package:flutter_app/provide/detail_info_provide.dart';
import 'detail_page/detail_top_area.dart';
import 'detail_page/detail_top_explain.dart';
import 'detail_page/detail_tabbar.dart';
import 'detail_page/detail_web.dart';
import 'detail_page/detail_bottom.dart';
class DetailsPage extends StatelessWidget {
  // 商品ID
  final String goodsId;

  DetailsPage(this.goodsId);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            KString.detailsPageTitle,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        body: FutureBuilder(
          future: _getGoodInfo(context),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Stack(
                children: <Widget>[
                  ListView(
                    children: <Widget>[
                      DetailTopArea(),
                      DetailExplain(),
                      DetailTabbar(),
                      DetailWeb(),
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child:  DetailBottom(),
                  ),
                ],
              );
            } else {
              return Text('加载中');
            }
          },
        ),
      ),
    );
  }

  Future _getGoodInfo(BuildContext context) async {
    await Provide.value<DetailsInfoProvide>(context).getGoodsInfo(goodsId);
    return '完成加载';
  }
}
