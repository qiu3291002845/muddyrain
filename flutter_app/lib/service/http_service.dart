import 'package:dio/dio.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter_app/config/index.dart';

// 用config配置数据请求
Future requestData(url, {id}) async {
  try {
    Response response;
    Dio dio = Dio();
//    dio.options.contentType =
    //        ContentType.parse('application/x-www-form-urlencoded');

    // 发起 get 请求
    if (id == null) {
      response = await dio.get(servicePath[url]);
    } else {
      response = await dio.get("${servicePath[url]}/${id}");
    }
    return response;
  } catch (e) {
    return print(e);
  }
}
// 直接地址请求
Future requestUrl(url,{id}) async {
  try {
    Response response;
    Dio dio = Dio();
    // 发起 get 请求
    if (id == null) {
      response = await dio.get("http://10.0.2.2:3000/admin/api/${url}");
    } else {
      response = await dio.get("http://10.0.2.2:3000/admin/api/${url}/${id}");
    }
    return response;
  } catch (e) {
    return print(e);
  }
}


