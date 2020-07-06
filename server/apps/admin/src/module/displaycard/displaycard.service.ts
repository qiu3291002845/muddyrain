import { InjectModel } from 'nestjs-typegoose';
import { Injectable } from '@nestjs/common';
import { displayCard } from '../../schema/displayCard.schema';

@Injectable()
export class DisplaycardService {
  constructor(@InjectModel(displayCard) private readonly displayCard) { }
  async find(id?, pageSize?, count?) {
    if (id) {
      return await this.displayCard.find({ _id: id })
    } else {
      return await this.displayCard.find().limit(pageSize).skip(count)
    }
  }
  async findLike(keyword) {
    var query = new RegExp(keyword, 'i');//模糊查询参数  i 是 不区分大小写
    return await this.displayCard.find(
      {
        $or: [
          { "name": query },
          { "version": query },
          { "company": query }
        ]
      }
    )
  }
  async create(json) {
    return await this.displayCard.create(json)
  }
  async delete(id) {
    return await this.displayCard.deleteOne({ _id: id })
  }
  async update(id, json) {
    return await this.displayCard.updateOne({ _id: id }, json)
  }
}
