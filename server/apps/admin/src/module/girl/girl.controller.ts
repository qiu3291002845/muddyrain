import { GirlColthingDto } from './../../interface/girlColthing.interface';
import { Controller, Post, Body, Get, Query, Param, Put, Delete } from '@nestjs/common';
import { GirlService } from './girl.service';

@Controller('/admin/api/girl')
export class GirlController {
  constructor(private girlService: GirlService) { }
  @Post('/category')
  createCategory(@Body() body): Object {
    this.girlService.createCategory(body);
    return {
      success: '创建成功'
    };
  }
  @Get('/category')
  async findCategory(@Query() { count }) {
    if (count) {
      const res = await this.girlService.findCategory({ count: (count - 1) * 8, pageSize: 8, id: null });
      return res;
    } else {
      const res = await this.girlService.findCategory({ count: null, pageSize: null, id: null });
      return res;
    }
  }
  @Get('/category/:id')
  async findCategoryId(@Param() { id }) {
    const res = await this.girlService.findCategory({ count: null, pageSize: null, id: id });
    return res;
  }
  @Put('/category/:id')
  async editCategory(@Param() { id }, @Body() json) {
    await this.girlService.editCategory(id, json);
    return {
      success: '修改成功'
    };
  }
  @Delete('/category/:id')
  async deleteCategory(@Param() { id }) {
    await this.girlService.deleteCategory(id);
    return {
      success: '删除成功'
    };
  }

  @Post()
  async create(@Body() json: GirlColthingDto) {
    await this.girlService.create(json);
    return {
      success: '创建成功'
    };
  }
  @Get()
  async find() {
    const res =await this.girlService.find();
    return res;
  }
  @Get('/:id')
  async findOne(@Param() { id }) {
    const res =await this.girlService.findOne(id);
    return res;
  }
  @Put('/:id')
  async updateOne(@Param() { id },@Body() json) {
    const res =await this.girlService.updateOne(id,json);
    return {
      success:'修改成功'
    };
  }
  @Delete('/:id')
  async deleteOne(@Param() { id }) {
    await this.girlService.deleteOne(id);
    return {
      success:'修改成功'
    };
  }
}
