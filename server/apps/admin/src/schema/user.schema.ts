import { prop, modelOptions } from '@typegoose/typegoose';
// import * as mongoose from 'mongoose';
import { ApiProperty } from "@nestjs/swagger";
import * as bcrypt from 'bcryptjs'
@modelOptions({
  schemaOptions: {
    // 开始时间检测
    timestamps: true,
  },
})
export class User {
  @ApiProperty({
    description: '用户名',
    example: 'admin'
  })
  @prop({ unique: true })
  username: string
  @ApiProperty({
    description: '密码',
    example: '123456'
  })
  @prop({
    select: true,
    set(val): string {
      return bcrypt.hashSync(val, bcrypt.genSaltSync(10)).toString()
    },
    get: (val: string) => val
  })
  password: string

  @ApiProperty({
    description: '昵称',
    example: '张三'
  })
  @prop()
  name: string

  @ApiProperty({
    description: '上传头像',
    example: 'xxxx.jpg/png/jpeg/gif'
  })
  @prop({
    default: 'http://127.0.0.1:3000/static/logo.png'
  })
  imageUrl: string
}