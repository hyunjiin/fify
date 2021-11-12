<template>
  <div id="app">
    <Camera></Camera>  
  </div>
</template>

<script>
import Camera from './components/Camera.vue';

export default {
  name: 'app',
  components: {
    Camera,
  },  
}
</script>

<style lang="scss">
body {
  font-family: 'Avenir', Arial, Helvetica, sans-serif;
  margin: 0;
  padding: 0;
  background-color: #f3f3f3;
}
</style>
