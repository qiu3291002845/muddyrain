import { ApiProperty } from '@nestjs/swagger';
import { prop, modelOptions } from '@typegoose/typegoose';
// import * as mongoose from 'mongoose';
@modelOptions({
  schemaOptions: {
    // 开始时间检测
    timestamps: true,
  },
})
export class Slide {
  @ApiProperty({
    description: '轮播图片'
  })
  @prop()
  imgUrl: []
}