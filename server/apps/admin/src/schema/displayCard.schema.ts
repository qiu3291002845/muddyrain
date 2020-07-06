import { ApiProperty } from '@nestjs/swagger';
import { prop } from "@typegoose/typegoose";

export class displayCard {
  @ApiProperty({
    description: '电脑显卡名称'
  })
  @prop({
    required: true
  })
  name: string

  @ApiProperty({
    description: '电脑显卡厂商'
  })
  @prop({
    required: true
  })
  company: string

  @ApiProperty({
    description: '电脑显卡版本'
  })
  @prop({
    required: true
  })
  version: string
}