import { ApiProperty } from '@nestjs/swagger';
import { prop } from "@typegoose/typegoose";

export class NoteBook {
  @ApiProperty({
    description: '商品名称'
  })
  @prop()
  name: string
}