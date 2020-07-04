import { User } from './user.schema';
import { BlogCatSchema } from './blogCat.schema';
import { ApiProperty } from '@nestjs/swagger';
import { prop, modelOptions, mongoose, Ref } from "@typegoose/typegoose";
@modelOptions({
  schemaOptions: {
    timestamps: true
  }
})
export class Blog {

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
    refType: mongoose.Schema.Types.ObjectId,
    ref: 'User'
  })
  author: Ref<User>

  @ApiProperty({
    description: '所属分类',
    example: '前端'
  })
  @prop({
    refType: mongoose.Schema.Types.ObjectId,
    ref: 'BlogCatSchema'
  })
  catgory: Ref<BlogCatSchema>

  @ApiProperty({
    description: '缩略图',
    example: '图片1'
  })
  @prop({
    default: 'https://muddyrain.oss-cn-beijing.aliyuncs.com/images/20200704/15015398.jpg'
  })
  imageUrl: string

  @ApiProperty({
    description: '内容',
    example: '内容',
  })
  @prop({
    default: '这个人很懒，什么都没有留下'
  })
  content: string
}