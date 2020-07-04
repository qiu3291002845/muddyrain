<template>
  <div style="height:100vh" class="bg">
    <transition name="el-zoom-in-center">
      <div v-if="show" class="box d-flex shadow-lg">
        <div class="left flex-fill text-center w-50 bd-highlight">
          <div class="mt-4">
            <h3 class="text-white"></h3>
          </div>
          <div class="d-flex justify-content-center">
            <img src="../../assets/img/logo-w.png" class="mt-5 pt-5" width="40%" height="40%" alt />
          </div>
        </div>
        <div class="right flex-fill w-50 bd-highlight">
          <div class="mt-5 pt-3 mb-5 w-100 text-center">
            <h3>登录 - MuddyRain</h3>
          </div>
          <el-form :model="userForm" ref="userRuleFrom" :rules="userRules" label-width="100px">
            <el-form-item label="用户名" prop="username">
              <el-input placeholder="请输入用户" maxlength="15" show-word-limit v-model="userForm.username" clearable
                style="width:85%" @keyup.enter.native="submitUser('userRuleFrom')"></el-input>
            </el-form-item>
            <el-form-item label="密码" prop="password">
              <el-input type="password" placeholder="请输入密码" maxlength="15" show-password show-word-limit
                v-model="userForm.password" style="width:85%" @keyup.enter.native="submitUser('userRuleFrom')">
              </el-input>
            </el-form-item>
            <el-form-item label="验证码" prop="code">
              <el-input style="width:42%;" placeholder="请输入验证码" maxlength="6" v-model="userForm.code"
                @keyup.enter.native="submitUser('userRuleFrom')"></el-input>
              <el-tooltip class="item" effect="dark" content="看不清-换一张" placement="top-start">
                <el-button class="ml-2" style="padding:0.2rem" v-html="imgSvg" @click="changePic"></el-button>
              </el-tooltip>
            </el-form-item>
            <el-form-item>
              <el-button type="primary" @click="submitUser('userRuleFrom')" class="d-block">登录</el-button>
            </el-form-item>
          </el-form>
        </div>
      </div>
    </transition>
  </div>
</template>

<script lang="ts">
  import {
    Vue,
    Component
  } from "vue-property-decorator";
  import {
    Form
  } from "element-ui";
  @Component({
    components: {}
  })
  export default class Login extends Vue {
    userForm = {};
    // 验证码
    verify = this.$http.defaults.baseURL + "/login/code";
    imgSvg = "";
    sessionText: string = "";
    userRules = {
      username: [{
        required: true,
        message: "请输入用户名",
        trigger: "blur"
      }],
      password: [{
        required: true,
        message: "请输入密码",
        trigger: "blur"
      }],
      code: [{
        validator: this.validateCode,
        trigger: "blur"
      }]
    };
    // 检验验证码
    async validateCode(rule: any, value: any, callback: any) {
      if (!value) {
        return callback(new Error("验证码不能为空"));
      } else {
        let sessioncode: any = sessionStorage.getItem("code");
        if (value.toLowerCase() != sessioncode.toLowerCase()) {
          return callback(new Error("验证码不正确"));
        } else {
          return callback();
        }
      }
    }
    // 请求验证码
    async requestCode() {
      const res = await this.$http.get("login/code");
      this.imgSvg = res.data.img;
      this.sessionText = res.data.text;
      sessionStorage.setItem("code", this.sessionText);
    }
    // 换张验证码图片
    changePic() {
      this.requestCode();
    }
    created() {
      this.requestCode();
    }
    submitUser(formName: any) {
      (this.$refs[formName] as Form).validate(async valid => {
        if (valid) {
          const res = await this.$http.post(
            "/login/doLogin",
            this.userForm
          );
          if (res.data.success) {
            this.$message.success(res.data.success);
            localStorage.setItem("token", res.data.token);
            this.$store.state.userFrom = res.data.user;
            this.$router.push("/");
          } else {
            this.$message.error(res.data.error);
          }
        } else {
          return false;
        }
      });
    }
    show: boolean = false;
    mounted() {
      this.show = true;
    }
  }
</script>

<style scoped lang="scss">
  .bg {
    background: url("../../assets/img/bg.jpg") no-repeat;
    background-size: 100% 100%;
    position: relative;

    .box {
      width: 55%;
      height: 55vh;
      border-radius: 10px;
      overflow: hidden;
      margin: auto;
      position: absolute;
      top: 0;
      bottom: 0;
      left: 0;
      right: 0;

      .left {
        background: rgb(64, 158, 255);
        vertical-align: middle;
      }

      .right {
        background: white;
      }
    }
  }
</style>