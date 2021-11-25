<template>
  <div class="container">
    <router-view/>
        <h2>Camera</h2>
          <web-cam ref="webcam"
                   :device-id="deviceId"
                   width="100%"
                   height="auto"
                   @started="onStarted" 
                   @stopped="onStopped" 
                   @error="onError"
                   @cameras="onCameras"
                   @camera-change="onCameraChange" />
            <button type="button"
                    class="btn btn-success"
                    @click="captureVideo">captureVideo</button>
            <button type="button"
                    class="btn btn-danger"
                    @click="stopCaptureVideo">stopCaptureVideo</button>
    
  </div>

  
</template>

<script>
import { WebCam } from "vue-web-cam";
import { find, head } from "lodash";

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
      console.log('.',this.devices)
      console.log('.',first, second)
      if (second) {
        this.camera = second.deviceId;
        this.deviceId = second.deviceId;
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
  },
  
};
</script>

<style scoped>

</style>