import { SecondCategory } from './secondCategory.schema';
import { FirstCategory } from './firstCategory.schema';
import { GirlCategory } from './girlCategory.schema';
import { ApiProperty } from '@nestjs/swagger';
import { ModelOptions, mongoose, Ref, prop } from "@typegoose/typegoose";
@ModelOptions({
  schemaOptions: {
    timestamps: true
  }
})
export class Girl {
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
    ref: 'FirstCategory',
    required: true,
  })
  @ApiProperty({
    description: '一级分类',
    required: true,
  })
  firstCategoryName: Ref<FirstCategory>

  @prop({
    refType: mongoose.Schema.Types.ObjectId,
    ref: 'SecondCategory',
    required: true,
  })
  @ApiProperty({
    description: '二级分类',
    required: true,
  })
  secondCategoryName: Ref<SecondCategory>
}