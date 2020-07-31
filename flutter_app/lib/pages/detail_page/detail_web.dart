import 'package:flutter/material.dart';
import 'package:flutter_app/provide/detail_info_provide.dart';
import 'package:provide/provide.dart';
import 'package:flutter_app/model/goods_model.dart';
import 'package:flutter_screenutil/screenutil.dart';

//商品详情页的商品选项卡
class DetailWeb extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    GoodsModel goodsDetail =
        Provide.value<DetailsInfoProvide>(context).goodsInfo;
    // TODO: implement build
    return Provide<DetailsInfoProvide>(
      builder: (context, child, val) {
        var isLeft = Provide.value<DetailsInfoProvide>(context).isLeft;
        if (isLeft) {
          return Container(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(bottom: 2.0),
              primary: true,
              shrinkWrap: true,
              itemCount: goodsDetail.goodsDetail.length,
              itemBuilder: (context, i) {
                if(i == 0){
                  return SizedBox(
                    height: 0.0,
                  );
                }
                return Image.network(
                  "${goodsDetail.goodsDetail[i][0]}",
                  fit: BoxFit.cover,
                );
              },
            ),
          );
        } else {
          return Container(
            width: ScreenUtil().setWidth(750),
            padding: EdgeInsets.all(10),
            alignment: Alignment.center,
            child: Text('暂时没有数据'),
          );
        }
      },
    );
  }
}
