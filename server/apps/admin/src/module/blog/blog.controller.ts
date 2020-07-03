import { ApiTags } from '@nestjs/swagger';
import { BlogService } from './blog.service';
import { Controller, Post, Body, Get, Delete, Param, Put, Query } from '@nestjs/common';
@ApiTags('博客管理')
@Controller('/admin/api/blog')
export class BlogController {
  constructor(private blogService: BlogService) {
  }
  @Post('/cat/create')
  async createCat(@Body() body) {
    const res = await this.blogService.createCat(body)
    return {
      success: '创建成功'
    }
  }
  @Get('/cat')
  async findCat() {
    const res = await this.blogService.findCat()
    return res
  }
  @Get('/cat/:id')
  async findCatOne(@Param() { id }) {
    const res = await this.blogService.findCat(id)
    return res
  }
  @Delete('/cat/:id')
  async removeCat(@Param() { id }) {
    await this.blogService.deleteCat(id)
    return {
      success: '删除成功'
    }
  }
  @Put('/cat/:id')
  async updateCat(@Param() { id }, @Body() body) {
    await this.blogService.updateCat(id, body)
    return {
      success: '更新成功'
    }
  }
}
