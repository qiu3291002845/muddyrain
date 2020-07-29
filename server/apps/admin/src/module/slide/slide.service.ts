import { ReturnModelType } from '@typegoose/typegoose';
import { InjectModel } from 'nestjs-typegoose';
import { Slide } from './../../schema/slide.schema';
import { Injectable } from '@nestjs/common';

@Injectable()
export class SlideService {
  constructor(@InjectModel(Slide) private readonly slide: ReturnModelType<typeof Slide>) { }
  async create(img) {
    return await this.slide.create({ imgUrl: img });
  }
  async find(id?) {
    if (!id) {
      return await this.slide.find({});
    } else {
      return await this.slide.find({ _id: id });
    }
  }
  async update(id, body) {
    return await this.slide.updateOne({ _id: id }, body)
  }
  async delete(id) {
    return await this.slide.deleteOne({ _id: id });
  }
}
