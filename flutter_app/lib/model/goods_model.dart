class GoodsListModel {
  // 商品列表数据
  List<GoodsModel> data;

  //构造方法 初始化时可传入空数组[]即可
  GoodsListModel(this.data);

  // 通过传入的Json 抓换成数据模型
  GoodsListModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = List<GoodsModel>();
      // 循环迭代 JSON 数据 并将其每一项数据转换成 GirlModel
      json['data'].forEach((v) {
        data.add(GoodsModel.fromJson(v));
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

class GoodsModel {
  // 商品图片
  List goodsDetail;

  // 原价
  String oriPrice;

  // 现价
  String presentPrice;

  // 库存
  String amount;

  // 名称
  String goodsName;

  // iD
  String id;

  // 一级分类
  Map firstCategoryName;

  // 二级分类
  Map secondCategoryName;

  GoodsModel(
      {this.goodsDetail,
      this.presentPrice,
      this.oriPrice,
      this.id,
      this.amount,
      this.goodsName,
      this.firstCategoryName,
      this.secondCategoryName});

  // 通过传入的Json 抓换成数据模型
  GoodsModel.fromJson(Map<String, dynamic> json) {
    goodsDetail = json['goodsDetail'];
    oriPrice = json['oriPrice'];
    presentPrice = json['presentPrice'];
    id = json['_id'];
    amount = json['amount'];
    goodsName = json['goodsName'];
    firstCategoryName = json['firstCategoryName'];
    secondCategoryName = json['secondCategoryName'];
  }

  // 将数据模型转换成 json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['goodsDetail'] = this.goodsDetail;
    data['oriPrice'] = this.oriPrice;
    data['presentPrice'] = this.presentPrice;
    data['id'] = this.id;
    data['amount'] = this.amount;
    data['goodsName'] = this.goodsName;
    data['secondCategoryName'] = this.secondCategoryName;
    data['firstCategoryName'] = this.firstCategoryName;
    return data;
  }
}
