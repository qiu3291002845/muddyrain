<template>
  <div>
    <el-button type="primary" @click="dialogVisible = true">新建用户</el-button>
    <el-dialog width="60%" :title="editId.length > 0 ? '编辑用户' : '创建用户'" :visible.sync="dialogVisible"
      :before-close="handleClose">
      <el-form :model="userForm" ref="userRuleFrom" :rules="userRules" label-width="80px">
        <el-form-item label="用户名" prop="username">
          <el-input placeholder="请输入用户名" maxlength="15" show-word-limit v-model="userForm.username" clearable>
          </el-input>
        </el-form-item>
        <el-form-item label="昵称" prop="name">
          <el-input v-model="userForm.name" placeholder="请输入昵称" clearable>
          </el-input>
        </el-form-item>
        <el-form-item label="密码" prop="password">
          <el-input type="password" placeholder="请输入密码" maxlength="15" show-password show-word-limit
            v-model="userForm.password">
          </el-input>
        </el-form-item>
        <el-form-item label="头像上传" prop="upload">
          <el-upload class="avatar-uploader" name="imageUrl" :action="$http.defaults.baseURL + '/user/upload'"
            :show-file-list="false" :on-success="AvatarSuccess">
            <img v-if="userForm.imageUrl" :src="userForm.imageUrl" class="avatar" />
            <i v-else class="el-icon-plus avatar-uploader-icon"></i>
          </el-upload>
        </el-form-item>
      </el-form>
      <span slot="footer">
        <el-button @click="dialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="submitUser('userRuleFrom')">确 定</el-button>
      </span>
    </el-dialog>

    <!-- 用户列表 -->
    <el-table :data="tableData" style="width: 100%" stripe :row-key="tableData._id" v-loading="loading">
      <el-table-column label="注册日期" width="180" sortable prop="date">
        <template slot-scope="scope">
          <i class="el-icon-time"></i>
          <span style="margin-left: 10px">{{
            scope.row.createdAt | format
          }}</span>
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
    },
  })
  export default class AdminCrudList extends Vue {
    dialogVisible: boolean = false;
    editId: string = "";
    tableData = [{
      createdAt: "2016-05-02",
      name: "王小虎",
      username: "admin",
    }, ];
    // 获取数据
    async UserFetch() {
      const data = await this["$http"].get("user");
      this.tableData = data.data;
      this.loading = false;
    }
    created() {
      this.UserFetch();
      this.$notify({
        title: "欢迎来到浊雨不语后台管理界面",
        message: "浊雨不知心中事,纷纷落语眼前花。",
        duration: 1000,
        type: "success",
      });
    }
    async UserRemove(scope: any) {
      this.$confirm("是否要删除——" + scope.row.name)
        .then(async () => {
          await this["$http"].delete(`user/${scope.row._id}`);
          this.$message({
            type: "success",
            message: "删除成功",
          });
          // 删除成功后获取数据
          this.UserFetch();
        })
        .catch(() => {
          this.$message.error("删除失败");
        });
    }
    loading: boolean = true;
    async editFetch(id: string) {
      const data = await this["$http"].get(`user/${id}`);
      this.userForm = data.data;
    }
    editUser(id: string) {
      this.editId = id;
      this.dialogVisible = true;
      this.editFetch(id);
    }
    userForm = {};
    userRules = {
      username: [{
          required: true,
          message: "请输入用户名",
          trigger: "blur",
        },
        {
          min: 2,
          max: 15,
          message: "长度在 2 到 15 个字符",
          trigger: "blur",
        },
      ],
      name: [{
          required: true,
          message: "请输入昵称",
          trigger: "blur",
        },
        {
          min: 2,
          max: 7,
          message: "长度在 2 到 7 个字符",
          trigger: "blur",
        },
      ],
      password: [{
          required: true,
          message: "请输入密码",
          trigger: "blur",
        },
        {
          min: 6,
          max: 24,
          message: "长度在 6 到 24 个字符",
          trigger: "blur",
        },
      ],
    };
    submitUser(formName: any) {
      (this.$refs[formName] as Form).validate(async (valid) => {
        if (valid) {
          if (this.editId) {
            await this["$http"].put(`/user/${this.editId}`, this.userForm);
            this.$message.success("更新成功");
          } else {
            await this["$http"].post("/user/create", this.userForm);
            this.$message.success("创建成功");
          }
          (this.$refs[formName] as Form).resetFields();
          this.dialogVisible = false;
          this.editId = "";
          this.userForm = {};
          this.UserFetch();
        } else {
          return false;
        }
      });
    }
    AvatarSuccess(res: any) {
      if (res.url) {
        this.$set(this.userForm, "imageUrl", "http://127.0.0.1:3000/" + res.url);
        this.$message.success(res.message);
      } else {
        this.$message.error(res.code + "-" + res.message);
      }
    }
    handleClose(done: any) {
      this.$confirm("确认关闭？")
        .then((_) => {
          this.editId = "";
          this.userForm = {};
          (this.$refs["userRuleFrom"] as Form).resetFields();
          done();
        })
        .catch((_) => {});
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