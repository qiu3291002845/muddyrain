class SlideListModel {
  // 商品列表数据
  List<SlideModel> data;

  //构造方法 初始化时可传入空数组[]即可
  SlideListModel(this.data);

  // 通过传入的Json 抓换成数据模型
  SlideListModel.formJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = List<SlideModel>();
      // 循环迭代 JSON 数据 并将其每一项数据转换成 SlideModel
      json['data'].forEach((v) {
        data.add(SlideModel.formJson(v));
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

class SlideModel {
  // 商品图片
  List imgUrl;

  // iD
  String id;

  SlideModel({
    this.id,
    this.imgUrl,
  });

  // 通过传入的Json 抓换成数据模型
  SlideModel.formJson(Map<String, dynamic> json) {
    id = json['_id'];
    imgUrl = json['imgUrl'];
  }

  // 将数据模型转换成 json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['imgUrl'] = this.imgUrl;
    return data;
  }
}
