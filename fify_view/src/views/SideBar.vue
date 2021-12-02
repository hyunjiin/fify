<template>
  <v-app>
    <!-- 툴바테마를 primary(파랑색)로 설정 -->
    <v-app-bar app color="primary" dark>
      <v-app-bar-nav-icon @click="drawer = !drawer"></v-app-bar-nav-icon>
      <v-toolbar-title>IoT Service</v-toolbar-title>
      <!-- 배치하고 남은 공간을 차지 -->
      <v-spacer></v-spacer>
      <v-btn icon @click="$router.push({name:'Home'})">
        <v-icon>mdi-home</v-icon>
      </v-btn>
      <v-btn icon v-if="isLogin" @click="logout">
        <v-icon>mdi-logout</v-icon>
      </v-btn>
      <v-btn icon v-else :to="{name:'Login'}">
        <v-icon>mdi-login</v-icon>
      </v-btn>
      <!-- 버튼 모양이 아니라 icon만 표시하겠다 -->
      <v-btn icon>
        <!-- v-icon이 아이콘의 이름 -->
        <v-icon>mdi-dots-vertical</v-icon>
      </v-btn>
    </v-app-bar>

    <!-- 왼쪽 네비게이션 바 -->
    <v-navigation-drawer absolute v-model="drawer" temporary>
      <v-list-item two-line>
        
        <v-list-item-avatar>
          <v-img src="https://randomuser.me/api/portraits/men/85.jpg"></v-img>
        </v-list-item-avatar>

        <v-list-item-content>

          <v-list-item-title class="text-h6">
            {{isLogin ? user.username : 'IoT 서비스'}}
          </v-list-item-title>

          <v-list-item-subtitle>
            {{isLogin ? user.email : '로그인을 해주세요'}}
          </v-list-item-subtitle>

        </v-list-item-content>
      </v-list-item>
      <v-divider></v-divider>
      <v-list dense nav>
        <v-list-item v-for="page in pages" :key="page.name"
            :to="{name: page.name}" exact>

          <v-list-item-icon>
            <v-icon>{{ page.icon }}</v-icon>
          </v-list-item-icon>

          <v-list-item-content>
            <v-list-item-title>{{ page.title }}</v-list-item-title>
          </v-list-item-content>

        </v-list-item>
      </v-list>
    </v-navigation-drawer>
    
    <!-- 내용 영역에 라우터 페이지 렌더링 -->
    <v-main>
      <v-slide-x-transition mode="out-in">
        <router-view></router-view>
      </v-slide-x-transition>
    </v-main>
    
    <!-- 푸터 테마를 secondary로 설정 -->
    <v-footer color="secondary" fixed dark>
      <div class="mx-auto">created by iot class</div>
    </v-footer>
  </v-app>
</template>

<script>
import { mapState, mapGetters, mapMutations, mapActions } from 'vuex'

export default {
  name: 'App',

  data: () => ({
    
    drawer: false,
    pages: [
      
      {title: 'Home', name: 'Home', icon: 'mdi-home'},
      {title: 'Mqtt 모니터링', name: 'Mqtt', icon: 'mdi-access-point-network'},
      {title: '보안 카메라', name: 'SecureCamera', icon: 'mdi-video'},
      {title: '탐사 차량', name: 'ExplorationCar', icon: 'mdi-car'},
      {title: 'About', name: 'About', icon: 'mdi-information'}
    ]
  }),

  computed: {
    ...mapState(['user']),
    ...mapGetters(['isLogin'])
  },
   methods: {
    ...mapMutations(['logout', 'restore']),
    ...mapActions(['verify'])
  },
  async mounted() {
    let user = localStorage.getItem('user')
    if(user) {
      user = JSON.parse(user) // JSON 문자열을 객체로 변환
      try {
        await this.verify(user.jwt)
        this.restore(user) // store 복원
      } catch(e) { // 유효하지 않은 경우 401 예외 발생
        console.log(e)
      }
    }
  }, 
};
</script>
