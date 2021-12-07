<template>
  <v-app>


    <!-- 내용 영역에 라우터 페이지 렌더링 -->
    <v-main>
      <v-slide-x-transition mode="out-in">
        <router-view></router-view>
      </v-slide-x-transition>
    </v-main>

    <!-- 푸터 테마를 secondary로 설정 -->
    <!-- <v-footer color="secondary" fixed dark> -->
      <!-- <div class="mx-auto">created by iot class</div> -->
    <!-- </v-footer> -->
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

