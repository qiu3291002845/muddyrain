import 'package:flutter_app/pages/index_page.dart';
import 'config/index.dart';
import 'package:flutter/material.dart';
import 'provide/current_index_provide.dart';
import 'provide/category_goods_list_provide.dart';
import 'provide/category_provide.dart';
import 'package:provide/provide.dart';
import 'routes/routes.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter_app/routes/application.dart';
import 'provide/detail_info_provide.dart';
import 'provide/cart_provide.dart';

void main() {
  var currentIndexProvide = CurrentIndexProvide();
  var categoryProvide = CategoryProvide();
  var categoryGoodsListProvider = CategoryGoodsListProvider();
  var detailsInfoProvide = DetailsInfoProvide();
  var cartProvide = CartProvide();
  var providers = Providers();

  providers
    ..provide(Provider<CurrentIndexProvide>.value(currentIndexProvide))
    ..provide(Provider<CategoryProvide>.value(categoryProvide))
    ..provide(
        Provider<CategoryGoodsListProvider>.value(categoryGoodsListProvider))
    ..provide(Provider<DetailsInfoProvide>.value(detailsInfoProvide))
    ..provide(Provider<CartProvide>.value(cartProvide));
  runApp(
    ProviderNode(
      child: MyApp(),
      providers: providers,
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final router = Router();
    Routes.configureRoutes(router);
    Application.router = router;
    return Container(
      child: MaterialApp(
        title: KString.appTile,
        // Qiu秋梦商城
        debugShowCheckedModeBanner: false,
        // 生成路由
        onGenerateRoute: Application.router.generator,
        // 定制 APP主题
        theme: ThemeData(
          primaryColor: KColor.primaryColor,
        ),
        home: IndexPage(),
      ),
    );
  }
}
