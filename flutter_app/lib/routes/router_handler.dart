import 'package:fluro/fluro.dart';
import 'package:flutter_app/pages/details_page.dart';
import 'package:flutter/material.dart';

Handler detailsHandler = Handler(
  handlerFunc: (BuildContext context, Map<String,List<String>> params){
    String id = params['id'].first;
    return DetailsPage(id);
  }
);