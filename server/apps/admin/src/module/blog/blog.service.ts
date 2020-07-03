import { BlogCatSchema } from '../../schema/blogCat.schema';
import { Injectable } from '@nestjs/common';
import { InjectModel } from 'nestjs-typegoose';

@Injectable()
export class BlogService {
  constructor(@InjectModel(BlogCatSchema) private readonly catModel) { }
  async findCat(id?) {
    return await this.catModel.find(id ? { _id: id } : {})
  }
  async createCat(json) {
    return await this.catModel.create(json)
  }
  async deleteCat(id) {
    return await this.catModel.deleteOne({ _id: id })
  }
  async updateCat(id, json) {
    return await this.catModel.updateOne({ _id: id }, json)
  }
}
