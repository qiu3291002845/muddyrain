<template>
  <div>
    <h5>博客分类</h5>
    <el-button class="mt-2" type="primary" @click="createCategory">新建分类</el-button>
    <el-dialog :title="editId?'编辑分类':'新建分类'" :visible.sync="dialogFormVisible" :before-close="handleClose">
      <el-form :model="createFrom">
        <el-form-item label="分类名称">
          <span v-if="editId">
            <el-input v-model="createFrom.name" @keyup.enter.native="submitEdit(editId)" autocomplete="off"></el-input>
          </span>
          <span v-else>
            <el-input v-model="createFrom.name" @keyup.enter.native="submitCreate" autocomplete="off"></el-input>
          </span>
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
      <el-table-column prop="_id" label="ID" width="220">
      </el-table-column>
      <el-table-column prop="name" label="分类名" width="240">
      </el-table-column>
      <el-table-column label="操作">
        <template slot-scope="scope">
          <el-button size="mini" @click="edit(scope.row._id)">编辑</el-button>
          <el-button size="mini" type="danger" @click="remove(scope.row._id)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
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
  export default class BlogCategory extends Vue {
    tableData = [{
      _id: 'asdas4das51658518cz',
      name: 'Java',
    }, ]
    private createFrom = {}
    private purview: number = 0
    private loading: boolean = false
    private dialogFormVisible: boolean = false
    private editId: string = "";
    createCategory() {
      if (this.purview == 0) {
        this.$message.info("您不是管理员请勿乱动")
        return
      }
      this.dialogFormVisible = true
    }
    async submitCreate() {
      const res = await this.$http.post('/blog/cat/create',
        this.createFrom
      )
      this.dialogFormVisible = false
      this.createFrom = {}
      this.fetchTable()
    }
    async submitEdit(editId: any) {
      const res = await this.$http.put(`/blog/cat/${this.editId}`, this.createFrom)
      this.dialogFormVisible = false
      this.createFrom = {}
      this.editId = "";
      this.fetchTable()
      this.$message.success(res.data.success)
    }
    async fetchTable(id ? : string) {
      if (id) {
        const res = await this.$http.get(`/blog/cat/${id}`, )
        this.createFrom = res.data[0]
      } else {
        const res = await this.$http.get('/blog/cat')
        this.tableData = res.data
      }
    }
    async remove(id: string) {
      if (this.purview == 0) {
        this.$message.info("您不是管理员请勿乱动")
        return
      }
      this.$confirm("您确定要删除此分类吗?", '删除分类', {
        confirmButtonText: '确定',
        cancelButtonText: '取消'
      }).then(async () => {
        const res = await this.$http.delete(`/blog/cat/${id}`)
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
    created() {
      this.purview = (localStorage.getItem("purview") as any);
      this.fetchTable()
    }

  };
</script>

<style scoped>

</style>