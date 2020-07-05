import { BlogcatDto } from './../../interface/blogcat.interface';
import { BlogDto } from './../../interface/blog.interface';
import { ApiTags } from '@nestjs/swagger';
import { BlogService } from './blog.service';
import { Controller, Post, Body, Get, Delete, Param, Put, Query } from '@nestjs/common';
@ApiTags('博客管理')
@Controller('/admin/api/blog')
export class BlogController {
  constructor(private blogService: BlogService) {
  }
  @Post('/cat/create')
  async createCat(@Body() body: BlogcatDto) {
    await this.blogService.createCat(body)
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
  @Post('/create')
  async createBlog(@Body() body: BlogDto) {
    await this.blogService.createBlogs(body)
    return { success: '新建博客成功' }
  }
  @Get()
  async findBlog() {
    const res = await this.blogService.findBlog()
    res.forEach(element => {
      if (element.author == null) {
        element.author = {
          imageUrl: 'http://127.0.0.1:3000/static/upload/1593618209232.gif',
          purview: 1,
          _id: '5efcaf2264155e668805631e',
          username: 'muddyrain',
          name: '浊雨不语',
          password: '$2a$10$2XVxqbf1iKfGCJ5igrzEJujK5tMTNDYBELdx.8zF0XLwIg9fPR9n2',
          createdAt: '2020-07-01T15:43:30.377Z',
          updatedAt: '2020-07-05T10:06:15.370Z',
          __v: 0
        }
      }
    });
    return res
  }
  @Get('/:id')
  async findOneBlog(@Param() { id }) {
    const res = await this.blogService.findBlog(id)
    return res
  }
  @Put('/:id')
  async updateBlog(@Param() { id }, @Body() body) {
    let json = {
      title: body.title,
      content: body.content,
      imageUrl: body.imageUrl
    }
    await this.blogService.updateBlog(id, json)
    return {
      success: '更新成功'
    }
  }
  @Delete('/:id')
  async deleteBlog(@Param() { id }) {
    // console.log(id);
    await this.blogService.deleteBlog(id)
    return {
      success: '删除成功'
    }
  }
}
