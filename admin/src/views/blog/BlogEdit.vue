<template>
  <div>
    <h5 class="mb-3">{{id?'编辑':'新建'}}博客</h5>
    <el-form :model="blogForm" :rules="blogRule" ref="ruleForm" label-width="80px">
      <!-- 新建 -->
      <div v-if="!id">
        <el-form-item label="标题" prop="title">
          <el-input v-model="blogForm.title"></el-input>
        </el-form-item>
        <el-form-item label="作者">
          <el-input v-model="blogAuthor" disabled></el-input>
        </el-form-item>
        <el-form-item label="所属分类" prop="catgory">
          <el-select v-model="blogForm.catgory" placeholder="请选择" @visible-change="fetchCat()">
            <el-option v-for="item in options" :key="item._id" :label="item.name" :value="item._id"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="缩略图">
          <el-upload class="avatar-uploader" :action="$http.defaults.baseURL + '/uploadOSS'" name="imageUrl"
            :show-file-list="false" :before-upload="beforeAvatarUpload" :on-success="uploadSuccess">
            <img v-if="blogForm.imageUrl" :src="blogForm.imageUrl" class="avatar img-thumbnail" />
            <i v-else style="border: 1px dashed #d9d9d9" class="el-icon-plus avatar-uploader-icon"></i>
          </el-upload>
        </el-form-item>
        <el-form-item label="内容" prop="content">
          <editor v-model="blogForm.content" api-key="no-api-key" :init="editorInit" />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="onSubmit('ruleForm')">立即创建</el-button>
          <el-tooltip content="点击返回列表" placement="top" effect="light">
            <!-- content to trigger tooltip here -->
            <el-button @click="$router.push('/blog');" class="ml-2">取消</el-button>
          </el-tooltip>
        </el-form-item>
      </div>
      <!-- 编辑 -->
      <div v-else>
        <el-form-item label="标题" prop="title">
          <el-input v-model="blogForm.title"></el-input>
        </el-form-item>
        <el-form-item label="作者">
          <el-input v-model="blogForm.author.name" disabled></el-input>
        </el-form-item>
        <el-tooltip class="item" effect="light" content="所属分类不可修改,一旦创建就不可以修改" placement="top">
          <el-form-item label="所属分类" prop="catgory">
            <el-input v-model="blogForm.catgory.name" disabled></el-input>
          </el-form-item>
        </el-tooltip>
        <el-form-item label="缩略图">
          <el-upload class="avatar-uploader" :action="$http.defaults.baseURL + '/uploadOSS'" name="imageUrl"
            :show-file-list="false" :before-upload="beforeAvatarUpload" :on-success="uploadSuccess">
            <img v-if="blogForm.imageUrl" :src="blogForm.imageUrl" class="avatar img-thumbnail" />
            <i v-else style="border: 1px dashed #d9d9d9" class="el-icon-plus avatar-uploader-icon"></i>
          </el-upload>
        </el-form-item>
        <el-form-item label="内容" prop="content">
          <editor v-model="blogForm.content" api-key="no-api-key" :init="editorInit" />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="onSubmitEdit">立即修改</el-button>
          <el-tooltip content="点击返回列表" placement="top" effect="light">
            <!-- content to trigger tooltip here -->
            <el-button @click="$router.push('/blog');" class="ml-2">取消</el-button>
          </el-tooltip>
        </el-form-item>
      </div>
    </el-form>
  </div>
</template>

<script lang="ts">
  import {
    Vue,
    Component,
    Prop
  } from "vue-property-decorator";
  import Editor from "@tinymce/tinymce-vue";
  import {
    Form
  } from "element-ui";
  @Component({
    components: {
      editor: Editor
    }
  })
  export default class BlogEdit extends Vue {
    @Prop(String) id: string | undefined;
    private editorOption: any = {};
    private blogForm: any = {
      author: {},
      catgory: {}
    };
    private blogAuthor = "";
    private options = [{
      _id: "",
      name: ""
    }];
    private blogRule = {
      title: [{
        required: true,
        message: "请输入标题",
        trigger: "blur"
      }],
      catgory: [{
        required: true,
        message: "请输入分类",
        trigger: "change"
      }]
    };
    editorInit = {
      selector: "textarea",
      language: "zh_CN",
      height: "270",
      images_upload_url: "http://127.0.0.1:3000/admin/api/uploadBlog",
      // images_upload_base_path: "/demo",
      plugins: [
        "advlist autolink lists link charmap print preview anchor",
        "searchreplace visualblocks code fullscreen",
        "insertdatetime media table paste code help wordcount image"
      ],
      toolbar: "undo redo | formatselect | bold italic backcolor preview  | \
                alignleft aligncenter alignright alignjustify | \
                bullist numlist outdent indent | removeformat | help image | fullscreen "
    };
    private value = "";
    private dialogVisible = false;
    async onSubmit(formName: string) {
      (this.$refs[formName] as Form).validate(async valid => {
        if (valid) {
          const res = await this.$http.post("/blog/create", this.blogForm);
          this.$message.success(res.data.success);
          this.$router.push("/blog");
          this.blogForm = {};
        } else {
          this.$notify.info({
            title: "通知",
            message: "请输入您的要创建的博客"
          });
          return false;
        }
      });
    }
    handlePictureCardPreview() {
      this.dialogVisible = true;
    }
    async onSubmitEdit() {
      const res = await this.$http.put(`/blog/${this.id}`, this.blogForm);
      this.$message.success(res.data.success);
      this.$router.push("/blog");
    }
    async fetchCat() {
      const res = await this.$http.get("/blog/cat");
      this.options = res.data;
    }
    async editFetch() {
      const res = await this.$http.get(`/blog/${this.id}`);
      this.blogForm = res.data[0];
    }
    beforeAvatarUpload(file: any) {
      const isJPG = file.type === "image/jpeg" || "image/png";
      const isLt5M = file.size / 1024 / 1024 < 5;

      if (!isJPG) {
        this.$message.error("上传头像图片只能是 JPG 格式!");
      }
      if (!isLt5M) {
        this.$message.error("上传头像图片大小不能超过5MB!");
      }
      return isJPG && isLt5M;
    }
    uploadSuccess(res: any) {
      if (res[0].uploaded == true) {
        this.$set(
          this.blogForm,
          "imageUrl",
          "https://muddyrain.oss-cn-beijing.aliyuncs.com/" + res[0].path
        );
        this.$message.success(res[0].message);
      }
    }
    created() {
      this.blogForm.author = this.$store.state.userFrom._id;
      this.blogAuthor = this.$store.state.userFrom.name;
      if (this.id) {
        this.editFetch();
      }
    }
    mounted() {}
  }
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
    border-color: #409eff;
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
    width: 178px;
    height: 178px;
    display: block;
  }
</style>