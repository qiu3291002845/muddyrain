<template>
  <div>
    <h5 class="mb-2">{{id?'编辑商品':'创建商品'}}</h5>
    <el-form :model="createForm" :rules="rules" ref="ruleform" label-width="80px">
      <el-form-item label="商品名称" prop="goodsName">
        <el-input v-model="createForm.goodsName" placeholder="请输入商品名称" autofocus></el-input>
      </el-form-item>
      <el-form-item label="一级分类" prop="firstCategoryName">
        <el-select v-model="createForm.firstCategoryName" filterable clearable placeholder="请选择商品分类" v-if="!id">
          <el-option v-for="(item,index) in firstOption" :key="item._id" :label="item.firstCategoryName"
            :value="item._id">
          </el-option>
        </el-select>
        <el-input v-else v-model="firstCategoryName" :disabled="true"></el-input>
      </el-form-item>
      <el-form-item label="二级分类" prop="secondCategoryName">
        <el-select v-model="createForm.secondCategoryName" filterable clearable placeholder="请选择商品分类" v-if="!id">
          <el-option v-for="(item,index) in secondOption" :key="item._id" :label="item.secondCategoryName"
            :value="item._id">
          </el-option>
        </el-select>
        <el-input v-else v-model="secondCategoryName" :disabled="true"></el-input>
      </el-form-item>
      <el-form-item label="商品现价" prop="presentPrice">
        <el-input v-model="createForm.presentPrice" width="320" placeholder="请输入商品现价(例:￥72.70)">
          <i slot="prefix" class="iconfont icon-renminbi"></i>
        </el-input>
      </el-form-item>
      <el-form-item label="商品原价" prop="oriPrice">
        <el-input v-model="createForm.oriPrice" placeholder="请输入商品原价(例:￥85.70)">
          <i slot="prefix" class="iconfont icon-renminbi"></i>
        </el-input>
      </el-form-item>
      <el-form-item label="商品库存" prop="amount">
        <el-input v-model="createForm.amount" placeholder="请输入商品库存(例:500)">
          <i slot="prefix" class="iconfont icon-kucun"></i>
        </el-input>
      </el-form-item>
      <el-form-item label="商品图片" v-if="!id" prop="goodsDetail">
        <el-upload name="imageUrl" :action="$http.defaults.baseURL + '/uploadManyOSS'" list-type="picture-card"
          :on-preview="handlePictureCardPreview" :on-remove="handleRemove" :before-upload="beforeAvatarUpload"
          :on-success="handleAvatarSuccess">
          <i class="el-icon-plus"></i>
        </el-upload>
        <el-dialog :visible.sync="dialogVisible">
          <img width="100%" :src="dialogsrcList" alt="">
        </el-dialog>
      </el-form-item>
      <el-form-item label="商品图片" v-else>
        <div class="thumbnail">
          <el-image v-if="srcList!= []" style="width: 130px; height: 160px" :src="srcList[0]"
            :preview-src-list="srcList">
          </el-image>
        </div>
      </el-form-item>

      <el-form-item>
        <el-button type="primary" @click="submitForm('ruleform')" v-if="!id">立即创建</el-button>
        <el-button type="primary" @click="editForm('ruleform')" v-else>立即修改</el-button>
        <el-button @click="cancel">取消</el-button>
      </el-form-item>
    </el-form>
  </div>
</template>

