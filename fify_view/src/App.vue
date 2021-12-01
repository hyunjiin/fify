<template>
  <div class="container">
    <router-view/>
    <div id="textInfo">12345687</div>
    <h2>Camera</h2>
    <div id="fifyCamera">
      <web-cam ref="webcam"
              id="fifyWebCam"
              :device-id="deviceId"
              width="100%"
              height="auto"
              @started="onStarted" 
              @stopped="onStopped" 
              @error="onError"
              @cameras="onCameras"
              @camera-change="onCameraChange" />
      <canvas id="fifyCanvas"></canvas>
    </div>


    <button type="button"
            class="btn btn-success"
            @click="captureVideo">captureVideo</button>
    <button type="button"
            class="btn btn-danger"
            @click="stopCaptureVideo">stopCaptureVideo</button>
    <button @click="fifyAxios">123</button>
  </div>
  
</template>

<script>
import { WebCam } from "vue-web-cam";
import { find, head } from "lodash";
import axios from 'axios'

export default {
  name: "App",
  components: {
    WebCam
  },
  props: ['topic'],
  data() {
    return {
      img: null,
      camera: null,
      deviceId: null,
      devices: [],
    };
  },
  computed: {
    device() {
      return find(this.devices, n => n.deviceId == this.deviceId);
    }
  },
  watch: {
    camera: function(id) {
      this.deviceId = id;
    },
    devices: function() {
      // Once we have a list select the first one
      let first = head(this.devices);
      let second = this.devices[1]
      console.log('.',first, second)
      if (first) {
        this.camera = first.deviceId;
        this.deviceId = first.deviceId;
      }
    }
  },
  methods: {
    onCapture() {
      this.img = this.$refs.webcam.capture();
    },
    onStarted(stream) {
      console.log("On Started Event", stream);
    },
    onStopped(stream) {
      console.log("On Stopped Event", stream);
    },
    onStop() {
      this.$refs.webcam.stop();
    },
    onStart() {
      this.$refs.webcam.start();
    },
    onError(error) {
      console.log("On Error Event", error);
    },
    onCameras(cameras) {
      this.devices = cameras;
      console.log("On Cameras Event", cameras);
    },
    onCameraChange(deviceId) {
      this.deviceId = deviceId;
      this.camera = deviceId;
      console.log("On Camera Change Event", deviceId);
    },
    // 1초에 6번
    captureVideo() {
      this.timerId = setInterval(()=>{
        this.img = this.$refs.webcam.capture()
        let temp = this.img.slice(23)
        let jpg = this.base64ToArray(temp)
        this.$mqtt.publish('fify/image', jpg)
        console.log(this.img.length)
        this.drawRectangle()

      }, 160);
      console.log('Start Publish')
    },
    stopCaptureVideo() {
      clearInterval(this.timerId)
      console.log('Stop Publish')
    },
    base64ToArray(base64) {
      var binary_string = window.atob(base64)
      var len = binary_string.length
      var bytes = new Uint8Array(len)            
      for (var i = 0; i < len; i++) {
          bytes[i] = binary_string.charCodeAt(i)
      }
      return bytes
    },
    drawRectangle() {
      let recX = ''
      let recY = ''
      let recWidth = ''
      let recheight = ''
      console.log("111111111111")
      var canvas1 = document.getElementById("fifyCanvas")
      var context = canvas1.getContext("2d")

      context.beginPath();
      context.linewidth = "5"
      context.strokeStyle = "red"
      context.rect(recX, recY, recWidth, recheight)
      context.rect(180, 50, 80, 70)
      context.stroke();
    },
    async fifyAxios() {
      // let index = ''
      // axios.get(`http://18.142.131.188/nutrition/${index}/`).then((Response)=>{
      axios.get(`http://18.142.131.188/nutrition/5`).then((response)=>{
      console.log(response.data, '111111');
      })
    }
  },
  mqtt: {
    'common3': function(value, topic) {
      console.log(value, topic)
    }
  },
  mounted() {
    // 구독신청
    this.$mqtt.subscribe('common3') 
  },
  
};
</script>

<style scoped>
#fifyWebCam {
  position: relative;
}

#fifyCamera {
  position: relative;
}

#fifyCanvas {
  position: absolute;
  height: 100%;
  width: 100%;
  opacity: 3;
  transition: .9s ease;
  background-color: transparent;
  top: 0px;
  bottom: 0;
  left: 0px;
  right: 0;
}
</style>