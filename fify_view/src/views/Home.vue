<template>
<!-- dd -->
  <div class="container">
    <head>
      <meta http-equiv="X-UA-Compatible" content="IE=edge">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    </head>

    <div class="menu" style="margin-top:20px; float:left;">
      <label for="expand-menu"><div></div></label><input type="checkbox" id="expand-menu" name="expand-menu">
      <ul>
          <li><v-btn icon @click="$router.push({name:'Home'})"></v-btn></li>
          <li><v-btn icon @click="$router.push({path:'about', name:'About'})"></v-btn></li>
      </ul>
    </div>

    <div style="float:left;">
      <center>
        <span id="textInfo" class="" style="box-shadow: inset 0 -10px #3767FF; line-height:21px;">
          <center>
            {{message1}} {{message2}}
            <p>second line</p>
          </center>
        </span>
      </center>
    </div>

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

    <!-- 1번기능, 2번기능, 영양정보 표시 기능 -->
    <div style="margin-bottom:15px;" id="button_box">
        <button style="margin-right:20px;" 
                type='button' class="my_btn"
                @click="showModal = true">검색</button>
        <modal v-if="showModal" @close="showModal = false">
          <center>
            <input id="inputProduct" type='text' v-model="inputProduct" placeholder="제품을 입력하세요">
            <button @click="onProductPub">전송</button>
          </center>
          <button class="modal-default-button"
                    @click="showModal = false">
                    OK
          </button>
        </modal>

        <button type='button' class="my_btn"
                @click="secondFunction">확인</button>
    </div>
    <div style="display: flex; justify-content: center; align-items: center;">
      <button style="margin-bottom:20px; width: 360px"
              type='button' class="my_btn"
              @click="info">성분표</button>
    </div>

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
      inputProduct: "",
      message1: "",
      message2: "",
      showModal: false
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
      console.log('사용자 입력 메시지 : ',this.inputProduct)
      this.$mqtt.publish('fify/product', this.inputProduct)
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

      context.clearRect(0, 0, canvas1.width, canvas1.height)

      context.beginPath();
      context.linewidth = "5"
      context.strokeStyle = "red"
      context.rect(this.recX1, this.recY1, this.recW1, this.recH1)
      context.rect(this.recX2, this.recY2, this.recW2, this.recH2)
      context.rect(this.recX3, this.recY3, this.recW3, this.recH3)
      // context.rect(180, 50, 80, 70)
      context.stroke();

      this.findIndex(this.index)
    },

    // 클라우드로 인덱스 전송
    async findIndex(index) {
      // let index = ''
      axios.get(`http://18.142.131.188/nutrition/${index}`).then((response)=>{
      console.log(response.data, 'index전송, 영양정보 받아오기');
      })
    },

    open_inputProduct_Modal() {
      this.is_show = !this.is_show
    },

    // 첫 번째 기능
    firstFunction() {
      this.open_inputProduct_Modal()
    },


    // 두 번째 기능
    secondFunction() {

    },
  },

  // MQTT통신
  mqtt: {
    'common3': function(value, topic) {
      let result = JSON.parse(value)
      console.log('index : ', result[0].index)
      this.index = result[0].index
      // this.findIndex(this.index)
      
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

#textInfo {
    font-size: 20px;
    box-shadow: inset 0 -10px #3767FF; line-height:21px;
}


#button_box {
	display: flex;
	justify-content: center;
	align-items: center;
}


@import url('https://fonts.googleapis.com/css2?family=Black+Han+Sans&display=swap');
.my_btn {
	background-color: #3767FF;
	border-radius:20px;
	border:0px solid black;
	box-shadow: 0 0px 0px rgba(0,79,255,0.3);
	cursor:pointer;
	color:white;
	font-family:Pretendard;
	font-size:40px;
	padding:0px 50px;
	text-decoration:none;
	width: 170px;
}
.my_btn:hover {
	background-color:#f6f6f6;
	color: #3767FF;
}
.my_btn:active {
	position:relative;
	top:1px;
}

@import url('https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard-dynamic-subset.css');

.container {
  position: absolute; left: 50%; top: 50%;
  transform: translate(-50%, -50%); text-align: center;
  font-family: Pretendard;
  font-weight: 600;
  font-display: swap;
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

.menu {
    display: block;
    overflow: hidden;
    width: 60px;
    background-color: #3767FF;
    color: #fff;
    transition: all 0.5s ease;
    border-radius: 20px;
    padding: 10px;
    box-sizing: border-box;
}
.menu ul {
    list-style: none;
    margin: 0;
    padding: 0;
}
.menu a, .menu > label {
    display: block;
    height: 25px;
    padding: 8px;
    cursor: pointer;
    color: #fff;
    text-decoration: none;
}

.menu a:hover {
    color: #000;
}

.menu div {
    position: absolute;
    left: 50px;
    line-height: 1.5;
    font-size: 1em;
    font-family: Pretendard;
    padding: 0 0 0 20px;
}

#expand-menu {
    display: none;
}
#expand-menu:checked ~ ul {
    display: block;
    height: auto;
}

.menu ::before {
    font-family: 'Material Icons';
    font-size: 1.5em;
    float: left;
    clear: left;
}
.menu label::before{ content: '\e5d2'; }
.menu li:nth-child(1) a::before{ content: '\f02e'; }
.menu li:nth-child(2) a::before{ content: '\e8d6'; }

@media screen and (max-width:1023px) {
    .menu {
        width: 60px;
    }
}
@media screen and (max-width:560px) {
    .menu #expand-menu:not(:checked) ~ ul {
        display: none;
    }
}
</style>