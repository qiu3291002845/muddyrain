<template>
  <div>
    <h5 class="mb-2">一级分类</h5>
    <el-button class="mt-2" type="primary" @click="createCategroy">新建分类</el-button>
    <el-dialog :title="!editId?'创建分类':'修改分类'" :visible.sync="dialogFormVisible" :before-close="handleClose">
      <el-form :model="createForm" label-width="80px" :rules="rulesForm" ref="ruleForm">
        <el-form-item label="一级分类" prop="firstCategoryName">
          <el-input placeholder="请输入一级分类" autofocus v-model="createForm.firstCategoryName" autocomplete="off">
          </el-input>
        </el-form-item>
        <el-form-item label="二级分类" prop="secondCategoryVO">
          <el-select v-model="createForm.secondCategoryVO" filterable multiple clearable placeholder="请选择二级分类"
            v-if="!editId">
            <el-option v-for="(item,index) in categoryOption" :key="item._id" :label="item.secondCategoryName"
              :value="item._id">
            </el-option>
          </el-select>
          <span v-else v-for="(item,index) in createForm.secondCategoryVO">
            <el-input v-model="item.secondCategoryName" class="m-2" :disabled="true">
            </el-input>
          </span>
        </el-form-item>
        <el-form-item label="分类图标" prop="image">
          <el-upload class="avatar-uploader" :action="$http.defaults.baseURL + '/uploadOSS'" :show-file-list="false"
            name="imageUrl" :on-success="handleAvatarSuccess">
            <img v-if="createForm.image" :src="createForm.image" class="avatar">
            <i v-else style="border: 1px dashed #d9d9d9" class="el-icon-plus avatar-uploader-icon"></i>
          </el-upload>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="handleClose">取 消</el-button>
        <el-button type="primary" @click="submitForm('ruleForm')" v-if="!editId">创 建</el-button>
        <el-button type="primary" @click="editSubmitForm('ruleForm')" v-if="editId">修 改</el-button>
      </div>
    </el-dialog>

    <el-table :data="tableData" stripe v-loading="loading">
      <el-table-column prop="_id" label="ID" width="220">
      </el-table-column>
      <el-table-column label="分类图标" width="160">
        <template slot-scope="scope">
          <img :src="scope.row.image" alt="" width="50" height="50">
        </template>
      </el-table-column>
      <el-table-column prop="firstCategoryName" label="一级分类" width="220">
      </el-table-column>
      <el-table-column label="二级分类" width="300">
        <template slot-scope="scope">
          <span v-for="(item,index) in scope.row.secondCategoryVO">
            {{item.secondCategoryName}}
          </span>
        </template>
      </el-table-column>
      <el-table-column label="操作">
        <template slot-scope="scope">
          <el-button size="mini" @click="EditFrom(scope.row._id)">编辑</el-button>
          <el-button size="mini" type="danger" @click="deleteCategory(scope.row._id)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
    <div class="mt-5">
      <el-pagination @current-change="handleCurrentChange" background :current-page.sync="currentPage" :page-size="10"
        layout="prev, pager, next, jumper" :total="tablelength.length">
      </el-pagination>
    </div>
  </div>
</template>

<script lang="ts">
  import {
    Vue,
    Component
  } from 'vue-property-decorator';
  import {
    Form
  } from 'element-ui';
  @Component({
    components: {}
  })
  export default class GirlFirst extends Vue {
    private tableData: Array < Object > = [{
      _id: '1564860864351864',
      image: 'https://muddyrain.oss-cn-beijing.aliyuncs.com/4.png',
      firstCategoryName: '连衣裙',
    }];
    private editId: String = "";
    private currentPage: number = 1
    private tablelength: number = 1
    // 创建表单
    private createForm: Object = {
      firstCategoryName: '',
      secondCategoryVO: [],
      image: '',
    };
    private rulesForm: Object = {
      firstCategoryName: [{
        required: true,
        message: '请输入一级分类',
        trigger: 'blur'
      }],
      secondCategoryVO: [{
        required: true,
        message: '请输入二级分类',
        trigger: 'blur'
      }],
      image: [{
        required: true,
        message: '请上传分类图标',
        trigger: 'blur'
      }],
    }
    categoryOption = [{
      _id: '1564860864351864',
      secondCategoryName: '长款连衣裙'
    }, ];
    private loading: Boolean = false;
    // 管理权限
    private purview: number = 1;
    // 新建表格对话框
    private dialogFormVisible: Boolean = false;
    createCategroy(): void {
      if (this.purview == 0) {
        this.$message.info("您不是管理员请勿乱动")
        return
      }
      this.dialogFormVisible = true;
    }
    beforeAvatarUpload(): void {
      this.$message.info('请上传您要创建的分类图标');
    }
    async submitForm(formName: any) {
      (this.$refs[formName] as Form).validate(async (valid) => {
        if (valid) {
          const res = await this.$http.post('/girl/first', this.createForm);
          this.$message.success(res.data.success);
          this.dialogFormVisible = false;
          this.createForm = {};
          this.currentPage = 1;
          this.findTableData();
        } else {
          return false;
        }
      });
    }
    async editSubmitForm(formName: any, id: String) {
      (this.$refs[formName] as Form).validate(async (valid) => {
        if (valid) {
          const res = await this.$http.put(`/girl/first/${this.editId}`, this.createForm);
          this.$message.success(res.data.success);
          this.dialogFormVisible = false;
          this.createForm = {};
          this.currentPage = 1;
          this.findTableData();
        } else {
          return false;
        }
      });
    }
    async handleClose() {
      this.dialogFormVisible = false;
      this.createForm = {}
      this.editId = ""
    }
    async handleAvatarSuccess(res: any) {
      if (res[0].uploaded == true) {
        this.$set(
          this.createForm,
          "image",
          res[0].src
        );
        this.$message.success(res[0].message);
      }
    }
    async findTableData() {
      const res = await this.$http.get('/girl/first?count=1');
      this.tableData = res.data.data;
    }
    async handleCurrentChange(val: number) {
      const res = await this.$http.get(`/girl/first?count=${val}`);
      this.tableData = res.data.data;
    }
    async EditFrom(id: string) {
      if (this.purview == 0) {
        this.$message.info("您不是管理员请勿乱动")
        return
      }
      this.editId = id;
      const res = await this.$http.get(`/girl/first/${id}`);
      this.createForm = res.data;
      console.log(this.createForm);
      this.dialogFormVisible = true;
    }
    async changeCategory() {
      const res = await this.$http.get('/girl/second');
      this.categoryOption = res.data.data;
    }
    async deleteCategory(id: string) {
      if (this.purview == 0) {
        this.$message.info("您不是管理员请勿乱动")
        return
      }
      this.$confirm('此操作将永久删除该文件, 是否继续?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(async () => {
        const res = await this.$http.delete(`/girl/category/${id}`);
        this.$message({
          type: 'success',
          message: '删除成功!'
        });
        this.findTableData();
      }).catch(() => {
        this.$message({
          type: 'info',
          message: '已取消删除'
        });
      });
    }
    created() {
      this.purview = (localStorage.getItem("purview") as any);
      this.findTableData();
      this.changeCategory();
    }
  }
</script>

<style scoped lang="scss">
  .avatar-uploader .el-upload {
    border: 1px dashed #d9d9d9;
    border-radius: 6px;
    cursor: pointer;
    position: relative;
    overflow: hidden;
  }

  .avatar-uploader .el-upload:hover {
    border-color: #409EFF;
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
    width: 120px;
    height: 120px;
    display: block;
    border: 1px dashed #ccc;
    padding: 5px;
  }
</style>