import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
// 配置数据库连接
import { UserModule } from './module/user/user.module';
import { TypegooseModule } from 'nestjs-typegoose';
import { LoginModule } from './module/login/login.module';

@Module({
  imports: [TypegooseModule.forRoot('mongodb://127.0.0.1:27017/muddyrain', {
    useNewUrlParser: true,
    useUnifiedTopology: true
  }), UserModule, LoginModule,],
  controllers: [AppController],
  providers: [AppService],
})

export class AppModule {
}
