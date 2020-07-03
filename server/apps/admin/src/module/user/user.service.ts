import { UserDto } from './../../interface/user.interface';
import { User } from '../../schema/user.schema';
import { Injectable } from '@nestjs/common';
import { InjectModel } from 'nestjs-typegoose';


@Injectable()
export class UserService {
  constructor(@InjectModel(User) private readonly userModel) { }
  async find() {
    return await this.userModel.find()
  }
  async findOne(id) {
    return await this.userModel.findOne({ _id: id })
  }
  async update(id, json) {
    return await this.userModel.update({ _id: id }, json)
  }
  async create(json: UserDto) {
    return await this.userModel.create(json)
  }
  async remove(id) {
    return await this.userModel.deleteOne({ _id: id })
  }
  async updatePass(id, pass) {
    return await this.userModel.updateOne({ _id: id }, { password: pass })
  }
  async findUsername(username) {
    return await this.userModel.findOne({ username: username })
  }
}
