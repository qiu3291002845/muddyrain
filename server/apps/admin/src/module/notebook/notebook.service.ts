import { NoteBookBrand } from './../../schema/noteBookBrand.schema';
import { Injectable } from '@nestjs/common';
import { InjectModel } from 'nestjs-typegoose';

@Injectable()
export class NotebookService {
  constructor(@InjectModel(NoteBookBrand) private brandModel) { }
  async findBrand(id?, pageSize?, count?) {
    if (id) {
      return await this.brandModel.find({ _id: id })
    } else {
      return await this.brandModel.find().limit(pageSize).skip(count)
    }
  }
  async createBrand(json) {
    return await this.brandModel.create(json)
  }
  async deleteBrand(id) {
    return await this.brandModel.deleteOne({ _id: id })
  }
  async updateBrand(id, json) {
    return await this.brandModel.updateOne({ _id: id }, json)
  }
}
