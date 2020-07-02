import { User } from '../../schema/user.schema';
import { Injectable } from '@nestjs/common';
import { InjectModel } from 'nestjs-typegoose';
import * as svgCaptcha from 'svg-captcha'

@Injectable()
export class LoginService {
  constructor(@InjectModel(User) private readonly userModel) { }
  rgb() {
    let r = Math.floor(Math.random() * 255);
    let g = Math.floor(Math.random() * 255);
    let b = Math.floor(Math.random() * 255);
    return `rgb(${r},${g},${b})`
  }
  // 生成验证码
  async captcha() {
    var captcha = svgCaptcha.create({
      size: 4,
      fontSize: 50,
      width: 100,
      height: 36,
      background: '#666'
    });
    return captcha;
  }
  // 查询用户
  async find(json) {
    return await this.userModel.findOne(json)
  }
}
