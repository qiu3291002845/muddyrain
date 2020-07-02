import { UserDto } from './../../interface/user.interface';
import { join, extname } from 'path';
import { Controller, Get, Post, Body, UseInterceptors, UploadedFile, Delete, Param, Put } from '@nestjs/common';
import { UserService } from './user.service';
import { FileInterceptor } from '@nestjs/platform-express';
import { createWriteStream } from 'fs';
@Controller('/admin/api/user')
export class UserController {
  constructor(private userService: UserService) { }
  @Get('')
  find() {
    const result = this.userService.find()
    return result
  }
  @Get(':id')
  async findOne(@Param('id') id: string) {
    const result = await this.userService.findOne(id)
    return result
  }
  @Put(':id')
  async update(@Param('id') id: string, @Body() body: UserDto) {
    await this.userService.update(id, body)
    return {
      success: '更新成功'
    }
  }
  @Post('create')
  create(@Body() body) {
    const result = this.userService.create(body)
    return {
      success: '创建成功',
      result
    }
  }
  // 图片上传
  @Post('upload')
  @UseInterceptors(FileInterceptor('imageUrl'))
  async upload(@UploadedFile() imageUrl) {
    // console.log(imageUrl);
    let d = Date.now()
    let ext = extname(imageUrl.originalname).toString()
    if (ext == ".jpg" || ext == ".png" || ext == ".gif" || ext == ".jpeg") {
      let writeStream = createWriteStream(join(__dirname, '../../../apps/admin/src/public/upload', `${d}${extname(imageUrl.originalname)}`))
      writeStream.write(imageUrl.buffer);
      return {
        message: '头像上传成功',
        url: `static/upload/${d}${extname(imageUrl.originalname)}`
      }
    } else {
      return {
        message: '请上传正确的图片格式(.jpg/.png/.jpeg/.gif)',
        code: 400
      }
    }
  }
  // 删除用户
  @Delete('/:id')
  async remove(@Param('id') id: string) {
    this.userService.remove(id);
    return {
      success: '删除成功'
    }
  }
}
