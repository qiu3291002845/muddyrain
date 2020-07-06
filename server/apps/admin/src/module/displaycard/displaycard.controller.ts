import { HandWareDto } from '../../interface/hardware.interface';
import { Controller, Post, Get, Delete, Put, Param, Body, Query } from '@nestjs/common';
import { DisplaycardService } from './displaycard.service';

@Controller('/admin/api/displaycard')
export class DisplaycardController {
  constructor(private computercpuService: DisplaycardService) { }
  @Post('/create')
  async createCpu(@Body() body: HandWareDto) {
    await this.computercpuService.create(body)
    return {
      success: '创建成功'
    }
  }
  @Get('/')
  async findCpu(@Query() { count, keyword }) {
    if (count) {
      const res = await this.computercpuService.find(null, 10, (count - 1) * 10)
      return res
    } else if (keyword) {
      const res = await this.computercpuService.findLike(keyword);
      return res
    } else {
      const res = await this.computercpuService.find()
      return res
    }
  }
  @Get('/:id')
  async findCpuOne(@Param() { id }) {
    const res = await this.computercpuService.find(id)
    return res
  }
  @Delete('/:id')
  async removeCpu(@Param() { id }) {
    await this.computercpuService.delete(id)
    return {
      success: '删除成功'
    }
  }
  @Put('/:id')
  async updateCpu(@Param() { id }, @Body() body) {
    await this.computercpuService.update(id, body)
    return {
      success: '更新成功'
    }
  }
}
