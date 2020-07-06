import { ApiProperty } from '@nestjs/swagger';
import { prop } from "@typegoose/typegoose";

export class computerCpu {
  @ApiProperty({
    description: '电脑CPU名称'
  })
  @prop({
    required: true
  })
  name: string

  @ApiProperty({
    description: '电脑CPU厂商'
  })
  @prop({
    required: true
  })
  company: string

  @ApiProperty({
    description: '电脑CPU版本'
  })
  @prop({
    required: true
  })
  version: string
}