import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
// 配置数据库连接
import { UserModule } from './module/user/user.module';
import { TypegooseModule } from 'nestjs-typegoose';
import { LoginModule } from './module/login/login.module';
import { BlogModule } from './module/blog/blog.module';
import { OSSModule } from '@nest-public/nest-oss';
import { config } from './config/config.js';
import { NotebookModule } from './module/notebook/notebook.module';
import { ComputercpuModule } from './module/computercpu/computercpu.module';
import { ToolService } from './service/tool/tool.service';
import { DisplaycardModule } from './module/displaycard/displaycard.module';
@Module({
  imports: [TypegooseModule.forRoot('mongodb://127.0.0.1:27017/muddyrain', {
    useNewUrlParser: true,
    useUnifiedTopology: true,
    useCreateIndex: true,
  }), UserModule, LoginModule, BlogModule, OSSModule.forRoot(config), NotebookModule, ComputercpuModule, DisplaycardModule],
  controllers: [AppController],
  providers: [AppService, ToolService],
})

export class AppModule {
}
