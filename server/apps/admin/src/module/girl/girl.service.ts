import { GirlColthing } from './../../schema/girlcolthing.schema';
import { Schema } from '@nestjs/mongoose';
import { Injectable } from '@nestjs/common';
import { InjectModel } from 'nestjs-typegoose';
import { GirlCategory } from '../../schema/girlCategory.schema';

@Injectable()
export class GirlService {
  constructor(@InjectModel(GirlCategory) private readonly girlCategory, @InjectModel(GirlColthing) private readonly girlColthing) { }
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
  async find(count?) {
    return await this.girlColthing.find({}).populate('category');
  }
  async findOne(id) {
    return await this.girlColthing.findOne({_id:id}).populate('category');
  }
  async updateOne(id, json) {
    return await this.girlColthing.updateOne({ _id: id },json);
  }
  async deleteOne(id) {
    return await this.girlColthing.deleteOne({ _id: id });
  }
}
