import { NotebookbrandDto } from './../../interface/notebookbrand.interface';
import { NotebookService } from './notebook.service';
import { Controller, Post, Get, Delete, Put, Param, Body, Query } from '@nestjs/common';

@Controller('admin/api/notebook')
export class NotebookController {
  constructor(private notebookService: NotebookService) { }
  @Post('/brand/create')
  async createbrand(@Body() body: NotebookbrandDto) {
    await this.notebookService.createBrand(body)
    return {
      success: '创建成功'
    }
  }
  @Get('/brand')
  async findbrand(@Query() { count }) {
    if (count) {
      const res = await this.notebookService.findBrand(null, 10, (count - 1) * 10)
      return res
    } else {
      const res = await this.notebookService.findBrand()
      return res
    }
  }
  @Get('/brand/:id')
  async findbrandOne(@Param() { id }) {
    const res = await this.notebookService.findBrand(id)
    return res
  }
  @Delete('/brand/:id')
  async removebrand(@Param() { id }) {
    await this.notebookService.deleteBrand(id)
    return {
      success: '删除成功'
    }
  }
  @Put('/brand/:id')
  async updatebrand(@Param() { id }, @Body() body) {
    await this.notebookService.updateBrand(id, body)
    return {
      success: '更新成功'
    }
  }
}
