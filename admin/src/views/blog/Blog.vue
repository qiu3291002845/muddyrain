<template>
  <div>
    <h5>博客列表</h5>
    <el-button type="primary" class="mt-2" @click="createBlog">新建博客</el-button>
    <el-table :data="blogList" style="width: 100%" stripe>
      <el-table-column prop="createdAt" label="创建日期" width="160">
      </el-table-column>
      <el-table-column label="分类" width="100">
        <template slot-scope="scope">
          <el-tooltip class="item" effect="light" :content="scope.row.catgory.name" placement="top-start">
            <el-tag
              :type="scope.row.catgory.name === '前端' ? 'primary' : scope.row.catgory.name === '动画' ? 'danger' : scope.row.catgory.name === '设计' ? 'success' : scope.row.catgory.name === '数据库' ? 'warning' :'warning'"
              disable-transitions>
              {{scope.row.catgory.name}}</el-tag>
          </el-tooltip>
        </template>
      </el-table-column>
      <el-table-column prop="title" label="标题" width="180">
      </el-table-column>
      <el-table-column prop="author.name" label="作者" width="180">
      </el-table-column>
      <el-table-column prop="updatedAt" label="修改日期" width="220">
      </el-table-column>
      <el-table-column label="操作">
        <template slot-scope="scope">
          <el-button size="mini" @click="edit(scope.row.author._id,scope.row._id)">编辑</el-button>
          <el-button size="mini" type="danger" @click="remove(scope.row.author._id,scope.row._id)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
    <el-dialog title="验证用户(删除博客)" :visible.sync="dialogFormVisible">
      <el-form :model="userform" :rules="userRule" ref="ruleForm" label-width="80px">
        <el-form-item label="密码" prop="password">
          <el-input type="password" show-password v-model="userform.password"
            @keyup.enter.native="deleteBlog('ruleForm')" autocomplete="off"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogFormVisible = false;userform={}">取 消</el-button>
        <el-button type="primary" @click="deleteBlog('ruleForm')">确 定</el-button>
      </div>
    </el-dialog>
    <el-dialog title="验证用户(编辑博客)" :visible.sync="dialogFormEditVisible">
      <el-form :model="userform" :rules="userRule" ref="ruleForm" label-width="80px">
        <el-form-item label="密码" prop="password">
          <el-input type="password" show-password v-model="userform.password" @keyup.enter.native="EditBlog('ruleForm')"
            autocomplete="off"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogFormEditVisible = false;userform={}">取 消</el-button>
        <el-button type="primary" @click="EditBlog('ruleForm')">确 定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script lang="ts">
  import {
    Vue,
    Component,
  } from 'vue-property-decorator';
  import {
    Form
  } from 'element-ui';
  @Component({
    components: {},
  })
  export default class Blog extends Vue {
    private blogList: any = [{
      _id: '5effdc535ca41e4fb4c094b9',
      title: "打卡记录看",
      createdAt: "2020-07-04T01:33:07.381Z",
      updatedAt: "2020-07-04T01:33:07.381Z",
      catgory: {
        name: ''
      }
    }]
    private dialogFormVisible = false;
    private dialogFormEditVisible = false
    private userform = {}
    private volidateId: string | undefined
    private blogDeleteId: string | undefined
    private purview: number = 0
    userRule = {
      password: [{
        required: true,
        message: '请输入密码',
        trigger: 'blur'
      }]
    }
    async fetchBlogList() {
      const res = await this.$http.get('/blog')
      this.blogList = res.data;
      for (const item of this.blogList) {
        item.createdAt = item.createdAt.substring(0, 10);
        item.title = item.title.substring(0, 10);
        if (item.title.length >= 10) {
          item.title = item.title + '...'
        }
        item.updatedAt = item.updatedAt.substring(0, 10)
      }
    }
    async createBlog() {
      // if (this.purview == 0) {
      //   this.$message.info("您不是管理员请勿乱动")
      //   return
      // }
      this.$router.push('/blog/edit')
    }
    async edit(userId: string, blogId: string) {
      this.dialogFormEditVisible = true;
      this.volidateId = userId
      this.blogDeleteId = blogId
    }
    EditBlog(formName: any) {
      (this.$refs[formName] as Form).validate(async (valid) => {
        if (valid) {
          const res = await this.$http.post(`/login/volidatePass/${this.volidateId}`, this.userform)
          if (res.data.success) {
            this.$message.success('验证成功')
            this.dialogFormEditVisible = false;
            this.userform = {}
            this.$router.push(`/blog/edit/${this.blogDeleteId}`)
          } else {
            this.$message.error('您输入的密码不正确')
            this.userform = {}
          }
        } else {
          return false;
        }
      });
    }
    async remove(userId: string, blogId: string) {
      this.dialogFormVisible = true;
      this.volidateId = userId
      this.blogDeleteId = blogId
    }
    deleteBlog(formName: any) {
      (this.$refs[formName] as Form).validate(async (valid) => {
        if (valid) {
          const res = await this.$http.post(`/login/volidatePass/${this.volidateId}`, this.userform)
          if (res.data.success) {
            this.$message.success('验证成功')
            const res = await this.$http.delete(`blog/${this.blogDeleteId}`)
            this.dialogFormVisible = false;
            this.userform = {}
            this.fetchBlogList();
            if (res.data.success) {
              this.$notify({
                title: '成功',
                message: res.data.success,
                type: 'success'
              });
            }
          } else {
            this.$message.error('您输入的密码不正确')
            this.userform = {}
          }
        } else {
          return false;
        }
      });
    }
    created() {
      this.purview = this.$store.state.userFrom.purview
      this.fetchBlogList()
    }
  };
</script>

<style scoped>

</style>