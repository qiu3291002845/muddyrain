import { UserDto } from './../../interface/user.interface';
import { Controller, Get, Post, Body, UseInterceptors, UploadedFile, Delete, Param, Put, UploadedFiles } from '@nestjs/common';
import { UserService } from './user.service';
import { ApiTags } from '@nestjs/swagger';

@ApiTags('用户管理')
@Controller('/admin/api/user')
export class UserController {
  constructor(private userService: UserService,) { }
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
    // console.log(body);
    const updateBody = {
      username: body.username,
      name: body.name,
      imageUrl: body.imageUrl
    }
    await this.userService.update(id, updateBody)
    return {
      success: '更新成功'
    }
  }
  @Post('create')
  async create(@Body() body) {
    const findU = await this.userService.findUsername(body.username)
    if (findU) {
      return {
        error: '用户名不能重复'
      }
    } else {
      const result = this.userService.create(body)
      return {
        success: '创建成功',
        result
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
  // 更改密码
  @Post('/updatePass')
  async updatePass(@Body() body) {
    // console.log(body);
    await this.userService.updatePass(body.id, body.pass.newPass)
    return {
      success: '修改成功'
    }
  }
}
