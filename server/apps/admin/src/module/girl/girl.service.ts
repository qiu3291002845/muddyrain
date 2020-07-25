import { GirlColthing } from './../../schema/girlcolthing.schema';
import { Schema } from '@nestjs/mongoose';
import { Injectable } from '@nestjs/common';
import { InjectModel } from 'nestjs-typegoose';
import { GirlCategory } from '../../schema/girlCategory.schema';
import { ReturnModelType } from '@typegoose/typegoose';

@Injectable()
export class GirlService {
  constructor(@InjectModel(GirlCategory) private readonly girlCategory, @InjectModel(GirlColthing) private readonly girlColthing: ReturnModelType<typeof GirlColthing>) { }
  async createCategory(json) {
    await this.girlCategory.create(json);
  }
  async findCategory({
    id,
    pageSize,
    count
  }) {
    if (id) {
      return await this.girlCategory.findOne({ _id: id });
    } else {
      return await this.girlCategory.find().limit(pageSize).skip(count)
    }
  }
  async editCategory(id, json) {
    return await this.girlCategory.updateOne({ _id: id }, json);
  }
  async deleteCategory(id) {
    return await this.girlCategory.deleteOne({ _id: id });
  }
  async create(json) {
    await this.girlColthing.create(json);
  }
  async find({
    count = null,
    pagesize = null,
    sort = null,
  }) {
    if (sort == 'true') {
      return await this.girlColthing.find().limit(pagesize).skip(count).populate('category').sort({ goodsName: 1 })
    } else if (sort == 'false') {
      return await this.girlColthing.find().limit(pagesize).skip(count).populate('category').sort({ goodsName: -1 })
    } else if (sort == null) {
      return await this.girlColthing.find().limit(pagesize).skip(count).populate('category').sort({ goodsName: 1 })
    }
  };

  async findLike(count?, pagesize?: number, keyword?) {
    let p: number = pagesize as number;
    if (count >= 0) {
      var query = new RegExp(keyword, 'i');//模糊查询参数  i 是 不区分大小写
      let c: number = count;
      return await this.girlColthing.find(
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
      ).populate('category')
    } else {
      var query = new RegExp(keyword, 'i');//模糊查询参数  i 是 不区分大小写
      return await this.girlColthing.find(
        {
          $or: [
            { "goodsName": query },
            { "presentPrice": query },
            { "oriPrice": query },
          ]
        },
      ).populate('category');
    }
  }
  async findOne(id) {
    return await this.girlColthing.findOne({ _id: id }).populate('category');
  }
  async updateOne(id, json) {
    return await this.girlColthing.updateOne({ _id: id }, json);
  }
  async deleteOne(id) {
    return await this.girlColthing.deleteOne({ _id: id });
  }
}
