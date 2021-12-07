<template>
  <div class="container">
    <router-view/>
    <div id="textInfo" class="section section-basic">
      <center>
      <!-- {{result.product_name}} -->aa
      <p>second line</p>
      <p>width : {{canvasW}}, height : {{canvasH}}</p>
      </center>
    </div>
    <center>
      <input id="inputProduct" type='text' v-model="message" placeholder="제품을 입력하세요">
      <button @click="onProductPub">전송</button>
    </center>
    
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

    <p></p>

    <!-- 버튼 누르면 팝엄창 뜨면서 검색 할 수 있게 함 -->
    <button type='button' class="btn btn-success"
            @click="drawRectangle">기능 1</button>
    <button type='button' class="btn btn-success">기능 2</button>

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
      message: "",
      canvasW: "",
      canvasH: ""
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

    // 사용자에게 입력받은 메시지 전송
    onProductPub() {
      console.log('사용자 입력 메시지 : ',this.message)
      this.$mqtt.publish('fify/product', this.message)
    },

    // 1초에 6번 사진 전송
    captureVideo() {
      this.timerId = setInterval(()=>{
        this.img = this.$refs.webcam.capture()
        let temp = this.img.slice(23)
        let jpg = this.base64ToArray(temp)
        this.$mqtt.publish('fify/image', jpg)
        console.log('이미지 사이즈 : ', this.img.length)
        this.drawRectangle()

      }, 160);
      console.log('Start Publish')
    },

    // 사진 전송 멈추기
    stopCaptureVideo() {
      clearInterval(this.timerId)
      console.log('Stop Publish')
    },

    // 사진 전송을 위해 데이터변경
    base64ToArray(base64) {
      var binary_string = window.atob(base64)
      var len = binary_string.length
      var bytes = new Uint8Array(len)            
      for (var i = 0; i < len; i++) {
          bytes[i] = binary_string.charCodeAt(i)
      }
      return bytes
    },

    // 네모 그리기
    drawRectangle() {

      var canvas1 = document.getElementById("fifyCanvas")
      var context = canvas1.getContext("2d")
      
      canvas1.width = window.innerWidth
      canvas1.height = window.innerHeight

      this.canvasW = canvas1.width
      this.canvasH = canvas1.height

      
      console.log("1번째 네모", this.recX1, this.recY1, this.recW1, this.recH1)
      console.log("2번째 네모", this.recX2, this.recY2, this.recW2, this.recH2)
      console.log("3번째 네모", this.recX3, this.recY3, this.recW3, this.recH3)

      context.clearRect(0, 0, 300, 150)


      context.beginPath();
      context.linewidth = "5"
      context.strokeStyle = "red"

      context.beginPath();

      context.rect(this.recX1, this.recY1, this.recW1, this.recH1)
      context.rect(this.recX2, this.recY2, this.recW2, this.recH2)
      context.rect(this.recX3, this.recY3, this.recW3, this.recH3)
      // context.rect(0, 0, 300, 150)
      context.stroke();

      // this.findIndex(this.index)


    },

    // 클라우드로 인덱스 전송
    async fifyAxios() {
      // let index = ''
      axios.get(`http://18.142.131.188/nutrition/${this.index}/`).then((response)=>{
      // axios.get(`http://18.142.131.188/nutrition/5`).then((response)=>{
      console.log(response.data, '111111');
      })
    },

    async findIndex(index) {
      // let index = ''
      axios.get(`http://18.142.131.188/nutrition/${index}/`).then((response)=>{
      // axios.get(`http://18.142.131.188/nutrition/5`).then((response)=>{
      console.log(response.data, '111111');
      })
    },
  },

  // MQTT통신
  mqtt: {
    'common3': function(value, topic) {
      let result = JSON.parse(value)
      console.log('index : ', result[0].index)
      this.index = result[0].index
      // this.findIndex(this.index)

      // console.log('index : ', result[1].index)
      // console.log('index : ', result[2].index)
      // console.log('index : ', result[3].index)
      // console.log('index : ', result[4].index)
      
      console.log('exist', result[0].exist)
      console.log('detect', result[0].detact)
      console.log('product_name', result[0].product_name)
      console.log('test : ', result[0].x)
      console.log(result, topic)

      
      // 변수 - if index is not NULL
      if(result[4] != null){
        console.log('if - 5')

        let index = result[0].index

        let recX1 = result[0].x
        let recY1 = result[0].y
        let recW1 = result[0].w
        let recH1 = result[0].h
        
        let recX2 = result[1].x
        let recY2 = result[1].y
        let recW2 = result[1].w
        let recH2 = result[1].h
        
        let recX3 = result[2].x
        let recY3 = result[2].y
        let recW3 = result[2].w
        let recH3 = result[2].h

        let recX4 = result[3].x
        let recY4 = result[3].y
        let recW4 = result[3].w
        let recH4 = result[3].h

        let recX5 = result[4].x
        let recY5 = result[4].y
        let recW5 = result[4].w
        let recH5 = result[4].h

        this.index = index

        this.recX1 = recX1
        this.recY1 = recY1
        this.recW1 = recW1
        this.recH1 = recH1
        
        this.recX2 = recX2
        this.recY2 = recY2
        this.recW2 = recW2
        this.recH2 = recH2
        
        this.recX3 = recX3
        this.recY3 = recY3
        this.recW3 = recW3
        this.recH3 = recH3

        this.recX4 = recX4
        this.recY4 = recY4
        this.recW4 = recW4
        this.recH4 = recH4

        this.recX5 = recX5
        this.recY5 = recY5
        this.recW5 = recW5
        this.recH5 = recH5

      } else if(result[3] != null){
        console.log('if - 4')

        let index = result[0].index

        let recX1 = result[0].x
        let recY1 = result[0].y
        let recW1 = result[0].w
        let recH1 = result[0].h
        
        let recX2 = result[1].x
        let recY2 = result[1].y
        let recW2 = result[1].w
        let recH2 = result[1].h
        
        let recX3 = result[2].x
        let recY3 = result[2].y
        let recW3 = result[2].w
        let recH3 = result[2].h

        let recX4 = result[3].x
        let recY4 = result[3].y
        let recW4 = result[3].w
        let recH4 = result[3].h

        this.index = index

        this.recX1 = recX1
        this.recY1 = recY1
        this.recW1 = recW1
        this.recH1 = recH1
        
        this.recX2 = recX2
        this.recY2 = recY2
        this.recW2 = recW2
        this.recH2 = recH2
        
        this.recX3 = recX3
        this.recY3 = recY3
        this.recW3 = recW3
        this.recH3 = recH3

        this.recX4 = recX4
        this.recY4 = recY4
        this.recW4 = recW4
        this.recH4 = recH4

      } else if(result[2] != null) {
        console.log('if - 3')

        let index = result[0].index

        let recX1 = result[0].x
        let recY1 = result[0].y
        let recW1 = result[0].w
        let recH1 = result[0].h
        
        let recX2 = result[1].x
        let recY2 = result[1].y
        let recW2 = result[1].w
        let recH2 = result[1].h
        
        let recX3 = result[2].x
        let recY3 = result[2].y
        let recW3 = result[2].w
        let recH3 = result[2].h

        this.index = index

        this.recX1 = recX1
        this.recY1 = recY1
        this.recW1 = recW1
        this.recH1 = recH1
        
        this.recX2 = recX2
        this.recY2 = recY2
        this.recW2 = recW2
        this.recH2 = recH2
        
        this.recX3 = recX3
        this.recY3 = recY3
        this.recW3 = recW3
        this.recH3 = recH3

      } else if(result[1] != null) {
        console.log('if - 2')

        let index = result[0].index

        let recX1 = result[0].x
        let recY1 = result[0].y
        let recW1 = result[0].w
        let recH1 = result[0].h
        
        let recX2 = result[1].x
        let recY2 = result[1].y
        let recW2 = result[1].w
        let recH2 = result[1].h

        this.index = index

        this.recX1 = recX1
        this.recY1 = recY1
        this.recW1 = recW1
        this.recH1 = recH1
        
        this.recX2 = recX2
        this.recY2 = recY2
        this.recW2 = recW2
        this.recH2 = recH2
        

      } else if(result[0] != null) {
        console.log('if - 1')

        let index = result[0].index

        let recX1 = result[0].x
        let recY1 = result[0].y
        let recW1 = result[0].w
        let recH1 = result[0].h
      
        this.index = index

        this.recX1 = recX1
        this.recY1 = recY1
        this.recW1 = recW1
        this.recH1 = recH1

      } else {
        console.log('else')
      }

      
    }
  },
  mounted() {
    // 구독신청
    this.$mqtt.subscribe('common3') 
  },
  
};
</script>

<style scoped>
.containet {
  margin-top: auto;
}

.section-basic {
  border-radius: 8px 8px 8px 8px / 8px 8px 8px 8px;
  box-shadow: 0 4px 20px 0 rgb(0 0 0 / 14%), 0 7px 12px -5px;
  background-color: darkgray;
  
}

#fifyWebCam {
  position: relative;
}

#fifyCamera {
  position: relative;
}

#fifyCanvas {
  position: absolute;
  width: 100%;
  height: 100%;
  opacity: 3;
  transition: .9s ease;
  background-color: transparent;
  top: 0px;
  bottom: 0;
  left: 0px;
  right: 0;
}

#inputProduct {
  margin: 0 auto;
}
</style>
