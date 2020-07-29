import { SlideService } from './slide.service';
import { Controller, Post, Body, Get, Put, Param, Delete } from '@nestjs/common';

@Controller('/admin/api/slide')
export class SlideController {
  constructor(private slideService:SlideService) { }
  @Post()
  async create(@Body() {imgUrl}) {
    await this.slideService.create(imgUrl)
    return {
      success:'上传成功'
    }
  }
  @Get()
  async fetch() {
    const res = await this.slideService.find()
    return res;
  }
  @Get('/:id')
  async fetchOne(@Param() {id}) {
    const res = await this.slideService.find(id)
    return res;
  }
  @Put('/:id')
  async update(@Param() {id} ,@Body() body) {
     await this.slideService.update(id,body)
    return {
      success:'更新成功'
    };
  }
  @Delete('/:id')
  async delete(@Param() { id }) {
    await this.slideService.delete(id)
    return {
      success:'删除成功'
    };
  }
}
