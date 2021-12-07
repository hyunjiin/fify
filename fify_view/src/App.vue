<template>
  <v-app>

    <v-main>
      <v-slide-x-transition mode="out-in">
        <router-view></router-view>
      </v-slide-x-transition>
    </v-main>

  </v-app>
</template>


<script>

export default {
  name: 'App',

  data: () => ({

    drawer: false,
    pages: [

      {title: 'Home', name: 'Home', icon: 'mdi-home'},
      {title: 'About', name: 'About', icon: 'mdi-information'}
    ]
  }),
};
</script>

