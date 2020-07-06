import { computerCpu } from './../../schema/computerCpu';
import { InjectModel } from 'nestjs-typegoose';
import { Injectable } from '@nestjs/common';

@Injectable()
export class ComputercpuService {
  constructor(@InjectModel(computerCpu) private readonly computerCpu) { }
  async find(id?, pageSize?, count?) {
    if (id) {
      return await this.computerCpu.find({ _id: id })
    } else {
      return await this.computerCpu.find().limit(pageSize).skip(count)
    }
  }
  async findLike(keyword) {
    var query = new RegExp(keyword, 'i');//模糊查询参数  i 是 不区分大小写
    return await this.computerCpu.find(
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
    return await this.computerCpu.create(json)
  }
  async delete(id) {
    return await this.computerCpu.deleteOne({ _id: id })
  }
  async update(id, json) {
    return await this.computerCpu.updateOne({ _id: id }, json)
  }
}
