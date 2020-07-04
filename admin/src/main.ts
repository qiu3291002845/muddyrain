import Vue from 'vue'
import App from './App.vue'
import './plugins/element'
import router from './router'
import 'bootstrap/dist/css/bootstrap.css'
import 'element-ui/lib/theme-chalk/base.css';
// import ECharts from 'vue-echarts' // 在 webpack 环境下指向 components/ECharts.vue
// // 手动引入 ECharts 各模块来减小打包体积
// import 'echarts/lib/chart/bar'
// import 'echarts/lib/component/tooltip'
// // 需要安装依赖：npm install --save echarts-gl，并添加如下引用
// import 'echarts-gl'
// // 注册组件后即可使用
// Vue.component('v-chart', ECharts)
import echarts from 'echarts'
Vue.prototype.$echarts = echarts
import axios from 'axios'
import store from './store'
Vue.config.productionTip = false



Vue.prototype.$http = axios.create({
  baseURL: "http://127.0.0.1:3000/admin/api"
})
new Vue({
  router,
  store,
  render: h => h(App)
}).$mount('#app')
