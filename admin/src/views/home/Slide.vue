<template>
  <div>
    <h5 class="mb-3">轮播图管理</h5>
    <el-table :data="tableData" stripe>
      <el-table-column prop="_id" label="Id" width="240">
      </el-table-column>
      <el-table-column label="创建日期" width="240">
        <template slot-scope="scope">
          <h6>{{scope.row.createdAt |date }}</h6>
        </template>
      </el-table-column>
      <el-table-column label="修改日期" width="240">
        <template slot-scope="scope">
          <h6>{{scope.row.updatedAt |date}}</h6>
        </template>
      </el-table-column>
      <el-table-column label="缩略图" width="240">
        <template slot-scope="scope">
          <el-image style="width: 100px; height: 50px" fit="contain" :src="scope.row.imgUrl[0]"
            :preview-src-list="scope.row.imgUrl">
          </el-image>
        </template>
      </el-table-column>
      <el-table-column label="操作">
        <template slot-scope="scope">
          <el-button @click="edit(scope.row._id)">编辑</el-button>
          <el-button type="danger" @click="remove(scope.row._id)">删除</el-button>
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
    components: {},
    filters: {
      date(e: string) {
        return e.slice(0, 10);
      }
    }
  })
  export default class Slide extends Vue {
    private tableData: [{}] = [{
      _id: '1321567asd1231318',
      createdAt: '2020-07-27T06:30:09.829+00:00',
      updatedAt: '2020-07-27T06:30:09.829+00:00',
      imgUrl: [
        'https://img30.360buyimg.com/pop/s590x470_jfs/t1/125599/38/5987/63707/5efc3fa5Ed9a89d64/147e071697341f20.jpg.webp'
      ]
    }]
    async fetchData() {
      const res = await this.$http.get('slide');
      this.tableData = res.data;
      res.data.map((e: any, index: number) => {
        (this.tableData[index] as any).imgUrl = e.imgUrl[0];
      })
    }
    async edit(id: string) {
      // this.$router.push({
      //   name: 'EditSlide',
      //   params: {
      //     id: id
      //   }
      // })
      this.$message.info('轮播图不可编辑哦')
    }
    async remove(id: string) {
      if (this.purview == 0) {
        this.$message.info("您不是管理员请勿乱动")
        return
      }
      this.$confirm('此操作将永久删除该文件, 是否继续?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(async () => {
        const res = await this.$http.delete(`slide/${id}`);
        this.$message({
          type: 'success',
          message: '删除成功!'
        });
        this.fetchData();
      }).catch(() => {
        this.$message({
          type: 'info',
          message: '已取消删除'
        });
      });
    }
    // 管理权限
    private purview: number = 0;
    created() {
      this.fetchData();
      this.purview = (localStorage.getItem("purview") as any);
    }
  };
</script>

<style scoped>

</style>