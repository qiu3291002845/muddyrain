<template>
  <div>
    <h5>电脑显卡</h5>
    <el-button class="mt-2" type="primary" @click="createCategory">新建显卡</el-button>
    <el-dialog :title="editId?'编辑显卡':'新建显卡'" :visible.sync="dialogFormVisible" :before-close="handleClose">
      <el-form :model="createFrom" label-width="80px" ref="ruleForm" :rules="rulesForm">
        <el-form-item label="厂商" prop="company">
          <el-select clearable v-model="createFrom.company" placeholder="请选择显卡厂商">
            <el-option v-for="item in companyOptions" :key="item" :label="item" :value="item">
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="型号" prop="name">
          <span v-if="editId">
            <el-input placeholder="请输入显卡的型号 (例如: RTX 2080 Ti )" v-model="createFrom.name"
              @keyup.enter.native="submitEdit(editId)" autocomplete="off"></el-input>
          </span>
          <span v-else>
            <el-input placeholder="请输入显卡的型号 (例如: RTX 2080 Ti )" v-model="createFrom.name"
              @keyup.enter.native="submitCreate('ruleForm')" autocomplete="off"></el-input>
          </span>
        </el-form-item>
        <el-form-item label="版本" prop="version">
          <span v-if="editId">
            <el-input placeholder="请输入显卡的版本 (例如: GeForce 20 )" v-model="createFrom.version"
              @keyup.enter.native="submitEdit(editId)" autocomplete="off"></el-input>
          </span>
          <span v-else>
            <el-input placeholder="请输入显卡的版本 (例如: GeForce 20 )" v-model="createFrom.version"
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
          <el-tag :type="scope.row.company == 'NVIDIA'?'success':'danger'">
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
          <el-tooltip content="请输入您要搜索的显卡型号或版本号" placement="top" effect="light">
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
  export default class displaycard extends Vue {
    tableData = [{
      _id: 'asdas4das51658518cz',
      company: 'NVIDIA',
      version: 'GeForce20',
      name: 'RTX 2080 Ti',
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
      "NVIDIA",
      "AMD"
    ]
    private rulesForm = {
      name: [{
        required: true,
        message: '您必须输入显卡型号',
        trigger: 'blur'
      }],
      company: [{
        required: true,
        message: '您必须输入显卡厂商',
        trigger: 'change'
      }],
      version: [{
        required: true,
        message: '您必须输入显卡版本',
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
          const res = await this.$http.post('/displaycard/create',
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
      const res = await this.$http.put(`/displaycard/${this.editId}`, this.createFrom)
      this.dialogFormVisible = false
      this.createFrom = {}
      this.editId = "";
      this.fetchTable()
      this.$message.success(res.data.success);
      (this.$refs["ruleForm"] as Form).resetFields();
    }
    async fetchTable(id ? : string) {
      if (id) {
        const res = await this.$http.get(`/displaycard/${id}`, )
        this.createFrom = res.data[0]
      } else {
        const re = await this.$http.get(`/displaycard`)
        this.tablelength = re.data;
        const res = await this.$http.get(`/displaycard?count=1`)
        this.tableData = res.data;
      }
    }
    async remove(id: string) {
      if (this.purview == 0) {
        this.$message.info("您不是管理员请勿乱动")
        return
      }
      this.$confirm("您确定要删除此显卡吗?", '删除显卡', {
        confirmButtonText: '确定',
        cancelButtonText: '取消'
      }).then(async () => {
        const res = await this.$http.delete(`/displaycard/${id}`)
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
      const res = await this.$http.get(`/displaycard?count=${val}`)
      this.tableData = res.data;
    }
    async fetchSearch() {
      const res = await this.$http.get(`/displaycard?keyword=${this.search}`)
      this.tableData = res.data;
    }
    created() {
      this.purview = this.$store.state.userFrom.purview
      this.fetchTable()
    }

  };
</script>

<style scoped lang="scss">
</style>