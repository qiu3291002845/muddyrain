<template>
  <div>
    <h5 class="mb-2">笔记本管理</h5>
    <el-dialog :title="!editId?'创建商品':'编辑商品'" :visible.sync="dialogVisible" width="40%" :before-close="handleClose"
      :fullscreen="isFullscreen">
      <el-alert class="mb-4" title="若本地图片库未清理请您先清理再创建商品" type="error" v-if="!editId">
      </el-alert>
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
        <span v-if="!editId">
          <el-form-item label="商品品牌" prop="brand">
            <el-select clearable v-model="productForm.brand" filterable placeholder="请选择商品品牌"
              @visible-change="fetchBrand()">
              <el-option v-for="item in brandOptions" :key="item._id" :label="item.name" :value="item._id"></el-option>
            </el-select>
          </el-form-item>
        </span>
        <span v-else>
          <el-form-item label="商品品牌" prop="brand">
            <el-input v-model="brandName" disabled></el-input>
          </el-form-item>
        </span>
        <el-form-item label="副标题" prop="subtitle">
          <el-input type="textarea" :rows="2" placeholder="请输入副标题" v-model="productForm.subtitle"></el-input>
        </el-form-item>
        <el-form-item label="商品价格" prop="price">
          <el-input placeholder="请输入商品价格" v-model="productForm.price">
            <i slot="prefix" class="el-input__icon el-icon-attract"></i>
          </el-input>
        </el-form-item>
        <el-form-item label="商品颜色" prop="color">
          <el-select clearable v-model="productForm.color" filterable allow-create default-first-option
            placeholder="请选择商品颜色">
            <el-option v-for="item in colorOptions" :key="item" :label="item" :value="item"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="分辨率" prop="resolution">
          <el-input placeholder="请输入分辨率" v-model="productForm.resolution">
            <i slot="prefix" class="el-input__icon el-icon-monitor"></i>
          </el-input>
        </el-form-item>
        <span v-if="!editId">
          <el-form-item label="处理器" prop="cpu">
            <el-select v-model="productForm.cpu" filterable placeholder="请选择处理器" @visible-change="fetchCpu()" clearable>
              <el-option v-for="item in cpuOption" :key="item._id" :label="item.version + '_' + item.name"
                :value="item._id"></el-option>
            </el-select>
          </el-form-item>
        </span>
        <span v-else>
          <el-form-item label="处理器" prop="cpu">
            <el-input v-model="cpuName" disabled></el-input>
          </el-form-item>
        </span>
        <span v-if="!editId">
          <el-form-item label="显卡" prop="displayCard">
            <el-select v-model="productForm.displayCard" filterable @visible-change="fetchDisplayCard()"
              placeholder="请选择显卡" clearable>
              <el-option v-for="item in displayCardOption" :key="item._id" :label="item.version + '_' + item.name"
                :value="item._id"></el-option>
            </el-select>
          </el-form-item>
        </span>
        <span v-else>
          <el-form-item label="显卡" prop="displayCard">
            <el-input v-model="displayCardName" disabled></el-input>
          </el-form-item>
        </span>
        <el-form-item label="屏幕尺寸" prop="size">
          <el-select filterable clearable allow-create default-first-option v-model="productForm.size"
            placeholder="请选择屏幕尺寸大小">
            <el-option v-for="item in sizeOptions" :key="item" :label="item" :value="item"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="内存" prop="ram">
          <el-select filterable clearable allow-create default-first-option v-model="productForm.ram"
            placeholder="请选择内存">
            <el-option v-for="item in ramOptions" :key="item" :label="item" :value="item"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="硬盘种类" prop="hardDisk">
          <el-select filterable clearable v-model="productForm.hardDisk" placeholder="请选择硬盘种类">
            <el-option v-for="item in hardDiskOptions" :key="item" :label="item" :value="item"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="硬盘容量" prop="hardDiskCapacity">
          <el-select filterable clearable v-model="productForm.hardDiskCapacity" placeholder="请选择硬盘容量">
            <el-option v-for="item in hardDiskCapacityOptions" :key="item" :label="item" :value="item"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="操作系统" prop="os">
          <el-select filterable clearable v-model="productForm.os" placeholder="请选择操作系统">
            <el-option v-for="item in osOptions" :key="item" :label="item" :value="item"></el-option>
          </el-select>
        </el-form-item>
        <span v-if="!editId">
          <el-form-item label="商品图片" prop="imageUrl">
            <el-upload :action="$http.defaults.baseURL  + '/uploadManyOSS'" name="imageUrl" list-type="picture-card"
              :on-preview="handlePictureCardPreview" :on-success="handleUploadSuccess" :on-remove="handleRemove">
              <i class="el-icon-plus"></i>
            </el-upload>
            <el-dialog :visible.sync="uploadDialogVisible" id="uploadImage">
              <img width="100%" :src="productForm.imageUrl" alt />
            </el-dialog>
            <!-- <el-upload
              class="upload-demo"
              drag
              :action="$http.defaults.baseURL  + '/uploadManyOSS'"
              name="imageUrl"
              multiple>
              <i class="el-icon-upload"></i>
              <div class="el-upload__text">将文件拖到此处，或<em>点击上传</em></div>
              <div class="el-upload__tip" slot="tip">只能上传jpg/png文件，且不超过500kb</div>
            </el-upload> -->
          </el-form-item>
        </span>
        <span v-else>
          <el-form-item label="商品图片">
            <el-image style="width:150px;height:150px; padding:3px;border:1px dashed #ccc;" :src="srcList[0]"
              :preview-src-list="srcList">
            </el-image>
          </el-form-item>
          <!-- <el-form-item label="商品图片">
            <div class="d-flex flex-row justify-content-start flex-wrap">
              <div v-for="(item,index) in productForm.imageUrl" class="p-1 m-1 productImg" :key="index">
                <img :src="item[0] == ''?'https://muddyrain.oss-cn-beijing.aliyuncs.com/Logo.png':item[0]"
                  style="cursor:pointer" width="100px" height="100px" alt="..." />
                <div>
                  <el-tooltip content="点击修改图片" placement="top" effect="light">
                    <el-button type="text" @click="">
                      <i class="el-icon-picture-outline"></i>
                    </el-button>
                  </el-tooltip>
                  <el-tooltip content="点击删除图片" placement="top" effect="light">
                    <el-button type="text" @click="">
                      <i class="el-icon-delete"></i>
                    </el-button>
                  </el-tooltip>
                </div>
              </div>
              <div class="p-1 m-1 productImg">
                <el-tooltip content="点击添加图片" placement="top" effect="light">
                  <img src="../../assets/img/+.jpg" @click="addUploadImg" style="cursor:pointer" width="100px"
                    height="100px" alt="..." />
                </el-tooltip>
              </div>
            </div>
          </el-form-item> -->
        </span>
      </el-form>
      <span slot="footer">
        <el-button class="mr-2" @click="handleClose">取 消</el-button>
        <span v-if="!editId">
          <el-button type="primary" @click="submitFrom('productRule')">创 建</el-button>
        </span>
        <span v-else>
          <el-button type="primary" @click="editProductFrom('productRule')">修 改</el-button>
        </span>
      </span>
    </el-dialog>

    <el-button class="mt-2" type="primary" @click="createProduct">创建商品</el-button>
    <el-table :data="productList" stripe style="width:100%">
      <el-table-column label="创建日期" width="120">
        <template slot-scope="scope">
          <span>{{scope.row.createdAt | fromDate}}</span>
        </template>
      </el-table-column>
      <el-table-column label="商品品牌" width="120">
        <template slot-scope="scope">
          <el-tooltip :content="scope.row.brand.name" placement="top" effect="light">
            <!-- content to trigger tooltip here -->
            <el-tag type="warning" @click>{{scope.row.brand.name}}</el-tag>
          </el-tooltip>
        </template>
      </el-table-column>
      <el-table-column label="商品名称" width="200">
        <template slot-scope="scope">
          <el-tooltip :content="scope.row.name" placement="top" effect="light">
            <!-- content to trigger tooltip here -->
            <span>{{scope.row.name | titleSlice}}</span>
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
            <el-tooltip :content="scope.row.cpu.name" placement="top" effect="light">
              <span>{{scope.row.cpu.version + '_' + scope.row.cpu.name}}</span>
            </el-tooltip>
          </div>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="160">
        <template slot-scope="scope">
          <el-button @click="editFrom(scope.row._id)" size="small">编辑</el-button>
          <el-button type="danger" @click="remove(scope.row._id)" size="small">删除</el-button>
        </template>
      </el-table-column>
      <el-table-column>
        <template slot="header" slot-scope="scope">
          <el-tooltip content="请输入您要搜索的商品" placement="top" effect="light">
            <!-- content to trigger tooltip here -->
            <el-input v-model="search" size="mini" placeholder="输入关键字搜索商品" style="width:80%" clearable
              @input="fetchSearch">
              <i slot="prefix" class="el-input__icon el-icon-search"></i>
            </el-input>
          </el-tooltip>
        </template>
      </el-table-column>
    </el-table>
    <div class="block mt-3">
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
        return value.slice(0, 18) + "...";
      },
      fromDate(value: string) {
        return value.slice(0, 10);
      }
    }
  })
  export default class NoteBook extends Vue {
    private srcList: any = [
      'https://muddyrain.oss-cn-beijing.aliyuncs.com/7.jpg',
      'https://muddyrain.oss-cn-beijing.aliyuncs.com/200622_2cb6jdfi3aj3b8gcedd978ie40ej3_3888x5832.jpg_468x468.jpg'
    ];
    private imgList: any = [];
    private dialogVisible: boolean = false;
    private productForm: any = {
      imageUrl: [],
      cpu: {
        name: ''
      },
      displayCard: {
        name: ''
      },
      brand: {
        name: ''
      }
    };
    private currentPage: number = 1;
    private search: string = "";
    private tablelength: number = 1
    private editId: string = "";
    private cpuName: string = "";
    private displayCardName: string = "";
    private brandName: string = "";
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
    private colorOptions = ["黑色", "银色", "玫瑰金", "土豪金"];
    private cpuOption = [];
    private displayCardOption = [];
    private sizeOptions = [
      "11寸",
      "12寸",
      "13.3寸",
      "14.1寸",
      "15.1寸",
      "15.6寸",
      "17寸",
      "20寸"
    ];
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
    ];
    private hardDiskOptions = ["固态硬盘(SSD)", "机械硬盘(HDD)"];
    private hardDiskCapacityOptions = [
      "128G",
      "256G",
      "512G",
      "1024G(1T)",
      "2048G(2T)",
      "4096g(4T)",
      "6144G(6T)",
      "8192G(8T)"
    ];
    private osOptions = ["win10 (window)", "win7 (window)", "linux", "mac"];
    private brandOptions = [{
      _id: "",
      name: ""
    }];
    private productRules = {
      name: [{
        required: true,
        message: "请输入商品名称",
        trigger: "blur"
      }],
      brand: [{
        required: true,
        message: "请输入商品品牌",
        trigger: "change"
      }],
      subtitle: [{
        required: true,
        message: "请输入商品副标题",
        trigger: "blur"
      }],
      price: [{
        required: true,
        message: "请选择商品价格",
        trigger: "change"
      }],
      color: [{
        required: true,
        message: "请选择商品颜色",
        trigger: "change"
      }],
      resolution: [{
        required: true,
        message: "请选择商品分辨率",
        trigger: "change"
      }],
      cpu: [{
        required: true,
        message: "请选择商品处理器",
        trigger: "change"
      }],
      displayCard: [{
        required: true,
        message: "请选择商品显卡",
        trigger: "change"
      }],
      size: [{
        required: true,
        message: "请选择屏幕尺寸",
        trigger: "change"
      }],
      ram: [{
        required: true,
        message: "请选择商品内存",
        trigger: "change"
      }],
      hardDisk: [{
        required: true,
        message: "请选择硬盘种类",
        trigger: "change"
      }],
      hardDiskCapacity: [{
        required: true,
        message: "请选择硬盘容量",
        trigger: "change"
      }],
      os: [{
        required: true,
        message: "请选择操作系统",
        trigger: "change"
      }],
      imageUrl: [{
        required: true,
        message: "请上传商品图片",
        trigger: "change"
      }]
    };
    private uploadDialogVisible: boolean = false;
    async createProduct() {
      if (this.purview == 0) {
        this.$message.info("您不是管理员请勿乱动");
        return;
      }
      this.dialogVisible = true;
      this.$set(this.productForm, 'imageUrl', []);
    }
    async handleUploadSuccess(res: any, file: any, fileList: any) {
      let url = [];
      for (const element of fileList) {
        url.push(element.response[0].src);
        this.$message.success("上传成功");
      }
      // this.productForm['imageUrl'] = url;
      this.$set(this.productForm, "imageUrl", url);
    }
    async handleClose(done: any) {
      this.$confirm("确认关闭？")
        .then(_ => {
          this.editId = "";
          this.productForm = {
            imageUrl: [
              []
            ]
          };
          this.dialogVisible = false;
          this.isFullscreen = false;
          this.uploadDialogVisible = false;
          this.brandOptions = [];
          this.cpuOption = [];
          this.displayCardOption = [];
          // location.reload();
          (this.$refs["productRule"] as Form).resetFields();
          done();
        })
        .catch(_ => {});
    }
    async fetchBrand() {
      const res = await this.$http.get("notebook/brand");
      this.brandOptions = res.data;
    }
    async fetchCpu() {
      const res = await this.$http.get("computercpu");
      this.cpuOption = res.data;
    }
    async fetchDisplayCard() {
      const res = await this.$http.get("displaycard");
      this.displayCardOption = res.data;
    }
    handlePictureCardPreview(file: any) {
      this.uploadDialogVisible = true;
    }
    async handleRemove(file: any, fileList: any) {
      let url: any = [];
      // fileList.forEach(element => {
      //   url.push(element.response[0].src);
      // });
      for (const element of fileList) {
        url.push(element.response[0].src);
        this.$message.success("上传成功");
      }
      // this.productForm['imageUrl'] = url;
      // this.$set(this.productForm, "imageUrl", url);
      // const result = await this.$http.post(`deleteOSS`, {
      //   img: file.response[0].path
      // });
      // if (result.data.res.status == 200) {
      this.$message.success("已从阿里云存储库中删除");
      // }
    }
    submitFrom(formName: any) {
      (this.$refs[formName] as Form).validate(async valid => {
        if (valid) {
          const res = await this.$http.post("notebook", this.productForm);
          this.editId = "";
          this.dialogVisible = false;
          this.isFullscreen = false;
          this.$set(this.productForm, 'imageUrl', []);
          (this.$refs["productRule"] as Form).resetFields();
          this.fetchList()
          this.$message.success(res.data.success)
          this.uploadDialogVisible = false;
          this.brandOptions = [];
          this.cpuOption = [];
          this.displayCardOption = [];
        } else {
          return false;
        }
      });
    }
    async fetchSearch() {
      const res = await this.$http.get(`/notebook?keyword=${this.search}`)
      this.productList = res.data;
    }
    editProductFrom(formName: any) {
      (this.$refs[formName] as Form).validate(async valid => {
        if (valid) {
          const res = await this.$http.put(`notebook/${this.editId}`, this.productForm);
          this.editId = "";
          this.productForm = {};
          this.dialogVisible = false;
          this.isFullscreen = false;
          this.$set(this.productForm, 'imageUrl', []);
          (this.$refs["productRule"] as Form).resetFields();
          this.fetchList()
          this.$message.success(res.data.success)
          this.uploadDialogVisible = false;
          this.brandOptions = [];
          this.cpuOption = [];
          this.displayCardOption = [];
        } else {
          return false;
        }
      });
    }
    async handleCurrentChange(val: number) {
      const res = await this.$http.get(`/notebook?count=${val}`)
      this.productList = res.data;
    }
    async fetchList() {
      const res = await this.$http.get('/notebook?count=1');
      this.productList = res.data;
    }
    async editFrom(id: string) {
      if (this.purview == 0) {
        this.$message.info("您不是管理员请勿乱动");
        return;
      }
      this.editId = id;
      this.dialogVisible = true;
      const res = await this.$http.get(`notebook/${id}`);
      res.data[0].imageUrl.map((e: any): any => {
        this.imgList.push(e[0]);
      })
      this.srcList = this.imgList;
      this.productForm = res.data[0];
      this.$delete(this.productForm, '_id');
      this.displayCardName = res.data[0].displayCard.name;
      this.cpuName = res.data[0].cpu.name;
      this.brandName = res.data[0].brand.name;
      // this.srcList = this.productForm['imageUrl'];
    }
    async addUploadImg() {
      let a = ['']
      this.productForm['imageUrl'].psuh(a);
    }
    async remove(id: string) {
      if (this.purview == 0) {
        this.$message.info("您不是管理员请勿乱动");
        return;
      }
      this.$confirm('此操作将永久删除该商品, 是否继续', '删除商品', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(async () => {
        const res = await this.$http.delete(`notebook/${id}`);
        this.$message.success(res.data.success)
        this.fetchList()
      }).catch(() => {
        this.$message.info('取消删除')
      })
    }
    selectBrand() {
      this.fetchBrand();
    }
    created() {
      this.purview = this.$store.state.userFrom.purview;
      this.fetchList();
    }
  }
</script>

<style lang="scss">
  .productImg {
    height: auto;
    border: 2px dashed #ccc;
    position: relative;
    overflow: hidden;

    div {
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      padding-top: 30px;
      transition: all 0.5s;
      transform: translateY(-100%);
      text-align: center;
      background: rgba($color: #000000, $alpha:0.3);

      button {
        font-size: 24px;
        color: white;
        transition: all 0.2s;
      }

      button:hover {
        color: #ddd;
      }
    }
  }

  #uploadImage {
    z-index: 9999 !important;

  }

  #uploadImage .el-dialog {
    z-index: 9999 !important;
  }

  .productImg:hover div {
    transform: translateY(0);
  }
</style>