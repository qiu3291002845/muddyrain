class NavigatorListModel {
  // 商品列表数据
  List<NavigatorModel> data;

  //构造方法 初始化时可传入空数组[]即可
  NavigatorListModel(this.data);

  // 通过传入的Json 抓换成数据模型
  NavigatorListModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = List<NavigatorModel>();
      // 循环迭代 JSON 数据 并将其每一项数据转换成 CategoryModelModel
      json['data'].forEach((v) {
        data.add(NavigatorModel.formJson(v));
      });
    }
  }

  // 将数据模型转换成 json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson());
    }
    return data;
  }
}
class NavigatorModel {
  String id;
  String firstCategoryName;
  String image;

  // 在构造函数中接收
  NavigatorModel(
    this.id,
    this.image,
    this.firstCategoryName,
  ) {}

  // 抓取传递来的json数据 转为数据模型
  NavigatorModel.formJson(Map<String, dynamic> json) {
    id = json['_id'];
    image = json['image'];
    firstCategoryName = json['firstCategoryName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['image']= image;
    data['firstCategoryName'] =firstCategoryName;
    return data;
  }
}
