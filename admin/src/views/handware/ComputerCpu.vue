<template>
  <div>
    <h5>电脑处理器</h5>
    <el-button class="mt-2" type="primary" @click="createCategory">新建CPU</el-button>
    <el-dialog :title="editId?'编辑CPU':'新建CPU'" :visible.sync="dialogFormVisible" :before-close="handleClose">
      <el-form :model="createFrom" label-width="80px" ref="ruleForm" :rules="rulesForm">
        <el-form-item label="厂商" prop="company">
          <el-select clearable v-model="createFrom.company" placeholder="请选择CPU厂商">
            <el-option v-for="item in companyOptions" :key="item" :label="item" :value="item">
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="型号" prop="name">
          <span v-if="editId">
            <el-input placeholder="请输入CPU的型号 (例如: i9-9980XE)" v-model="createFrom.name"
              @keyup.enter.native="submitEdit(editId)" autocomplete="off"></el-input>
          </span>
          <span v-else>
            <el-input placeholder="请输入CPU的型号 (例如: i9-9980XE)" v-model="createFrom.name"
              @keyup.enter.native="submitCreate('ruleForm')" autocomplete="off"></el-input>
          </span>
        </el-form-item>
        <el-form-item label="版本" prop="version">
          <span v-if="editId">
            <el-input placeholder="请输入CPU的版本 (例如: 九代酷睿)" v-model="createFrom.version"
              @keyup.enter.native="submitEdit(editId)" autocomplete="off"></el-input>
          </span>
          <span v-else>
            <el-input placeholder="请输入CPU的版本 (例如: 九代酷睿)" v-model="createFrom.version"
              @keyup.enter.native="submitCreate('ruleForm')" autocomplete="off"></el-input>
          </span>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button class="mr-2" @click="cancel">取 消</el-button>
        <span v-if="editId">
          <el-button type="primary" @click="submitEdit(editId)">确 定</el-button>
        </span>
        <span v-else>
          <el-button type="primary" @click="submitCreate('ruleForm')">确 定</el-button>
        </span>
      </div>
    </el-dialog>
    <el-table :data="tableData" style="width: 100%" stripe :row-key="tableData._id" v-loading="loading">
      <el-table-column sortable prop="_id" label="ID" width="270">
      </el-table-column>
      <el-table-column sortable prop="company" label="厂商" width="220">
        <template slot-scope="scope">
          <el-tag :type="scope.row.company == 'Intel'?'success':'warning'">
            {{scope.row.company}}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column sortable prop="version" label="版本" width="220">
      </el-table-column>
      <el-table-column sortable prop="name" label="型号" width="220">
      </el-table-column>
      <el-table-column label="操作" width="220">
        <template slot-scope="scope">
          <el-button size="mini" @click="edit(scope.row._id)">编辑</el-button>
          <el-button size="mini" type="danger" @click="remove(scope.row._id)">删除</el-button>
        </template>
      </el-table-column>
      <el-table-column>
        <template slot="header" slot-scope="scope">
          <el-tooltip content="请输入您要搜索的处理器型号或版本号" placement="top" effect="light">
            <!-- content to trigger tooltip here -->
            <el-input v-model="search" size="mini" placeholder="输入关键字搜索" style="width:60%" clearable
              @input="fetchSearch">
              <i slot="prefix" class="el-input__icon el-icon-search"></i>
            </el-input>
          </el-tooltip>
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
  export default class ComputerCpu extends Vue {
    tableData = [{
      _id: 'asdas4das51658518cz',
      company: 'intel',
      name: 'i9-9980XE',
    }, ]
    private createFrom = {}
    private loading: boolean = false
    private dialogFormVisible: boolean = false
    private editId: string = "";
    private currentPage: number = 1
    private tablelength: number = 1
    private purview: number = 0
    private search: string = ""
    private companyOptions = [
      "Intel",
      "AMD"
    ]
    private rulesForm = {
      name: [{
        required: true,
        message: '您必须输入处理器型号',
        trigger: 'blur'
      }],
      company: [{
        required: true,
        message: '您必须输入处理器厂商',
        trigger: 'change'
      }],
      version: [{
        required: true,
        message: '您必须输入处理器版本',
        trigger: 'blur'
      }]
    }
    createCategory() {
      if (this.purview == 0) {
        this.$message.info("您不是管理员请勿乱动")
        return
      }
      this.dialogFormVisible = true
    }
    async submitCreate(formName: any) {
      (this.$refs[formName] as Form).validate(async (valid) => {
        if (valid) {
          const res = await this.$http.post('/computercpu/create',
            this.createFrom
          )
          if (res) {
            this.dialogFormVisible = false
            this.createFrom = {}
            this.fetchTable()
            this.currentPage = 1
          }
          (this.$refs["ruleForm"] as Form).resetFields();
        } else {
          return false;
        }
      });
    }
    async submitEdit(editId: any) {
      const res = await this.$http.put(`/computercpu/${this.editId}`, this.createFrom)
      this.dialogFormVisible = false
      this.createFrom = {}
      this.editId = "";
      this.fetchTable()
      this.$message.success(res.data.success);
      (this.$refs["ruleForm"] as Form).resetFields();
    }
    async fetchTable(id ? : string) {
      if (id) {
        const res = await this.$http.get(`/computercpu/${id}`, )
        this.createFrom = res.data[0]
      } else {
        const re = await this.$http.get(`/computercpu`)
        this.tablelength = re.data;
        const res = await this.$http.get(`/computercpu?count=1`)
        this.tableData = res.data;
      }
    }
    async remove(id: string) {
      if (this.purview == 0) {
        this.$message.info("您不是管理员请勿乱动")
        return
      }
      this.$confirm("您确定要删除此处理器吗?", '删除处理器', {
        confirmButtonText: '确定',
        cancelButtonText: '取消'
      }).then(async () => {
        const res = await this.$http.delete(`/computercpu/${id}`)
        this.fetchTable()
        this.$message.success(res.data.success)
      }).catch(() => {
        this.$message.warning('取消删除')
      })
    }
    async cancel() {
      this.editId = '';
      this.createFrom = {};
      this.dialogFormVisible = false;
      (this.$refs["ruleForm"] as Form).resetFields();
      this.fetchTable()
    }
    async edit(id: string) {
      if (this.purview == 0) {
        this.$message.info("您不是管理员请勿乱动")
        return
      }
      this.dialogFormVisible = true
      this.editId = id;
      const res = await this.fetchTable(id)
    }
    async handleClose() {
      this.dialogFormVisible = false;
      (this.$refs["ruleForm"] as Form).resetFields();
      this.createFrom = {}
      this.editId = ""
    }
    async handleAvatarSuccess(res: any) {
      if (res[0].uploaded == true) {
        this.$set(
          this.createFrom,
          "imageUrl",
          "https://muddyrain.oss-cn-beijing.aliyuncs.com/" + res[0].path
        );
        this.$message.success(res[0].message);
      }
    }
    async handleCurrentChange(val: number) {
      const res = await this.$http.get(`/computercpu?count=${val}`)
      this.tableData = res.data;
    }
    async fetchSearch() {
      if (this.search == "") {
        this.fetchTable();
      }
      const res = await this.$http.get(`/computercpu?keyword=${this.search}`)
      this.tableData = res.data;
    }
    created() {
      this.purview = (localStorage.getItem("purview") as any);
      this.fetchTable()
    }

  };
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
    width: 200px;
    height: 120px;
    display: block;
    border: 1px dashed #ccc;
    padding: 5px;
  }
</style>