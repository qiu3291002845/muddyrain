<template>
  <div>
    <h5 class="mb-2">笔记本管理</h5>
    <el-table :data="notebookList" stripe style="width:100%">
      <el-table-column prop="createdAt" label="创建日期" width="160">
      </el-table-column>
      <el-table-column label="商品品牌" width="120">
        <template slot-scope="scope">
          <el-tag type="warning" @click="">{{scope.row.catgory}}</el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="name" label="商品名称" width="160">
      </el-table-column>
      <el-table-column label="商品价格" width="160">
        <template slot-scope="scope">
          <div><span style="font-size:20px">{{scope.row.price}}</span>元</div>
        </template>
      </el-table-column>
      <el-table-column prop="resolution" label="分辨率" width="160">
      </el-table-column>
      <el-table-column label="配置" width="200">
        <template slot-scope="scope">
          {{scope.row.config | configSlice}}
        </template>
      </el-table-column>
      <el-table-column label="操作">
        <template slot-scope="scope">
          <el-button @click="" size="small">查看</el-button>
          <el-button type="danger" size="small">编辑</el-button>
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
  @Component({
    components: {},
    filters: {
      configSlice(value: string) {
        return value.slice(0, 15) + '...'
      }
    }
  })
  export default class NoteBook extends Vue {
    notebookList = [{
      createdAt: '2016-05-02',
      catgory: '小米',
      name: '小米笔记本Air 13.3',
      price: '5199',
      resolution: '1920 * 1080',
      config: '第八代英特尔酷睿i7-8550U 16G 512G PCIE SSD MX250 2G独显 72%NTSC 指纹识别 Office',
      address: '上海市普陀区金沙江路 1518 弄'
    }]
  }
</script>

<style lang="scss">
</style>