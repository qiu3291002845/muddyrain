import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { NestExpressApplication } from '@nestjs/platform-express';
import { join } from 'path';
const jwt = require('jsonwebtoken');
async function bootstrap() {
  // 在 app创建服务器时定义 express平台
  const app = await NestFactory.create<NestExpressApplication>(AppModule);
  // 允许跨域
  app.enableCors()
  // 配置静态资源目录
  app.useStaticAssets(join(__dirname, '../../../apps/admin/src/', 'public'), {
    prefix: '/static/'
  })
  // 配置接口文档
  const options = new DocumentBuilder()
    .setTitle('浊雨不语商城项目后台管理接口文档')
    .setDescription('浊雨不知心中事,纷纷落语眼前花。')
    .setVersion('1.0')
    .build();
  const document = SwaggerModule.createDocument(app, options);
  SwaggerModule.setup('api-docs', app, document);
  //配置 session 的中间件 

  console.log('已连接数据库');
  await app.listen(3000);
}
bootstrap();
