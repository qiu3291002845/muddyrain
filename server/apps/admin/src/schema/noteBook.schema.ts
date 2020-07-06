import { NoteBookBrand } from './noteBookBrand.schema';
import { ApiProperty } from '@nestjs/swagger';
import { prop, mongoose, Ref } from "@typegoose/typegoose";

export class NoteBook {
  @ApiProperty({
    description: '商品名称',
    required: true
  })
  @prop()
  name: string

  @ApiProperty({
    description: '商品品牌'
  })
  @prop({
    refType: mongoose.Schema.Types.ObjectId,
    ref: 'NoteBookBrand',
    required: true
  })
  brand: Ref<NoteBookBrand>

  @ApiProperty({
    description: '商品颜色'
  })
  @prop({
    required: true
  })
  color: []

  @ApiProperty({
    description: '商品副标题'
  })
  @prop({
    required: true
  })
  subtitle: string

  @ApiProperty({
    description: '商品价格'
  })
  @prop({
    required: true
  })
  price: string

  @ApiProperty({
    description: '商品分辨率'
  })
  @prop({
    required: true
  })
  resolution: string

  @ApiProperty({
    description: '处理器型号'
  })
  @prop({
    required: true
  })
  cpu: string

  @ApiProperty({
    description: '显卡'
  })
  @prop({
    required: true
  })
  displayCard: string

  @ApiProperty({
    description: '屏幕尺寸'
  })
  @prop({
    required: true
  })
  size: []

  @ApiProperty({
    description: '内存'
  })
  @prop({
    required: true
  })
  ram: string

  @ApiProperty({
    description: '硬盘种类'
  })
  @prop({
    required: true
  })
  hardDisk: string

  @ApiProperty({
    description: '硬盘容量'
  })
  @prop({
    required: true
  })
  hardDiskCapacity: string

  @ApiProperty({
    description: '操作系统'
  })
  @prop({
    required: true
  })
  os: string

  @ApiProperty({
    description: '缩略图'
  })
  @prop({
    required: true
  })
  imageUrl: []
}