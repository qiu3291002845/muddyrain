import { ApiProperty } from '@nestjs/swagger';
import { prop, modelOptions, mongoose } from "@typegoose/typegoose";
@modelOptions({
  schemaOptions: {
    timestamps: true
  }
})
export class BlogSchema {
  @ApiProperty({
    description: '标题',
    example: '标题1'
  })
  @prop({

  })
  title: string

  @ApiProperty({
    description: '作者',
    example: '张三'
  })
  @prop({
    unique: true
  })
  author: string

  @ApiProperty({
    description: '所属分类',
    example: '前端'
  })
  @prop({
    refType: mongoose.Schema.Types.ObjectId,
    ref: 'BlogCatSchema'
  })
  catgory: any

  @ApiProperty({
    description: '内容',
    example: '内容'
  })
  @prop({

  })
  content: string
}