import Vue from 'vue'
import VueRouter, { RouteConfig } from 'vue-router'
import store from '@/store'

Vue.use(VueRouter)

const routes: RouteConfig[] = [
  {
    path: '/',
    component: () => import('../views/Main.vue'),
    children: [
      {
        path: '',
        name: 'home',
        component: () => import('../views/Home.vue'),
      },
      {
        path: '/user',
        name: 'user',
        component: () => import('../views/user/User.vue')
      },
      {
        path: '/admin/notebook',
        name: 'notebook',
        component: () => import('../views/notebook/NoteBook.vue'),
        props: true,
      },
      {
        path: '/admin/phone',
        name: 'phone',
        component: () => import('../views/phone/Phone.vue'),
        props: true,
      },
      {
        path: '/notebookbrand',
        name: 'notebookbrand',
        component: () => import('../views/notebook/NoteBookBrand.vue'),
        props: true
      },
      {
        path: '/phonebrand',
        name: 'phonebrand',
        component: () => import('../views/phone/PhoneBrand.vue'),
        props: true
      },
      {
        path: '/blog',
        name: 'Blog',
        component: () => import('../views/blog/Blog.vue')
      },
      {
        path: '/blog/edit',
        name: "Blog-create",
        component: () => import('../views/blog/BlogEdit.vue'),
        props: true
      },
      {
        path: '/blog/edit/:id',
        name: "Blog-edit",
        component: () => import('../views/blog/BlogEdit.vue'),
        props: true
      },
      {
        path: '/blog/category',
        name: "Blog-category",
        component: () => import('../views/blog/BlogCategory.vue'),
        props: true
      },
      {
        path: '/computerCpu',
        name: 'Computer-cpu',
        component: () => import('../views/handware/ComputerCpu.vue')
      },
      {
        path: '/displayCard',
        name: 'Display-card',
        component: () => import('../views/handware/DisplayCard.vue')
      },
      {
        path: '/phoneCpu',
        name: 'Phone-cpu',
        component: () => import('../views/handware/PhoneCpu.vue')
      }, {
        path: '/clothing/girlCategory',
        name: 'GirlCategory',
        component: () => import('../views/clothing/GirlCategory.vue'),
        props: true
      },
      {
        path: '/clothing/girl',
        name: 'Girl',
        component: () => import('../views/clothing/Girl.vue'),
        props: true
      },
      {
        path: '/clothing/girlEdit',
        name: 'GirlEdit',
        component: () => import('../views/clothing/GirlEdit.vue'),
        props: true
      },
      {
        path: '/home/slideEdit',
        name: 'EditSlide',
        component: () => import('../views/home/editSlide.vue'),
        props: true,
      },
      {
        path: '/home/slide',
        name: 'Slide',
        component: () => import('../views/home/Slide.vue'),
        props: true,
      }
    ]
  },
  {
    path: '/login',
    name: 'Login',
    component: () => import('../views/login/login.vue'),
    meta: { isPublic: true },
  },
]

const router = new VueRouter({
  routes,
  // mode: 'history'
})
router.beforeEach((to, from, next) => {
  if (!to.meta.isPublic && !localStorage.token) {
    return next("/login");
  }
  next();
})

export default router
