<template>
  <div>
    <h5>女装管理</h5>
    <el-table :data="tableData" stripe>
      <el-table-column prop="_id" label="序列号" width="240" fit="true">
      </el-table-column>
      <el-table-column label="分类图标" width="120">
        <template slot-scope="scope">
          <img :src="scope.row.category.image" alt="" width="50" height="50">
        </template>
      </el-table-column>
      <el-table-column prop="category.firstCategoryName" label="商品类别" width="120">
      </el-table-column>
      <el-table-column label="商品名称" width="220">
        <template slot-scope="scope">
          <el-tooltip :content="scope.row.goodsName" placement="top" effect="light">
            <span>{{scope.row.goodsName | ellipsis}}</span>
          </el-tooltip>
        </template>
      </el-table-column>
      <el-table-column label="商品缩略图" width="160">
        <template slot-scope="scope">
          <div class="thumbnail">
            <el-image style="width: 65px; height: 80px" :src="scope.row.goodsDetail[0]"
              :preview-src-list="scope.row.goodsDetail">
            </el-image>
          </div>
        </template>

      </el-table-column>
      <el-table-column label="商品价格" width="180">
        <template slot-scope="scope">
          <span style="font-size:20px;color:orange;">￥{{scope.row.presentPrice}}</span>
        </template>
      </el-table-column>
      <el-table-column label="商品原价" width="180">
        <template slot-scope="scope">
          <span class="oriPrice">￥{{scope.row.oriPrice}}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作">
        <template slot-scope="scope">
          <el-button size="mini" @click="editForm(scope.row._id)">编辑</el-button>
          <el-button size="mini" type="danger" @click="deleteGirl(scope.row._id)">删除</el-button>
        </template>
      </el-table-column>
      <el-table-column label="搜索">
        <template slot="header" slot-scope="scope">
          <el-tooltip content="请输入您要搜索的商品" placement="top" effect="light">
            <el-input v-model="searchKeyword" placeholder="输入关键字搜索" clearable>
              <i slot="prefix" class="el-input__icon el-icon-search"></i>
            </el-input>
          </el-tooltip>
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
      ellipsis(value: string) {
        return value.slice(0, 10) + "...";
      }
    }
  })
  export default class Girl extends Vue {
    private srcList: Array < String >= [
      'https://muddyrain.oss-cn-beijing.aliyuncs.com/7.jpg',
      'https://muddyrain.oss-cn-beijing.aliyuncs.com/200622_2cb6jdfi3aj3b8gcedd978ie40ej3_3888x5832.jpg_468x468.jpg'
    ];
    private tableData = [{
      "amount": 10000,
      "_id": "001",
      "goodsSerialNumber": "6901435325888",
      "oriPrice": 122.29,
      "presentPrice": 72.70,
      "shopId": "402880e860166f3c0160167897d60002",
      "goodsName": "收腰显瘦气质初恋仙女裙温柔风超仙方领雪纺连衣裙女喇叭袖长裙子",
      "goodsDetail": [
        'https://muddyrain.oss-cn-beijing.aliyuncs.com/7.jpg',
        'https://muddyrain.oss-cn-beijing.aliyuncs.com/200622_2cb6jdfi3aj3b8gcedd978ie40ej3_3888x5832.jpg_468x468.jpg'
      ],
      "category": {
        _id: '1564860864351864',
        image: 'https://muddyrain.oss-cn-beijing.aliyuncs.com/4.png',
        firstCategoryName: '连衣裙',
        secondCategoryName: '长款连衣裙'
      }
    }];
    // 搜索关键字
    private searchKeyword = "";
    async findTableData() {
      const res = await this.$http.get('girl');
      this.tableData = res.data;

      res.data.map((e: any, index: number) => {
        let imgList: any = [];
        e.goodsDetail.map((img: any) => {
          imgList.push(img[0]);
        });
        (this.tableData[index].goodsDetail as any) = imgList;
      })
    }
    editForm(id: string) {
      this.$router.push({
        name: 'GirlEdit',
        params: {
          id: id
        }
      })
    }
    async deleteGirl(id: string) {
      this.$confirm('此操作将永久删除该文件, 是否继续?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(async () => {
        await this.$http.delete(`girl/${id}`);
        this.$message({
          type: 'success',
          message: '删除成功!'
        });
        this.findTableData();
      }).catch(() => {
        this.$message({
          type: 'info',
          message: '已取消删除'
        });
      });
    }
    created() {
      this.findTableData();
    }
  }
</script>

<style scoped lang="scss">
  .oriPrice {
    text-decoration: line-through;
    font-size: 18px;
    color: #666;
  }

  .thumbnail {
    width: 72px;
    height: 88px;
    padding: 3px;
    border: 1px solid rgb(223, 219, 219);
  }
</style>