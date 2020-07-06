<template>
  <div>
    <h5 class="mb-2">笔记本管理</h5>
    <el-dialog title="创建商品" :visible.sync="dialogVisible" width="40%" :before-close="handleClose"
      :fullscreen="isFullscreen">
      <el-form :model="productForm" ref="productRule" :rules="productRules" label-width="80px">
        <el-form-item label="商品名称" prop="name">
          <div class="d-flex">
            <el-input v-model="productForm.name" placeholder="请输入商品名称"></el-input>
            <el-tooltip content="点击全屏" placement="top" effect="light">
              <el-button class="ml-2" @click="isFullscreen=!isFullscreen">
                <i class="el-icon-full-screen"></i>
              </el-button>
            </el-tooltip>
          </div>
        </el-form-item>
        <el-form-item label="商品品牌" prop="brand">
          <el-select clearable v-model="productForm.brand" filterable placeholder="请选择商品品牌">
            <el-option v-for="item in brandOptions" :key="item._id" :label="item.name" :value="item._id">
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="副标题" prop="subtitle">
          <el-input type="textarea" :rows="2" placeholder="请输入副标题" v-model="productForm.subtitle">
          </el-input>
        </el-form-item>
        <el-form-item label="商品价格" prop="price">
          <div class="block">
            <el-slider v-model="productForm.price" :min="0" :max="99999" show-input>
            </el-slider>
          </div>
        </el-form-item>
        <el-form-item label="商品颜色" prop="color">
          <el-select clearable v-model="productForm.color" multiple filterable allow-create default-first-option
            placeholder="请选择商品颜色">
            <el-option v-for="item in colorOptions" :key="item" :label="item" :value="item">
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="分辨率" prop="resolution">
          <el-input placeholder="请输入分辨率" v-model="productForm.resolution">
            <i slot="prefix" class="el-input__icon el-icon-monitor"></i>
          </el-input>
        </el-form-item>
        <el-form-item label="处理器" prop="cpu">
          <el-select v-model="productForm.cpu" filterable placeholder="请选择处理器" clearable>
            <el-option v-for="item in cpuOption " :key="item._id" :label="item.version + '_' + item.name"
              :value="item._id">
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="显卡" prop="displayCard">
          <el-select v-model="productForm.displayCard" filterable placeholder="请选择显卡" clearable>
            <el-option v-for="item in displayCardOption " :key="item._id" :label="item.version + '_' + item.name"
              :value="item._id">
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="屏幕尺寸" prop="size">
          <el-select filterable clearable allow-create multiple default-first-option v-model="productForm.size"
            placeholder="请选择屏幕尺寸大小">
            <el-option v-for="item in sizeOptions" :key="item" :label="item" :value="item">
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="内存" prop="ram">
          <el-select filterable clearable allow-create multiple default-first-option v-model="productForm.ram"
            placeholder="请选择内存">
            <el-option v-for="item in ramOptions" :key="item" :label="item" :value="item">
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="硬盘种类" prop="hardDisk">
          <el-select filterable clearable v-model="productForm.hardDisk" placeholder="请选择硬盘种类">
            <el-option v-for="item in hardDiskOptions" :key="item" :label="item" :value="item">
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="硬盘容量" prop="hardDiskCapacity">
          <el-select filterable clearable v-model="productForm.hardDiskCapacity" placeholder="请选择硬盘容量">
            <el-option v-for="item in hardDiskCapacityOptions" :key="item" :label="item" :value="item">
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="操作系统" prop="os">
          <el-select filterable clearable v-model="productForm.os" placeholder="请选择操作系统">
            <el-option v-for="item in osOptions" :key="item" :label="item" :value="item">
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="商品图片" prop="imageUrl">
          <el-upload :action="$http.defaults.baseURL  + '/uploadManyOSS'" name="imageUrl" list-type="picture-card"
            :on-preview="handlePictureCardPreview" :on-success="handleUploadSuccess" :on-remove="handleRemove">
            <i class="el-icon-plus"></i>
          </el-upload>
          <el-dialog :visible.sync="uploadDialogVisible">
            <img width="100%" :src="productForm.imageUrl" alt="">
          </el-dialog>
        </el-form-item>
      </el-form>
      <span slot="footer">
        <el-button @click="handleClose">取 消</el-button>
        <el-button type="primary" @click="submitFrom('productRule')">确 定</el-button>
      </span>
    </el-dialog>

    <el-button class="mt-2" type="primary" @click="createProduct">创建商品</el-button>
    <el-table :data="productList" stripe style="width:100%">
      <el-table-column prop="createdAt" label="创建日期" width="120"></el-table-column>
      <el-table-column label="商品品牌" width="120">
        <template slot-scope="scope">
          <el-tooltip :content="scope.row.brand" placement="top" effect="light">
            <!-- content to trigger tooltip here -->
            <el-tag type="warning" @click>{{scope.row.brand}}</el-tag>
          </el-tooltip>
        </template>
      </el-table-column>
      <el-table-column label="商品名称" width="200">
        <template slot-scope="scope">
          <el-tooltip :content="scope.row.name" placement="top" effect="light">
            <!-- content to trigger tooltip here -->
            <span>{{scope.row.name |  titleSlice}}</span>
          </el-tooltip>
        </template>
      </el-table-column>
      <el-table-column label="副标题" width="200">
        <template slot-scope="scope">
          <el-tooltip :content="scope.row.subtitle" placement="top" effect="light">
            <!-- content to trigger tooltip here -->
            <span>{{scope.row.subtitle | subtitleSlice}}</span>
          </el-tooltip>
        </template>
      </el-table-column>
      <el-table-column label="商品价格" width="160">
        <template slot-scope="scope">
          <div>
            <span style="font-size:20px">{{scope.row.price}}</span>元
          </div>
        </template>
      </el-table-column>
      <el-table-column prop="color" label="颜色" width="160"></el-table-column>
      <el-table-column prop="resolution" label="分辨率" width="160"></el-table-column>
      <el-table-column label="处理器" width="160">
        <template slot-scope="scope">
          <div>
            <el-tooltip :content="scope.row.cpu" placement="top" effect="light">
              <span>{{scope.row.cpu | titleSlice}}</span>
            </el-tooltip>
          </div>
        </template>
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
      subtitleSlice(value: string) {
        return value.slice(0, 15) + "...";
      },
      titleSlice(value: string) {
        return value.slice(0, 10) + "...";
      }
    }
  })
  export default class NoteBook extends Vue {
    private dialogVisible: boolean = false;
    private productForm: object = {
      imageUrl: []
    }
    private editId: string = ''
    private isFullscreen: boolean = false;
    private purview: number = 0;
    private productList = [{
      createdAt: "2020-07-04",
      brand: "小米",
      name: "小米笔记本Air 13.3",
      price: "5199",
      color: "磨砂黑",
      resolution: "1920 * 1080",
      subtitle: "i9-10980HK，RTX 2080 Super Max-Q，300Hz刷新率，双屏游戏笔记本电脑。",
      address: "上海市普陀区金沙江路 1518 弄",
      cpu: "第七代英特尔 i7 处理器"
    }];
    private colorOptions = [
      "黑色",
      "银色",
      "玫瑰金",
      "土豪金"
    ]
    private cpuOption = []
    private displayCardOption = []
    private sizeOptions = [
      "11寸",
      "12寸",
      "13.3寸",
      "14.1寸",
      "15.1寸",
      "15.6寸",
      "17寸",
      "20寸"
    ]
    private ramOptions = [
      "2G",
      "4G",
      "6G",
      "8G",
      "10G",
      "12G",
      "16G",
      "20G",
      "24G",
      "36G",
      "48G"
    ]
    private hardDiskOptions = [
      "固态硬盘(SSD)",
      "机械硬盘(HDD)"
    ]
    private hardDiskCapacityOptions = [
      "128G",
      "256G",
      "512G",
      "1024G(1T)",
      "2048G(2T)",
      "4096g(4T)",
      "6144G(6T)",
      "8192G(8T)"
    ]
    private osOptions = [
      "win10 (window)",
      "win7 (window)",
      "linux",
      "mac"
    ]
    private brandOptions = [{
      _id: 'da8431xda184cz',
      name: '惠普',
    }]
    private productRules = {
      name: [{
        required: true,
        message: '请输入商品名称',
        trigger: 'blur'
      }],
      brand: [{
        required: true,
        message: '请输入商品名称',
        trigger: 'blur'
      }],
      subtitle: [{
        required: true,
        message: '请输入商品副标题',
        trigger: 'blur'
      }],
      price: [{
        required: true,
        message: '请选择商品价格',
        trigger: 'change'
      }],
      color: [{
        required: true,
        message: '请选择商品颜色',
        trigger: 'change'
      }],
      resolution: [{
        required: true,
        message: '请选择商品分辨率',
        trigger: 'change'
      }],
      cpu: [{
        required: true,
        message: '请选择商品处理器',
        trigger: 'change'
      }],
      displayCard: [{
        required: true,
        message: '请选择商品显卡',
        trigger: 'change'
      }],
      size: [{
        required: true,
        message: '请选择屏幕尺寸',
        trigger: 'change'
      }],
      ram: [{
        required: true,
        message: '请选择商品内存',
        trigger: 'change'
      }],
      hardDisk: [{
        required: true,
        message: '请选择硬盘种类',
        trigger: 'change'
      }],
      hardDiskCapacity: [{
        required: true,
        message: '请选择硬盘容量',
        trigger: 'change'
      }],
      os: [{
        required: true,
        message: '请选择操作系统',
        trigger: 'change'
      }],
      imageUrl: [{
        required: true,
        message: '请上传商品图片',
        trigger: 'change'
      }]
    }
    private uploadDialogVisible: boolean = false;
    async createProduct() {
      if (this.purview == 0) {
        this.$message.info("您不是管理员请勿乱动")
        return
      }
      this.dialogVisible = true
    }
    async handleUploadSuccess(res: any, file: any, fileList: any) {
      let url = []
      for (const element of fileList) {
        url.push(element.response[0].src);
        this.$message.success('上传成功');
      }
      // this.productForm['imageUrl'] = url;
      this.$set(this.productForm, 'imageUrl', url)
    }
    async handleClose(done: any) {
      this.$confirm("确认关闭？")
        .then((_) => {
          this.editId = "";
          this.productForm = {};
          this.dialogVisible = false;
          this.isFullscreen = false;
          // location.reload();
          (this.$refs["productRule"] as Form).resetFields();
          done();
        })
        .catch((_) => {});
    }
    async fetchBrand() {
      const res = await this.$http.get('notebook/brand')
      this.brandOptions = res.data
    }
    async fetchCpu() {
      const res = await this.$http.get('computercpu')
      this.cpuOption = res.data;
    }
    async fetchDisplayCard() {
      const res = await this.$http.get('displaycard')
      this.displayCardOption = res.data;
    }
    handlePictureCardPreview(file: any) {
      this.uploadDialogVisible = true;
    }
    async handleRemove(file: any, fileList: any) {
      let url: any = []
      // fileList.forEach(element => {
      //   url.push(element.response[0].src);
      // });
      for (const element of fileList) {
        url.push(element.response[0].src);
        this.$message.success('上传成功');
      }
      // this.productForm['imageUrl'] = url;
      this.$set(this.productForm, 'imageUrl', url)
      const result = await this.$http.post(`deleteOSS`, {
        img: file.response[0].path
      })
      if (result.data.res.status == 200) {
        this.$message.success('已从阿里云存储库中删除')
      }
    }
    submitFrom(formName) {
      (this.$refs[formName] as Form).validate(async (valid) => {
        if (valid) {
          console.log(this.productForm);
          console.log(formName);
        } else {
          return false;
        }
      });
    }
    created() {
      this.purview = this.$store.state.userFrom.purview;
      this.fetchBrand()
      this.fetchCpu()
      this.fetchDisplayCard()
    }
  }
</script>

<style lang="scss">
</style>