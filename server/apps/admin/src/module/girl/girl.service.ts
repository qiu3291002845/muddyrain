import { Girl } from './../../schema/girl.schema copy';
import { SecondCategory } from './../../schema/secondCategory.schema';
import { GirlColthing } from './../../schema/girlcolthing.schema';
import { Schema } from '@nestjs/mongoose';
import { Injectable } from '@nestjs/common';
import { InjectModel } from 'nestjs-typegoose';
import { GirlCategory } from '../../schema/girlCategory.schema';
import { ReturnModelType } from '@typegoose/typegoose';
import { FirstCategory } from '../../schema/firstCategory.schema';

@Injectable()
export class GirlService {
  constructor(
    @InjectModel(GirlCategory) private readonly girlCategory,
    @InjectModel(GirlColthing) private readonly girlColthing: ReturnModelType<typeof GirlColthing>,
    @InjectModel(FirstCategory) private readonly girlFirst: ReturnModelType<typeof FirstCategory>,
    @InjectModel(SecondCategory) private readonly girlSecond: ReturnModelType<typeof SecondCategory>,
    @InjectModel(Girl) private readonly girl: ReturnModelType<typeof Girl>) { }
  async createCategory(json) {
    await this.girlCategory.create(json);
  }
  async createFirst(json) {
    await this.girlFirst.create(json);
  }
  async createSecond(json) {
    await this.girlSecond.create(json);
  }
  async findCategory({
    id,
    pageSize,
    count
  }) {
    if (id) {
      return await this.girlCategory.findOne({ _id: id });
    } else {
      return await this.girlCategory.find().limit(pageSize).skip(count);
    }
  }
  async findFirst({
    id,
    pageSize,
    count
  }) {
    if (id) {
      return await this.girlFirst.findOne({ _id: id }).populate('secondCategoryVO');
    } else {
      return await this.girlFirst.find().limit(pageSize).skip(count).populate('secondCategoryVO');
    }
  }
  async findSecond({
    id,
    pageSize,
    count
  }) {
    if (id) {
      return await this.girlSecond.findOne({ _id: id });
    } else {
      return await this.girlSecond.find().limit(pageSize).skip(count);
    }
  }
  async editCategory(id, json) {
    return await this.girlCategory.updateOne({ _id: id }, json);
  }
  async editFirst(id, json) {
    return await this.girlFirst.updateOne({ _id: id }, json);
  }
  async editSecond(id, json) {
    return await this.girlSecond.updateOne({ _id: id }, json);
  }
  async deleteCategory(id) {
    return await this.girlCategory.deleteOne({ _id: id });
  }
  async deleteFirst(id) {
    return await this.girlFirst.deleteOne({ _id: id });
  }
  async deleteSecond(id) {
    return await this.girlSecond.deleteOne({ _id: id });
  }
  async create(json) {
    await this.girl.create(json);
  }
  async find({
    count = null,
    pagesize = null,
    sort = null,
  }) {
    if (sort == 'true') {
      return await this.girl.find().limit(pagesize).skip(count).populate('firstCategoryName').populate('secondCategoryName').sort({ goodsName: 1 })
    } else if (sort == 'false') {
      return await this.girl.find().limit(pagesize).skip(count).populate('firstCategoryName').populate('secondCategoryName').sort({ goodsName: -1 })
    } else if (sort == null) {
      return await this.girl.find().limit(pagesize).skip(count).populate('firstCategoryName').populate('secondCategoryName').sort({ goodsName: 1 })
    }
  };

  async findLike(count?, pagesize?: number, keyword?) {
    let p: number = pagesize as number;
    if (count >= 0) {
      var query = new RegExp(keyword, 'i');//模糊查询参数  i 是 不区分大小写
      let c: number = count;
      return await this.girl.find(
        {
          $or: [
            { "goodsName": query },
            { "presentPrice": query },
            { "oriPrice": query },
          ]
        },
        {
          password: 0,
        },
        {
          sort: { _id: 1 },
          limit: pagesize * 1,
          skip: c * 1,
        },
      ).populate('firstCategoryName').populate('secondCategoryName');
    } else {
      var query = new RegExp(keyword, 'i');//模糊查询参数  i 是 不区分大小写
      return await this.girl.find(
        {
          $or: [
            { "goodsName": query },
            { "presentPrice": query },
            { "oriPrice": query },
          ]
        },
      ).populate('firstCategoryName').populate('secondCategoryName');
    }
  }
  async findGirlCategory(
    {
      count = null,
      pagesize = null,
      id
    }) {
    return await this.girl.find({ firstCategoryName: id }).limit(pagesize).skip(count).populate('firstCategoryName').populate('secondCategoryName');
  }
  async findGirlCategory2( {
    count = null,
    pagesize = null,
    id
  }) {
    return await this.girl.find({ secondCategoryName: id }).limit(pagesize).skip(count).populate('firstCategoryName').populate('secondCategoryName');
  }
  async findOne(id) {
    return await this.girl.findOne({ _id: id }).populate('firstCategoryName').populate('secondCategoryName');
  }
  async updateOne(id, json) {
    return await this.girl.updateOne({ _id: id }, json);
  }
  async deleteOne(id) {
    return await this.girl.deleteOne({ _id: id });
  }
}
