import { User } from '../../schema/user.schema';
import { TypegooseModule } from 'nestjs-typegoose';
import { Module } from '@nestjs/common';
import { LoginController } from './login.controller';
import { LoginService } from './login.service';

@Module({
  imports: [TypegooseModule.forFeature([User])],
  controllers: [LoginController],
  providers: [LoginService]
})
export class LoginModule { }
