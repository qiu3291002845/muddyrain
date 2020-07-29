<template>
  <div>
    <h5 class="mb-3">新建轮播图</h5>
    <el-form ref="form" label-width="80px">
      <el-form-item label="缩略图">
        <el-upload name="imageUrl" :action="$http.defaults.baseURL + '/uploadManyOSS'" list-type="picture-card"
          :on-preview="handlePictureCardPreview" :limit="1" :on-remove="handleRemove" :on-success="handleSuccess">
          <i class="el-icon-plus"></i>
        </el-upload>
        <el-dialog :visible.sync="dialogImgUrlVisible">
          <img width="100%" :src="dialogImageUrl" alt="">
        </el-dialog>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click="submitForm">立即创建</el-button>
        <el-button @click="$router.push('/home/slide')">取消</el-button>
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
  @Component({
    components: {},
    filters: {
      date(e: string) {
        return e.slice(0, 10);
      }
    }
  })
  export default class EditSlide extends Vue {
    private dialogImageUrl: string = "";
    private dialogImgUrlVisible: boolean = false;
    // 取消上传
    handleRemove(file: any, fileList: any) {
      this.dialogImageUrl = "";
    }
    // 上传成功
    handleSuccess(res: [{}]) {
      let img: string = "";
      img = (res[0] as any).src;
      this.dialogImageUrl = img;
    }
    handlePictureCardPreview(file: any) {
      this.dialogImgUrlVisible = true;
      this.dialogImageUrl = file.response[0].src;
    }
    async submitForm() {
      const res = await this.$http.post('slide', {
        imgUrl: this.dialogImageUrl
      });
      if (res.data.success) {
        this.$message.success(res.data.success);
        this.$router.push('/home/slide')
      }
    }
    // 管理权限
    private purview: number = 0;
    created() {
      this.purview = (localStorage.getItem("purview") as any);
      if (this.purview == 0) {
        this.$message.info("您不是管理员请勿乱动")
        this.$router.push('/home/slide');
        return
      }
    }
  };
</script>

<style scoped>

</style>