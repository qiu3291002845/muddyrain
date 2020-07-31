import 'package:flutter/material.dart';
import 'package:flutter_app/pages/cart_page/cart_bottom.dart';
import 'package:provide/provide.dart';
import 'package:flutter_app/config/string.dart';
import 'package:flutter_app/provide/cart_provide.dart';
import 'cart_page/cart_item.dart';
class ShoppingCartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(
          KString.shoppingCatTile,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: FutureBuilder(
        future: _getCartInfo(context),
        builder: (context, snapshot) {
          List cartList = Provide.value<CartProvide>(context).cartList;
          if (snapshot.hasData) {
            return Stack(
              children: <Widget>[
                Provide<CartProvide>(
                  // 监听 数据更改 告诉页面监听者
                  builder: (context, child, cartProvide) {
                    cartList = Provide.value<CartProvide>(context).cartList;
                    return ListView.builder(
                      itemCount: cartList.length,
                      itemBuilder: (context, index) {
                        return CartItem(cartList[index]);
                      },
                    );
                  },
                ),
                Positioned(
                  left: 0,
                  bottom: 0,
                  child: CartBottom(),
                ),
              ],
            );
            return Text('${cartList.length}');
          } else {
            return Text('加载中');
          }
        },
      ),
    );
  }

  Future _getCartInfo(BuildContext context) async {
    await Provide.value<CartProvide>(context).getCartInfo();
    return '完成加载';
  }
}
