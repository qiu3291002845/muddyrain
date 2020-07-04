import { ApiTags } from '@nestjs/swagger';
import { Controller, Get, Request, Response, Post, Req, Body, Param } from '@nestjs/common';
import { LoginService } from './login.service';
import * as bcrypt from 'bcryptjs'
import * as jwt from 'jsonwebtoken'
@ApiTags('登录接口')
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
          token,
          user
        }
      } else {
        return {
          error: '用户名或者密码不正确'
        }
      }
    }
  }
  // 校验旧密码
  @Post('volidateOldPass')
  async volidateOldPass(@Body() body: any) {
    let oldPass: any = body.oldPass;
    const user = await this.loginService.findId(body.editId);
    // 解密 验证
    let valid = bcrypt.compareSync(oldPass, user.password)
    if (valid) {
      return {
        success: '与旧密码完全符合'
      }
    } else {
      return {
        error: '与旧密码不匹配'
      }
    }
  }
  @Post('volidatePass/:id')
  async volidatePass(@Param() { id }, @Body() body) {
    let pass: any = body.password;
    const user = await this.loginService.findId(id);
    // 解密 验证
    let valid = bcrypt.compareSync(pass, user.password)
    if (valid) {
      return {
        success: '密码匹配成功'
      }
    } else {
      return {
        error: '密码不正确'
      }
    }
  }
}
