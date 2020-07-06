import { ApiTags } from '@nestjs/swagger';
import { join, extname } from 'path';
import { Controller, Get, Post, UseInterceptors, UploadedFile, Put, UploadedFiles, Req, Param, Query, Body } from '@nestjs/common';
import { AppService } from './app.service';
import { FileInterceptor } from '@nestjs/platform-express';
import { createWriteStream } from 'fs';
import { OSSService } from '@nest-public/nest-oss';
import { FilesInterceptor } from '@nestjs/platform-express';

@ApiTags('公共接口')
@Controller()
export class AppController {
  constructor(private readonly appService: AppService, private readonly OSSService: OSSService) { }
  @Get()
  getHello(): string {
    return this.appService.getHello();
  }
  // 图片上传
  @Post('/admin/api/upload')
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
  @Post('/admin/api/uploadManyOSS')
  @UseInterceptors(FilesInterceptor('imageUrl'))
  public async uploadManyOSS(@UploadedFiles() imageUrl) {
    const result = await this.OSSService.upload(imageUrl);
    return result;
  }
  @Post('/admin/api/uploadOSS')
  @UseInterceptors(FilesInterceptor('imageUrl'))
  public async uploadOSS(@UploadedFiles() imageUrl) {
    const result = await this.OSSService.upload(imageUrl);
    return result;
    // result [
    // 	{
    // 		uploaded: true,
    // 		path: 'images/20191115/16420962.png',
    // 		src: 'http://xxxx.oss-cn-shenzhen.aliyuncs.com/images/20191115/16420962.png',
    // 		srcSign: 'https://xxx.oss-cn-shenzhen.aliyuncs.com/images/20191115/16420962.png?OSSAccessKeyId=LTAI6lgwcBcCbiKX&Expires=1573814530&Signature=brYN7qbDdyxGARc%2BdoRsnblJx2w%3D',
    // 		message: '上传成功'
    // 	}
    // ]
  }
  @Post('/admin/api/uploadBlog')
  @UseInterceptors(FilesInterceptor('file'))
  public async uploadBlog(@UploadedFiles() file) {
    const result = await this.OSSService.upload(file);
    return {
      "location": result[0].src
    };
    // result [
    // 	{
    // 		uploaded: true,
    // 		path: 'images/20191115/16420962.png',
    // 		src: 'http://xxxx.oss-cn-shenzhen.aliyuncs.com/images/20191115/16420962.png',
    // 		srcSign: 'https://xxx.oss-cn-shenzhen.aliyuncs.com/images/20191115/16420962.png?OSSAccessKeyId=LTAI6lgwcBcCbiKX&Expires=1573814530&Signature=brYN7qbDdyxGARc%2BdoRsnblJx2w%3D',
    // 		message: '上传成功'
    // 	}
    // ]
  }
  // 删除
  @Post('/admin/api/deleteOSS')
  public async deleteOSS(@Req() req, @Body() { img }) {
    // const uploadUrl = ['images/20191115/16420962.png'];
    const result = await this.OSSService.deleteMulti([img]);
    return result;
    // return '删除成功'
    // result {
    // 	res: {
    // 		status: 200,
    // 		statusCode: 200,
    // 		statusMessage: 'OK',
    // 		// ....
    // 	},
    //  deleted: [ 'images/20191115/16420962.png' ]
    // }
  }
}
