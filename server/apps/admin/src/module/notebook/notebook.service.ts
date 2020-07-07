import { computerCpu } from './../../schema/computerCpu';
import { Ref } from '@typegoose/typegoose';
import { NoteBook } from './../../schema/noteBook.schema';
import { NoteBookBrand } from './../../schema/noteBookBrand.schema';
import { Injectable } from '@nestjs/common';
import { InjectModel } from 'nestjs-typegoose';

@Injectable()
export class NotebookService {
  constructor(@InjectModel(NoteBookBrand) private brandModel, @InjectModel(NoteBook) private NoteBook) { }
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
  async create(json) {
    return await this.NoteBook.create(json);
  }
  async find(id?, pageSize?, count?) {
    if (id) {
      return await this.NoteBook.find({ _id: id }).populate('cpu').populate('displayCard').populate('brand')
    } else {
      return await this.NoteBook.find().populate('cpu').populate('displayCard').populate('brand').limit(pageSize).skip(count)
      return '煞笔'
    }
  }
  async findLike(keyword) {
    var query = new RegExp(keyword, 'i');//模糊查询参数  i 是 不区分大小写
    return await this.NoteBook.find(
      {
        $or: [
          { "name": query },
          { "color": query },
          { "price": query },
          { "ram": query },
          { "os": query },
          { "size": query },
          { "resolution": query },
          { "subtitle": query },
        ]
      }
    ).populate('cpu').populate('displayCard').populate('brand')
  }
  async update(id, json) {
    return await this.NoteBook.updateOne({ _id: id }, json)
  }
  async delete(id) {
    return await this.NoteBook.deleteOne({ _id: id });
  }
}
