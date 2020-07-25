import { GirlCategory } from './girlCategory.schema';
import { ApiProperty } from '@nestjs/swagger';
import { ModelOptions, mongoose, Ref, prop } from "@typegoose/typegoose";
@ModelOptions({
  schemaOptions: {
    timestamps: true
  }
})
export class GirlColthing {
  @prop()
  @ApiProperty({
    description: '商品名称',
    required: true
  })
  goodsName: string

  @prop()
  @ApiProperty({
    description: '商品现价',
    required: true
  })
  presentPrice:string

  @prop()
  @ApiProperty({
    description: '商品原价',
    required: true
  })
  oriPrice: string

  @prop()
  @ApiProperty({
    description: '商品图片',
    required: true
  })
  goodsDetail: []

  @prop()
  @ApiProperty({
    description: '商品图片',
    required: true
  })
  amount: string

  @prop({
    refType: mongoose.Schema.Types.ObjectId,
    ref: 'GirlCategory',
    required: true,
  })
  @ApiProperty({
    description: '商品类别',
    required: true,
  })
  category: Ref<GirlCategory>
}