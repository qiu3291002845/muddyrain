<template>
  <div>
    <h5 class="mb-2">笔记本管理</h5>
    <el-dialog title="创建商品" :visible.sync="dialogVisible" width="40%" :before-close="handleClose"
      :fullscreen="isFullscreen">
      <el-form :model="productForm" ref="form" label-width="80px">
        <el-form-item label="商品名称">
          <div class="d-flex">
            <el-input v-model="productForm.name"></el-input>
            <el-tooltip content="点击全屏" placement="top" effect="light">
              <el-button class="ml-2" @click="isFullscreen=!isFullscreen">
                <i class="el-icon-full-screen"></i>
              </el-button>
            </el-tooltip>
          </div>
        </el-form-item>
        <el-form-item label="商品品牌">
          <el-select v-model="productForm.brand" filterable placeholder="请选择">
            <el-option v-for="item in brandOptions" :key="item._id" :label="item.name" :value="item._id">
            </el-option>
          </el-select>
        </el-form-item>

      </el-form>
      <span slot="footer">
        <el-button @click="handleClose">取 消</el-button>
        <el-button type="primary" @click="">确 定</el-button>
      </span>
    </el-dialog>

    <el-button class="mt-2" type="primary" @click="dialogVisible = true">创建商品</el-button>
    <el-table :data="productList" stripe style="width:100%">
      <el-table-column prop="createdAt" label="创建日期" width="120"></el-table-column>
      <el-table-column label="商品品牌" width="120">
        <template slot-scope="scope">
          <el-tag type="warning" @click>{{scope.row.catgory}}</el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="name" label="商品名称" width="160"></el-table-column>
      <el-table-column label="商品价格" width="160">
        <template slot-scope="scope">
          <div>
            <span style="font-size:20px">{{scope.row.price}}</span>元
          </div>
        </template>
      </el-table-column>
      <el-table-column prop="resolution" label="分辨率" width="160"></el-table-column>
      <el-table-column label="配置" width="200">
        <template slot-scope="scope">{{scope.row.config | configSlice}}</template>
      </el-table-column>
      <el-table-column label="操作">
        <template slot-scope="scope">
          <el-button @click size="small">查看</el-button>
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
  import {
    Form
  } from "element-ui";
  @Component({
    components: {},
    filters: {
      configSlice(value: string) {
        return value.slice(0, 15) + "...";
      }
    }
  })
  export default class NoteBook extends Vue {
    private dialogVisible: boolean = false;
    private productForm: object = {}
    private editId: string = ''
    private isFullscreen: boolean = false;
    private productList = [{
      createdAt: "2020-07-04",
      catgory: "小米",
      name: "小米笔记本Air 13.3",
      price: "5199",
      resolution: "1920 * 1080",
      config: "第八代英特尔酷睿i7-8550U 16G 512G PCIE SSD MX250 2G独显 72%NTSC 指纹识别 Office",
      address: "上海市普陀区金沙江路 1518 弄"
    }];
    private brandOptions = [{
      _id: 'da8431xda184cz',
      name: '惠普',
    }]
    async handleClose(done: any) {
      this.$confirm("确认关闭？")
        .then((_) => {
          this.editId = "";
          this.productForm = {};
          this.dialogVisible = false;
          this.isFullscreen = false;
          // location.reload();
          (this.$refs["userRuleFrom"] as Form).resetFields();
          done();
        })
        .catch((_) => {});
    }
    async fetchBrand() {
      const res = await this.$http.get('notebook/brand')
      this.brandOptions = res.data
    }
    created() {
      this.fetchBrand()
    }
  }
</script>

<style lang="scss">
</style>