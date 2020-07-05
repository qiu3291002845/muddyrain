<template>
  <div>
    <h5 class="mb-2">用户管理</h5>
    <el-button class="mt-2" type="primary" @click="createUser">新建用户</el-button>
    <el-dialog width="60%" :title="editId.length > 0 ? '编辑用户' : '创建用户'" :visible.sync="dialogVisible"
      :before-close="handleClose" :fullscreen="isFullscreen">
      <el-form :model="userForm" ref="userRuleFrom" :rules="userRules" label-width="80px">
        <el-form-item label="用户名" prop="username">
          <div class="d-flex">
            <el-input placeholder="请输入用户名" maxlength="15" show-word-limit v-model="userForm.username" clearable
              :disabled="editId.length > 0"></el-input>
            <el-tooltip content="点击全屏" placement="top" effect="light">
              <!-- content to trigger tooltip here -->
              <el-button type @click="isFullscreen=!isFullscreen" class="ml-2">
                <i class="el-icon-full-screen"></i>
              </el-button>
            </el-tooltip>
          </div>
        </el-form-item>
        <el-form-item label="昵称" prop="name">
          <el-input v-model="userForm.name" placeholder="请输入昵称" clearable></el-input>
        </el-form-item>
        <div v-if="editId.length > 0">
          <el-form-item label="密码">
            <el-popover placement="right" ref="popoverPass" width="400" trigger="click">
              <el-form :model="passFrom" ref="passForm" :rules="passFormRule" label-width="80px">
                <el-form-item label="旧密码" prop="oldPass">
                  <el-input type="password" show-password v-model="passFrom.oldPass" @keyup.enter.native="
                      changePassHanlder(editId, passFrom.oldPass)
                    " placeholder="请输入旧密码"></el-input>
                </el-form-item>
                <el-form-item label="新密码" prop="newPass">
                  <el-input type="password" show-password v-model="passFrom.newPass" placeholder="请输入新密码"
                    @keyup.enter.native="submitPass('passForm')"></el-input>
                </el-form-item>
                <el-form-item>
                  <el-button type="primary" @click="submitPass('passForm')">立即修改</el-button>
                </el-form-item>
              </el-form>
              <el-button type="primary" slot="reference">修改密码</el-button>
            </el-popover>
          </el-form-item>
        </div>
        <div v-else>
          <el-form-item label="密码" prop="password">
            <el-input type="password" show-password placeholder="请输入密码" maxlength="15" show-word-limit
              v-model="userForm.password"></el-input>
          </el-form-item>
        </div>
        <el-form-item label="授权">
          <el-radio-group v-model="userForm.purview">
            <el-radio-button label="0" value="0">普通用户</el-radio-button>
            <el-radio-button label="1" value="1">系统管理员</el-radio-button>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="头像上传" prop="upload">
          <el-upload class="avatar-uploader" name="imageUrl" :action="$http.defaults.baseURL + '/uploadOSS'"
            :show-file-list="false" :on-success="AvatarSuccess">
            <img v-if="userForm.imageUrl" :src="userForm.imageUrl" class="avatar" />
            <i v-else class="el-icon-plus avatar-uploader-icon"></i>
          </el-upload>
        </el-form-item>
      </el-form>
      <span slot="footer">
        <el-button @click="cancel">取 消</el-button>
        <el-button class="mr-2" type="primary" @click="submitUser('userRuleFrom')">确 定</el-button>
      </span>
    </el-dialog>

    <!-- 用户列表 -->
    <el-table :data="tableData" style="width: 100%" stripe :row-key="tableData._id" v-loading="loading">
      <el-table-column label="注册日期" width="180" sortable prop="date">
        <template slot-scope="scope">
          <i class="el-icon-time"></i>
          <span style="margin-left: 10px">{{ scope.row.createdAt | format }}</span>
        </template>
      </el-table-column>
      <el-table-column label="头像" width="180" sortable prop="avatar">
        <template slot-scope="scope">
          <el-avatar :src="scope.row.imageUrl" shape="square" class="bg-white" fill="scale-down"></el-avatar>
        </template>
      </el-table-column>

      <el-table-column label="姓名" width="180" sortable>
        <template slot-scope="scope">
          <el-popover trigger="hover" placement="top">
            <p>姓名: {{ scope.row.name }}</p>
            <p>用户名: {{ scope.row.username }}</p>
            <div slot="reference" class="name-wrapper">
              <el-tag size="medium">{{ scope.row.name }}</el-tag>
            </div>
          </el-popover>
        </template>
      </el-table-column>
      <el-table-column label="身份" width="140">
        <template slot-scope="scope">{{scope.row.purview | purview }}</template>
      </el-table-column>
      <el-table-column label="操作">
        <template slot-scope="scope">
          <el-button size="mini" @click="editUser(scope.row._id)">编辑</el-button>
          <el-button size="mini" type="danger" @click="UserRemove(scope)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
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
    components: {},
    filters: {
      format: (value: string) => value.slice(0, 10),
      purview: (value: number) => {
        if (value == 0) {
          return "普通用户";
        } else {
          return "系统管理员";
        }
      }
    }
  })
  export default class AdminCrudList extends Vue {
    private dialogVisible: boolean = false;
    private isFullscreen: boolean = false;
    private changePassword: boolean = false;
    private editId: string = "";
    private purview: number = 0
    private tableData = [{
      createdAt: "2016-05-02",
      name: "王小虎",
      username: "admin"
    }];
    private passFrom = {};
    // 获取数据
    async UserFetch() {
      const data = await this["$http"].get("user");
      this.tableData = data.data;
      this.loading = false;
    }
    async createUser() {
      if (this.purview == 0) {
        this.$message.info('您不是管理员请勿乱动')
      } else {
        this.dialogVisible = true;
      }
    }
    created() {
      this.purview = this.$store.state.userFrom.purview
      this.UserFetch();
      this.$notify({
        title: "欢迎来到浊雨不语后台管理界面",
        message: "浊雨不知心中事,纷纷落语眼前花。",
        duration: 1000,
        type: "success"
      });
    }
    async UserRemove(scope: any) {
      if (this.purview == 0) {
        this.$message.info('您不是管理员请勿乱动')
      } else {
        this.$confirm("是否要删除——" + scope.row.name)
          .then(async () => {
            await this["$http"].delete(`user/${scope.row._id}`);
            this.$message({
              type: "success",
              message: "删除成功"
            });
            // 删除成功后获取数据
            this.UserFetch();
          })
          .catch(() => {
            this.$message.warning("取消删除");
          });
      }
    }
    private loading: boolean = true;
    async editFetch(id: string) {
      const data = await this["$http"].get(`user/${id}`);
      this.userForm = data.data;
    }
    editUser(id: string) {
      this.editId = id;
      this.editFetch(id);
      if (this.purview == 0) {
        this.$message.info('您不是管理员请勿乱动')
      } else {
        this.dialogVisible = true;
      }
    }
    // 表单取消
    cancel() {
      this.$confirm("确认关闭？")
        .then(_ => {
          this.editId = "";
          this.userForm = {};
          this.passFrom = {};
          this.dialogVisible = false;
          this.isFullscreen = false;
          // location.reload();
          (this.$refs["userRuleFrom"] as Form).resetFields();
        })
        .catch(_ => {});
    }
    private userForm = {};
    private userRules = {
      username: [{
          required: true,
          message: "请输入用户名",
          trigger: "blur"
        },
        {
          min: 4,
          max: 20,
          message: "长度在 4 到 20 个字符",
          trigger: "blur"
        },
        {
          pattern: /^[a-zA-Z]\w{3,19}$/,
          message: "以字母开头，长度在4-20之间,只能包含字符、数字和下划线",
          trigger: "blur"
        }
      ],
      name: [{
          required: true,
          message: "请输入昵称",
          trigger: "blur"
        },
        {
          min: 2,
          max: 7,
          message: "长度在 2 到 7 个字符",
          trigger: "blur"
        }
      ],
      password: [{
          required: true,
          message: "请输入密码",
          trigger: "blur"
        },
        {
          min: 6,
          max: 24,
          message: "长度在 6 到 24 个字符",
          trigger: "blur"
        }
      ]
    };
    submitUser(formName: any) {
      (this.$refs[formName] as Form).validate(async valid => {
        if (valid) {
          if (this.editId) {
            await this["$http"].put(
              `/user/${this.editId}`,
              this.userForm
            );
            this.$store.state.userFrom = this.userForm;
            this.$message.success("更新成功");
          } else {
            const res = await this["$http"].post(
              "/user/create",
              this.userForm
            );
            if (res.data.error) {
              this.$message.error(res.data.error);
              this.userForm = {};
              return;
            }
            this.$message.success("创建成功");
          }
          (this.$refs[formName] as Form).resetFields();
          this.dialogVisible = false;
          this.editId = "";
          this.userForm = {};
          this.passFrom = {};
          this.UserFetch();
        } else {
          return false;
        }
      });
    }
    AvatarSuccess(res: any) {
      if (res[0].uploaded == true) {
        this.$set(
          this.userForm,
          "imageUrl",
          "https://muddyrain.oss-cn-beijing.aliyuncs.com/" + res[0].path
        );
        this.$message.success(res[0].message);
      }
    }
    handleClose(done: any) {
      this.$confirm("确认关闭？")
        .then(_ => {
          this.editId = "";
          this.userForm = {};
          this.passFrom = {};
          this.dialogVisible = false;
          this.isFullscreen = false;
          // location.reload();
          (this.$refs["userRuleFrom"] as Form).resetFields();
          done();
        })
        .catch(_ => {});
    }
    private validatePassRule: any;
    async changePassHanlder(editId: string, oldPass: string) {
      const res = await this.$http.post("login/volidateOldPass", {
        editId,
        oldPass
      });
      this.validatePassRule = res.data;
    }
    validateUsername(rule: any, value: string, callback: any) {
      let Reg = /^[a-zA-Z][-_a-zA-Z0-9]{1,5}/;
      let reg = /^(\w[A-Z]{1}\w*\s?)*$/g;
      if (reg.test(value)) {
        console.log("验证成功");
      }
    }
    async validateOldPass(rule: any, value: any, callback: any) {
      if (!value) {
        return callback(new Error("请输入旧密码"));
      } else {
        await this.changePassHanlder(this.editId, value);
        if (this.validatePassRule.error) {
          return callback(new Error(this.validatePassRule.error));
        } else {
          return callback();
        }
      }
    }
    passFormRule = {
      oldPass: [{
        required: true,
        validator: this.validateOldPass,
        trigger: "blur"
      }],
      newPass: [{
          required: true,
          message: "请输入新密码",
          trigger: "blur"
        },
        {
          min: 6,
          max: 24,
          message: "长度在 6 到 24 个字符",
          trigger: "blur"
        }
      ]
    };
    submitPass(formName: any) {
      (this.$refs[formName] as Form).validate(async valid => {
        if (valid) {
          // this.$message.success(this.validatePassRule.success);
          const res = await this.$http.post("user/updatePass", {
            pass: this.passFrom,
            id: this.editId
          });
          this.$message.success(res.data.success);
          localStorage.clear();
          location.reload();
        } else {
          console.log("error submit!!");
          return false;
        }
      });
    }
  }
</script>

<style lang="scss">
  .avatar-uploader .el-upload {
    border: 1px dashed #d9d9d9;
    border-radius: 6px;
    cursor: pointer;
    position: relative;
    overflow: hidden;
  }

  .avatar-uploader .el-upload:hover {
    border-color: #409eff;
  }

  .avatar-uploader-icon {
    font-size: 28px;
    color: #8c939d;
    width: 178px;
    height: 178px;
    line-height: 178px;
    text-align: center;
  }

  .avatar {
    width: 178px;
    height: 178px;
    display: block;
  }
</style>