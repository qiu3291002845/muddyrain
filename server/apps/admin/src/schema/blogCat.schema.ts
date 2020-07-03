import { ApiProperty } from '@nestjs/swagger';
import { prop, modelOptions } from '@typegoose/typegoose';
// import * as mongoose from 'mongoose';
@modelOptions({
  schemaOptions: {
    // 开始时间检测
    timestamps: true,
  },
})
export class BlogCatSchema {
  @ApiProperty({
    description: '分类名称'
  })
  @prop()
  name: string
}