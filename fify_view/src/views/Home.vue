<template>
  <div class="container">
    <router-view/>
    <div id="textInfo" class="section section-basic">
      <center>
      TEXT_AREA
      <p>second line</p>
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
    <button type='button' class="btn btn-success">기능 1</button>
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
      message: ""
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
      console.log("1번째 네모", this.recX1, this.recY1, this.recW1, this.recH1)
      console.log("2번째 네모", this.recX2, this.recY2, this.recW2, this.recH2)
      console.log("3번째 네모", this.recX3, this.recY3, this.recW3, this.recH3)


      context.beginPath();
      context.linewidth = "5"
      context.strokeStyle = "red"
      context.rect(this.recX1, this.recY1, this.recW1, this.recH1)
      context.rect(this.recX2, this.recY2, this.recW2, this.recH2)
      context.rect(this.recX3, this.recY3, this.recW3, this.recH3)
      // context.rect(180, 50, 80, 70)
      context.stroke();
    },

    // 클라우드로 인덱스 전송
    async fifyAxios() {
      // let index = ''
      // axios.get(`http://18.142.131.188/nutrition/${this.index}/`).then((response)=>{
      axios.get(`http://18.142.131.188/nutrition/5`).then((response)=>{
      console.log(response.data, '111111');
      })
    }
  },

  // MQTT통신
  mqtt: {
    'common3': function(value, topic) {
      let result = JSON.parse(value)
      console.log('index : ', result.index)
      console.log('index : ', result.index.first)
      console.log('index : ', result.index.second)
      
      console.log('exist', result.exist)
      console.log('detact', result.detact)
      console.log('coord', result.coord)
      console.log('center', result.center)
      console.log('product_name', result.product_name)
      console.log(result, topic)

      
      // 변수 - if index is not NULL
      if(result.index.first != null && result.index.second != null && result.index.third != null) {
        console.log('if 1')
        let index = result.index

        let recX1 = result.coord.first[0]
        let recY1 = result.coord.first[1]
        let recW1 = result.coord.first[2]
        let recH1 = result.coord.first[3]
        
        let recX2 = result.coord.second[0]
        let recY2 = result.coord.second[1]
        let recW2 = result.coord.second[2]
        let recH2 = result.coord.second[3]
        
        let recX3 = result.coord.third[0]
        let recY3 = result.coord.third[1]
        let recW3 = result.coord.third[2]
        let recH3 = result.coord.third[3]

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

      } else if(result.index.first != null && result.index.second != null) {
        console.log('if 2')
        let index1 = result.index.first
        let index2 = result.index.second

        let recX1 = result.coord.first[0]
        let recY1 = result.coord.first[1]
        let recW1 = result.coord.first[2]
        let recH1 = result.coord.first[3]
        
        let recX2 = result.coord.second[0]
        let recY2 = result.coord.second[1]
        let recW2 = result.coord.second[2]
        let recH2 = result.coord.second[3]
        
        let recX3 = ''
        let recY3 = ''
        let recW3 = ''
        let recH3 = ''

        this.index[0] = index1
        this.index[1] = index2
        this.index[2] = ''

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

      } else if(result.index.first != null) {
        console.log('if 3')
        console.log(result.coord.first[0])

        let index1 = result.index.first

        let recX1 = result.coord.first[0]
        let recY1 = result.coord.first[1]
        let recW1 = result.coord.first[2]
        let recH1 = result.coord.first[3]
        
        let recX2 = ''
        let recY2 = ''
        let recW2 = ''
        let recH2 = ''
        
        let recX3 = ''
        let recY3 = ''
        let recW3 = ''
        let recH3 = ''

        this.index1 = index1
        this.index2 = ''
        this.index3 = ''

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
      } else {
        console.log('else')
        // console.log(result.index.first, result.index.second, result.index.third)
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

#inputProduct {
  margin: 0 auto;
}
</style>
