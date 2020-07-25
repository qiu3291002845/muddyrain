<template>
  <div>
    <h5>笔记本品牌</h5>
    <el-button class="mt-2" type="primary" @click="createCategory">新建品牌</el-button>
    <el-dialog :title="editId?'编辑品牌':'新建品牌'" :visible.sync="dialogFormVisible" :before-close="handleClose">
      <el-form :model="createFrom" label-width="80px">
        <el-form-item label="品牌名称">
          <span v-if="editId">
            <el-input v-model="createFrom.name" @keyup.enter.native="submitEdit(editId)" autocomplete="off"></el-input>
          </span>
          <span v-else>
            <el-input v-model="createFrom.name" @keyup.enter.native="submitCreate" autocomplete="off"></el-input>
          </span>
        </el-form-item>
        <el-form-item label="英文名称">
          <span v-if="editId">
            <el-input v-model="createFrom.ename" @keyup.enter.native="submitEdit(editId)" autocomplete="off"></el-input>
          </span>
          <span v-else>
            <el-input v-model="createFrom.ename" @keyup.enter.native="submitCreate" autocomplete="off"></el-input>
          </span>
        </el-form-item>
        <el-form-item label="品牌图片">
          <el-upload class="avatar-uploader" :action="$http.defaults.baseURL + '/uploadOSS'" :show-file-list="false"
            name="imageUrl" :on-success="handleAvatarSuccess">
            <img v-if="createFrom.imageUrl" :src="createFrom.imageUrl" class="avatar">
            <i v-else style="border: 1px dashed #d9d9d9" class="el-icon-plus avatar-uploader-icon"></i>
          </el-upload>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button class="mr-2" @click="dialogFormVisible = false;createFrom={};editId=''">取 消</el-button>
        <span v-if="editId">
          <el-button type="primary" @click="submitEdit(editId)">确 定</el-button>
        </span>
        <span v-else>
          <el-button type="primary" @click="submitCreate">确 定</el-button>
        </span>
      </div>
    </el-dialog>
    <el-table :data="tableData" style="width: 100%" stripe :row-key="tableData._id" v-loading="loading">
      <el-table-column sortable prop="_id" label="ID" width="270">
      </el-table-column>
      <el-table-column prop="name" label="品牌图标" width="160">
        <template slot-scope="scope">
          <div class="brandIcon">
            <el-tooltip :content="scope.row.name" placement="top" effect="light">
              <img :src="scope.row.imageUrl" width="45" height="25">
            </el-tooltip>
          </div>
        </template>
      </el-table-column>
      <el-table-column prop="name" label="品牌名" width="220">
      </el-table-column>
      <el-table-column prop="ename" label="英文名" width="220">
      </el-table-column>
      <el-table-column label="操作">
        <template slot-scope="scope">
          <el-button size="mini" @click="edit(scope.row._id)">编辑</el-button>
          <el-button size="mini" type="danger" @click="remove(scope.row._id)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
    <div class="mt-5">
      <el-pagination @current-change="handleCurrentChange" :current-page.sync="currentPage" :page-size="10"
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
  @Component({
    components: {}
  })
  export default class NoteBookBrand extends Vue {
    tableData = [{
      _id: 'asdas4das51658518cz',
      name: '惠普',
      ename: 'Hp',
      imageUrl: 'https://muddyrain.oss-cn-beijing.aliyuncs.com/images/20200705/1012063.png'
    }, ]
    private createFrom = {}
    private loading: boolean = false
    private dialogFormVisible: boolean = false
    private editId: string = "";
    private currentPage: number = 1
    private tablelength: number = 1
    private purview: number = 0
    createCategory() {
      if (this.purview == 0) {
        this.$message.info("您不是管理员请勿乱动")
        return
      }
      this.dialogFormVisible = true
    }
    async submitCreate() {
      const res = await this.$http.post('/notebook/brand/create',
        this.createFrom
      )
      this.dialogFormVisible = false
      this.createFrom = {}
      this.fetchTable()
    }
    async submitEdit(editId: any) {
      const res = await this.$http.put(`/notebook/brand/${this.editId}`, this.createFrom)
      this.dialogFormVisible = false
      this.createFrom = {}
      this.editId = "";
      this.fetchTable()
      this.$message.success(res.data.success)
    }
    async fetchTable(id ? : string) {
      if (id) {
        const res = await this.$http.get(`/notebook/brand/${id}`, )
        this.createFrom = res.data[0]
      } else {
        const re = await this.$http.get(`/notebook/brand`)
        this.tablelength = re.data;
        const res = await this.$http.get(`/notebook/brand?count=1`)
        this.tableData = res.data;
      }
    }
    async remove(id: string) {
      if (this.purview == 0) {
        this.$message.info("您不是管理员请勿乱动")
        return
      }
      this.$confirm("您确定要删除此品牌吗?", '删除品牌', {
        confirmButtonText: '确定',
        cancelButtonText: '取消'
      }).then(async () => {
        const res = await this.$http.delete(`/notebook/brand/${id}`)
        this.fetchTable()
        this.$message.success(res.data.success)
      }).catch(() => {
        this.$message.warning('取消删除')
      })
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
      const res = await this.$http.get(`/notebook/brand?count=${val}`)
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