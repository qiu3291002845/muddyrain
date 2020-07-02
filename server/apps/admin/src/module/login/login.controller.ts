import { Controller, Get, Request, Response, Post, Req, Body } from '@nestjs/common';
import { LoginService } from './login.service';
import * as bcrypt from 'bcryptjs'
import * as jwt from 'jsonwebtoken'
@Controller('/admin/api/login')
export class LoginController {
  constructor(private loginService: LoginService) { }
  @Get('code')
  async code(@Request() req, @Response() res) {
    let code = await this.loginService.captcha();
    // 设置 session 保存 验证嘛
    // req.session.code = code.text;
    res.type('image/svg+xml');
    let codeData = {
      img: code.data,
      text: code.text
    }
    res.send(codeData)
  }
  @Post('doLogin')
  async doLogin(@Request() req: any, @Body() body: any) {
    let password: any = body.password;
    const username: string = body.username;
    let user = await this.loginService.find({ "username": username });
    if (!user) {
      return {
        error: '用户名或者密码不正确'
      }
    } else {
      password = bcrypt.compareSync(password, user.password)
      // 如果 查询的结果大于 0 就证明有这个用户
      // console.log(userResult);
      if (password) {
        const token = jwt.sign(
          {
            id: user._id,
          },
          "dajdoadliajdsa"
        );
        return {
          success: '登陆成功',
          token
        }
      } else {
        return {
          error: '用户名或者密码不正确'
        }
      }
    }
  }
}
