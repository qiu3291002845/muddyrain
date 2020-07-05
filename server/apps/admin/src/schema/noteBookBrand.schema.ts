import { ApiProperty } from '@nestjs/swagger';
import { prop } from "@typegoose/typegoose";

export class NoteBookBrand {
  @ApiProperty({
    description: '笔记本品牌名称',
    example: '小米'
  })
  @prop({
    unique: true
  })
  name: string

  @ApiProperty({
    description: '笔记本品牌英文名称',
    example: 'xiaomi'
  })
  @prop({
    unique: true
  })
  ename: string

  @ApiProperty({
    description: '笔记本品牌英文名称',
    example: 'xiaomi'
  })
  @prop({
    default: 'https://muddyrain.oss-cn-beijing.aliyuncs.com/images/20200705/1012063.png'
  })
  imageUrl: string
}