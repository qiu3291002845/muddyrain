import { User } from '../../schema/user.schema';
import { Module } from '@nestjs/common';
import { UserController } from './user.controller';
import { UserService } from './user.service';
import { TypegooseModule } from 'nestjs-typegoose';
import { OSSModule } from '@nest-public/nest-oss';

@Module({
  imports: [
    TypegooseModule.forFeature([User]),
  ],
  controllers: [
    UserController
  ],
  providers: [
    UserService,
  ]
})
export class UserModule {
}
