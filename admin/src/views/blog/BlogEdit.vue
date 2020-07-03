<template>
  <div>
    <h5 class="mb-3">新建博客</h5>
    <el-form :model="blogForm" ref="form" label-width="80px">
      <el-form-item label="标题">
        <el-input v-model="blogForm.title"></el-input>
      </el-form-item>
      <el-form-item label="作者">
        <el-input v-model="blogForm.author" disabled></el-input>
      </el-form-item>
      <el-form-item label="所属分类">
        <el-select v-model="blogForm.catgory" placeholder="请选择">
          <el-option v-for="item in options" :key="item._id" :label="item.name" :value="item._id"></el-option>
        </el-select>
      </el-form-item>
      <el-form-item label="内容">
        <editor v-model="blogForm.content" api-key="no-api-key" :init="editorInit" />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click="onSubmit">立即创建</el-button>
        <el-button>取消</el-button>
      </el-form-item>
    </el-form>
  </div>
</template>

<script lang="ts">
  import {
    Vue,
    Component
  } from "vue-property-decorator";
  import Editor from "@tinymce/tinymce-vue";
  @Component({
    components: {
      editor: Editor
    }
  })
  export default class BlogEdit extends Vue {
    private editorOption: any = {};
    private blogForm: object = {};
    private options = [{
        _id: "1111111111111",
        name: "黄金糕"
      },
      {
        _id: "2222222222222",
        name: "双皮奶"
      },
      {
        _id: "3333333333333",
        name: "蚵仔煎"
      },
      {
        _id: "4444444444444",
        name: "龙须面"
      },
      {
        _id: "5555555555555",
        name: "北京烤鸭"
      }
    ];
    editorInit = {
      selector: "#tinydemo",
      language: "zh_CN",
      height: "500",
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
    onSubmit() {
      console.log(this.blogForm);
    }
    async fetchCat() {
      const res = await this.$http.get("/blog/cat");
      this.options = res.data
    }
    created() {
      this.fetchCat()
    }
    mounted() {}
  }
</script>

<style scoped></style>