<template>
  <div>
    <el-carousel :interval="4000" type="card" height="360px">
      <el-carousel-item v-for="(item,index) in slideData" :key="index">
        <el-image :src="item" style="height:360px;" fit="cover">
        </el-image>
      </el-carousel-item>
    </el-carousel>
  </div>
</template>
<script lang="ts">
  // @ is an alias to /src
  import {
    Component,
    Prop,
    Vue
  } from "vue-property-decorator";

  @Component
  export default class HelloWorld extends Vue {
    private slideData = ['1', '2', '3', '4', '5', '6'];
    async fetchSlide() {
      const res = await this.$http.get('slide');
      let img = ['1', '2', '3', '4', '5', '6'];
      res.data.map((e: any, index: number) => {
        img[index] = e.imgUrl[0][0];
      });
      (this.slideData as any) = img;
    }
    created() {
      this.fetchSlide();
    }
  }
</script>
<style lang="scss">
  .el-carousel__item h3 {
    color: #475669;
    font-size: 14px;
    opacity: 0.75;
    line-height: 200px;
    margin: 0;
  }

  .el-carousel__item:nth-child(2n) {
    background-color: #99a9bf;
  }

  .el-carousel__item:nth-child(2n + 1) {
    background-color: #d3dce6;
  }
</style>