<script lang="ts">
  import {
    Vue,
    Component,
    Prop
  } from 'vue-property-decorator';
  import {
    Form
  } from 'element-ui';
  @Component({
    components: {}
  })
  export default class GirlEdit extends Vue {
    @Prop(String) id: string | undefined;
    private srcList = [
      'https://muddyrain.oss-cn-beijing.aliyuncs.com/7.jpg',
      'https://muddyrain.oss-cn-beijing.aliyuncs.com/200622_2cb6jdfi3aj3b8gcedd978ie40ej3_3888x5832.jpg_468x468.jpg'
    ];
     private firstCategoryName: string = '';
    private secondCategoryName: string = '';
    // 管理权限
    private purview: number = 1;
    private createForm: Object = {
      goodsDetail: [],
    }
    firstOption = [{
      _id: '1564860864351864',
      image: 'https://muddyrain.oss-cn-beijing.aliyuncs.com/4.png',
      firstCategoryName: '连衣裙',
    }, ];
    secondOption = [{
      _id: '1564860864351864',
      secondCategoryName: '吊带连衣裙',
    }, ];
    private dialogVisible: boolean = false;
    private dialogsrcList: string = '';
    private rules: any = {
      goodsName: [{
        required: true,
        message: '请输入商品名称',
        trigger: 'blur'
      }, ],
      firstCategoryName: [{
        required: true,
        message: '请选择商品分类',
        trigger: 'blur'
      }, ],
      secondCategoryName: [{
        required: true,
        message: '请选择商品分类',
        trigger: 'blur'
      }, ],
      presentPrice: [{
        required: true,
        message: '请输入商品现价',
        trigger: 'blur'
      }, ],
      oriPrice: [{
        required: true,
        message: '请输入商品原价',
        trigger: 'blur'
      }, ],
      amount: [{
        required: true,
        message: '请输入商品库存',
        trigger: 'blur'
      }, ],
      goodsDetail: [{
        required: true,
        message: '请上传商品图片',
        trigger: 'blur'
      }]
    }
    async submitForm(formName: any) {
      (this.$refs[formName] as Form).validate(async (valid) => {
        if (valid) {
          const res = await this.$http.post('girl', this.createForm);
          this.$message.success(res.data.success);
          this.$router.push('/clothing/girl');
        } else {
          console.log('error submit!!');
          return false;
        }
      });
    }
    async changeCategory() {
      const first = await this.$http.get('/girl/first');
      this.firstOption = first.data.data;
      const second = await this.$http.get('/girl/second');
      this.secondOption = second.data.data;
    }
    handleRemove(file: any, fileList: any) {
      let url: any = [];
      for (const element of fileList) {
        url.push(element.response[0].src);
      }
      (this.createForm as any).goodsDetail = url;
    }
    handlePictureCardPreview(file: any) {
      this.dialogVisible = true;
      this.dialogsrcList = file.response[0].src;
    }
    handleAvatarSuccess(res: [], file: object, fileList: []) {
      fileList.map((e: Object) => {
        (this.createForm as any).goodsDetail.push((e as any).response[0].src);
      })
    }
    beforeAvatarUpload(file: object) {
      (this.createForm as any).goodsDetail = [];
    }
    async findId() {
      const res = await this.$http.get(`/girl/${this.id}`);
      this.createForm = res.data;
      let imgs: [] = [];
      res.data.goodsDetail.map((e: any) => {
        (imgs as any).push(e[0]);
      });
      (this.srcList as any) = imgs;
       this.firstCategoryName = res.data.firstCategoryName.firstCategoryName;
      this.secondCategoryName = res.data.secondCategoryName.secondCategoryName;
    }
    async editForm(formName: any) {
      (this.$refs[formName] as Form).validate(async (valid) => {
        if (valid) {
          const res = await this.$http.put(`girl/${this.id}`, this.createForm);
          this.$message.success(res.data.success);
          this.$router.push('/clothing/girl');
        } else {
          console.log('error submit!!');
          return false;
        }
      });
    }
    cancel() {
      this.$router.push('/clothing/girl');
    }
    created() {
      this.purview = (localStorage.getItem("purview") as any);
      if (this.purview == 0) {
        this.$message.info("您不是管理员请勿乱动")
        this.$router.push('/clothing/girl');
        return
      }
      
      if (this.id) {
        this.findId();
      }
    }
    mounted(){
      this.changeCategory();
    }
  };
</script>

<style scoped lang="scss">
  .thumbnail {
    width: 144px;
    height: 176px;
    padding: 6px;
    border: 1px solid rgb(223, 219, 219);
  }
</style>