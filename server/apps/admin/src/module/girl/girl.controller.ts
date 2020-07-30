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
  @Post('/first')
  createFirst(@Body() body): Object {
    this.girlService.createFirst(body);
    return {
      success: '创建成功'
    };
  }
  @Post('/second')
  createSecond(@Body() body): Object {
    this.girlService.createSecond(body);
    return {
      success: '创建成功'
    };
  }
  @Get('/category')
  async findCategory(@Query() { count }) {
    if (count) {
      const res = await this.girlService.findCategory({ count: (count - 1) * 8, pageSize: 8, id: null });
      return {
        data: res,
      }
    } else {
      const res = await this.girlService.findCategory({ count: null, pageSize: null, id: null });
      return {
        data: res,
      }
    }
  }
  @Get('/first')
  async findFirst(@Query() { count }) {
    if (count) {
      const res = await this.girlService.findFirst({ count: (count - 1) * 8, pageSize: 8, id: null });
      return {
        data: res,
      }
    } else {
      const res = await this.girlService.findFirst({ count: null, pageSize: null, id: null });
      return {
        data: res,
      }
    }
  }
  @Get('/second')
  async findSecond(@Query() { count }) {
    if (count) {
      const res = await this.girlService.findSecond({ count: (count - 1) * 8, pageSize: 8, id: null });
      return {
        data: res,
      }
    } else {
      const res = await this.girlService.findSecond({ count: null, pageSize: null, id: null });
      return {
        data: res,
      }
    }
  }
  @Get('/category/:id')
  async findCategoryId(@Param() { id }) {
    const res = await this.girlService.findCategory({ count: null, pageSize: null, id: id });
    return res;
  }
  @Get('/first/:id')
  async findFirstId(@Param() { id }) {
    const res = await this.girlService.findFirst({ count: null, pageSize: null, id: id });
    return res;
  }
  @Get('/second/:id')
  async findSecondId(@Param() { id }) {
    const res = await this.girlService.findSecond({ count: null, pageSize: null, id: id });
    return res;
  }
  @Put('/category/:id')
  async editCategory(@Param() { id }, @Body() json) {
    await this.girlService.editCategory(id, json);
    return {
      success: '修改成功'
    };
  }
  @Put('/first/:id')
  async editFirst(@Param() { id }, @Body() json) {
    await this.girlService.editFirst(id, json);
    return {
      success: '修改成功'
    };
  }
  @Put('/second/:id')
  async editSecond(@Param() { id }, @Body() json) {
    await this.girlService.editSecond(id, json);
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
  @Delete('/first/:id')
  async deleteFirst(@Param() { id }) {
    await this.girlService.deleteSecond(id);
    return {
      success: '删除成功'
    };
  }
  @Delete('/second/:id')
  async deleteSecond(@Param() { id }) {
    await this.girlService.deleteSecond(id);
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
  async find(@Query() { count, sort }) {
    if (count && sort) {
      const res = await this.girlService.find({ count: (count - 1) * 6, pagesize: 6, sort: sort as boolean });
      return {
        data: res,
        total: res.length
      }
    } else {
      const res = await this.girlService.find({});
      return {
        data: res,
        total: res.length
      }
    }
  }
  @Get('findFirst')
  async findGirlFirst(@Query() { id, count }) {
    const res = await this.girlService.findGirlCategory({ count: (count - 1) * 6, pagesize: 6, id: id });
    return {
      data: res,
      total: res.length
    }
  }
  @Get('findSecond')
  async findGirlSecond(@Query() { id, count }) {
    const res = await this.girlService.findGirlCategory2({ count: (count - 1) * 6, pagesize: 6, id: id });
    return {
      data: res,
      total: res.length
    }
  }
  @Get('/search')
  async findLike(@Query() { count, pagesize, keyword }) {
    let c = (count - 1) * pagesize
    if (count) {
      const res = await this.girlService.findLike(c * 1, pagesize, keyword);
      return {
        data: res,
        total: res.length
      }
    } else if (!count) {
      const res = await this.girlService.findLike(null, null, keyword);
      return {
        data: res,
        total: res.length
      }
    }
  }
  @Get('/:id')
  async findOne(@Param() { id }) {
    const res = await this.girlService.findOne(id);
    return res;
  }
  @Put('/:id')
  async updateOne(@Param() { id }, @Body() json) {
    const res = await this.girlService.updateOne(id, json);
    return {
      success: '修改成功'
    };
  }
  @Delete('/:id')
  async deleteOne(@Param() { id }) {
    await this.girlService.deleteOne(id);
    return {
      success: '删除成功'
    };
  }
}
