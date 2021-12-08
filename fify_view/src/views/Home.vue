<template>
<div>
    <div class="menu">
        <nav class="clearfix">
        <ul class="clearfix">
            <li><v-btn icon @click="$router.push({name:'Home'})"><v-icon color="white">mdi-home</v-icon></v-btn></li>
            <li><v-btn icon @click="$router.push({path:'about', name:'About'})"><v-icon color="white">mdi-information</v-icon></v-btn></li>
        </ul>
        </nav>
    </div>

    <div class="container">
        <div style="margin-top:3rem;">
            <span id="textInfo" class="" style="box-shadow: inset 0 -10px #3767FF; line-height:21px;">
                {{message1}}
                <p>{{message2}}</p>
                {{mqttMessage}}
            </span>
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

    <!-- 1번기능, 2번기능, 영bbbb정보 표시 기능 -->
        <div style="margin-bottom:0.5rem;" id="button_box">
            <button style="margin-right:0.5rem;" name="firstFunction"
                    type='button' class="my_btn"
                    @click="showModal = true">검색</button>
            <Modal v-if="showModal" @close="showModal = false">
              <div slot="body">
                <input id="inputProduct" type='text' v-model="inputProduct" placeholder="제품을 입력하세요">
                <button @click="[onProductPub(), showModal = false, firstFunction()]">전송</button>
              </div>
            </Modal>
            <button type='button' class="my_btn"
                    @click="secondFunction">확인</button>
        </div>
    
    <div style="display: flex; justify-content: center; align-items: center;">
      <button style="margin-bottom:0.5rem; width: 14.5rem;"
              type='button' class="my_btn"
              @click="showNutritionModal = true">성분표{{salt}}</button>
      <NutritionModal v-if="showNutritionModal" @close="showNutritionModal = false">
      <div slot="body">
        <div>
          <b-table striped hover :items="items"></b-table>
        </div>
        <button @click="showNutritionModal = false">확인</button>
      </div>
    </NutritionModal>
    </div>
    

    <button type="button"
            class="btn btn-success"
            @click="captureVideo">captureVideo</button>
    <button type="button"
            class="btn btn-danger"
            @click="stopCaptureVideo">stopCaptureVideo</button>


    


  </div>
</div>


</template>

<script>
import { WebCam } from "vue-web-cam";
import { find, head } from "lodash";
import axios from 'axios';
import Modal from '../components/Modal.vue';
import NutritionModal from '../components/NutritionModal.vue';


export default {
  name: "App",
  components: {
    WebCam,
    Modal,
    NutritionModal
  },
  props: ['topic'],
  data() {
    return {
      img: null,
      camera: null,
      deviceId: null,
      devices: [],
      inputProduct: "",
      message1: "message",
      message2: "message",
      mqttMessage: "mqttMessage",
      showModal: false,
      showNutritionModal: false,

      serving_size: '',
      calorie_kJ: '',
      calorie_kcal: '',
      carbohydrate: '',
      sugar: '',
      protein: '',
      fat: '',
      fat_2: '',
      fat_3: '',
      cholesterol: '',
      salt: '',
      fat_4: '',
      fat_5: '',
      dietary_fiber: '',
      potassium: '',

      items: [
        {aaaa : 'serving_size', bbbb : this.serving_size},
        {aaaa : 'calorie_kJ', bbbb : this.calorie_kJ},
        {aaaa : 'calorie_kcal', bbbb : this.calorie_kcal},
        {aaaa : 'carbohydrate', bbbb : this.carbohydrate},
        {aaaa : 'sugar', bbbb : this.sugar},
        {aaaa : 'protein', bbbb : this.protein},
        {aaaa : 'fat', bbbb : this.fat},
        {aaaa : 'fat_2', bbbb : this.fat_2},
        {aaaa : 'fat_3', bbbb : this.fat_3},
        {aaaa : 'fat_4', bbbb : this.fat_4},
        {aaaa : 'fat_5', bbbb : this.fat_5},
        {aaaa : 'cholesterol', bbbb : this.cholesterol},
        {aaaa : 'salt', bbbb : this.salt},
        {aaaa : 'dietary_fiber', bbbb : this.dietary_fiber},
        {aaaa : 'potassium', bbbb : this.potassium}
      ]
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

    // 1초에 1번 사진 전송
    captureVideo() {
      this.timerId = setInterval(()=>{
        this.img = this.$refs.webcam.capture()
        let temp = this.img.slice(23)
        let jpg = this.base64ToArray(temp)
        this.$mqtt.publish('fify/image', jpg)
        console.log('이미지 사이즈 : ', this.img.length)
        this.drawRectangle()

      }, 1000);
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

      console.log("1번째 네모", this.recX1, this.recY1, this.recW1, this.recH1)
      console.log("2번째 네모", this.recX2, this.recY2, this.recW2, this.recH2)
      console.log("3번째 네모", this.recX3, this.recY3, this.recW3, this.recH3)
      console.log("4번째 네모", this.recX4, this.recY4, this.recW4, this.recH4)
      console.log("5번째 네모", this.recX5, this.recY5, this.recW5, this.recH5)

      context.clearRect(0, 0, canvas1.width, canvas1.height)

      context.beginPath();
      context.linewidth = "5"
      context.strokeStyle = "red"
      context.rect(this.recX1, this.recY1, this.recW1, this.recH1)
      context.rect(this.recX2, this.recY2, this.recW2, this.recH2)
      context.rect(this.recX3, this.recY3, this.recW3, this.recH3)
      context.rect(this.recX4, this.recY4, this.recW4, this.recH4)
      context.rect(this.recX5, this.recY5, this.recW5, this.recH5)
      // context.rect(180, 50, 80, 70)
      context.stroke();

      this.findIndex(this.index)
    },

    // 클라우드로 인덱스 전송
    async findIndex() {
      // let index = ''
      // axios.get(`http://18.142.131.188/nutrition/${index}`).then((response)=>{
      axios.get(`http://18.142.131.188/nutrition/1`).then((response)=>{
      console.log(response.data, 'index전송, 영bbbb정보 받아오기');

      let nutritionResult = response.data
      this.nutritionResult = nutritionResult

      this.serving_size = nutritionResult.serving_size
      this.calorie_kJ = nutritionResult.calorie_kJ
      this.calorie_kcal = nutritionResult.calorie_kcal
      this.carbohydrate = nutritionResult.carbohydrate
      this.sugar = nutritionResult.sugar
      this.protein = nutritionResult.protein
      this.fat = nutritionResult.fat
      this.fat_2 = nutritionResult.fat_2
      this.fat_3 = nutritionResult.fat_3
      this.cholesterol = nutritionResult.cholesterol
      this.salt = nutritionResult.salt
      this.fat_4 = nutritionResult.fat_4
      this.fat_5 = nutritionResult.fat_5
      this.dietary_fiber = nutritionResult.dietary_fiber
      this.potassium = nutritionResult.potassium

      console.log(this.potassium, '111111');

      })
    },

    // 첫 번째 기능
    firstFunction() {
      if(this.result[0].messsage == null) {
        this.captureVideo()
      } else {
        console.log("기능 1번 : 제품 찾을 수 없음")
      }
      
      // 제품 미등록 시 'message'출력
      // 제품 미등록 시 퍼블리시 안하기
      // 이건 mqtt로 온다
    },


    // 두 번째 기능
    secondFunction() {
      // this.findIndex()
      this.$mqtt.publish('fify/product', null)
      this.captureVideo()
      if(this.nutritionResult.voice_1 == null && this.nutritionResult.voice_2 == null) {
        this.message1 = this.nutritionResult.product_name
        this.message2 = null
        this.mqttMessage = null
      } else if(this.nutritionResult.voice_1 != null) {
        this.message1 = this.nutritionResult.voice_1
        this.message2 = this.nutritionResult.voice_2
      }

    },

    // 제품 이름 또는 메시지
  },

  // MQTT통신
  mqtt: {
    'common3': function(value, topic) {
      let result = JSON.parse(value)
      this.result = result
      console.log('index : ', result[0].index)
      this.index = result[0].index

      console.log('message :', result[0].message)
      console.log(result, topic)

      if(result[0].message != null)
        var mqttMessage = result[0].message
        this.mqttMessage = mqttMessage

      // 변수 - if index is not NULL
      if(result[4].index != null) {
        let index = result[0].index

        let recX1 = result[0]
        let recY1 = result[0]
        let recW1 = result[0]
        let recH1 = result[0]
        
        let recX2 = result[1]
        let recY2 = result[1]
        let recW2 = result[1]
        let recH2 = result[1]
        
        let recX3 = result[2]
        let recY3 = result[2]
        let recW3 = result[2]
        let recH3 = result[2]

        let recX4 = result[3]
        let recY4 = result[3]
        let recW4 = result[3]
        let recH4 = result[3]

        let recX5 = result[4]
        let recY5 = result[4]
        let recW5 = result[4]
        let recH5 = result[4]

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
      } else if(result[3].index != null) {
        console.log('if 1')

        let index = result[0].index

        let recX1 = result[0]
        let recY1 = result[0]
        let recW1 = result[0]
        let recH1 = result[0]
        
        let recX2 = result[1]
        let recY2 = result[1]
        let recW2 = result[1]
        let recH2 = result[1]
        
        let recX3 = result[2]
        let recY3 = result[2]
        let recW3 = result[2]
        let recH3 = result[2]

        let recX4 = result[3]
        let recY4 = result[3]
        let recW4 = result[3]
        let recH4 = result[3]

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
      } else if(result[2].index != null) {
        console.log('if 2')

        let index = result[0].index

        let recX1 = result[0]
        let recY1 = result[0]
        let recW1 = result[0]
        let recH1 = result[0]
        
        let recX2 = result[1]
        let recY2 = result[1]
        let recW2 = result[1]
        let recH2 = result[1]
        
        let recX3 = result[2]
        let recY3 = result[2]
        let recW3 = result[2]
        let recH3 = result[2]

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
      } else if(result[1].index != null) {
        console.log('if 1')
        let index = result[0].index

        let recX1 = result[0]
        let recY1 = result[0]
        let recW1 = result[0]
        let recH1 = result[0]
        
        let recX2 = result[1]
        let recY2 = result[1]
        let recW2 = result[1]
        let recH2 = result[1]

        this.index = index

        this.recX1 = recX1
        this.recY1 = recY1
        this.recW1 = recW1
        this.recH1 = recH1
        
        this.recX2 = recX2
        this.recY2 = recY2
        this.recW2 = recW2
        this.recH2 = recH2
      } else if(result[0].index != null){
        let index = result[0].index

        let recX1 = result[0]
        let recY1 = result[0]
        let recW1 = result[0]
        let recH1 = result[0]

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
	font-size:1.7rem;
	padding:0px 0.5rem;
	text-decoration:none;
	width: 7rem;
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
  position: absolute; left: 50%;
  transform: translateX(-50%); text-align: center;
  font-family: Pretendard;
  font-weight: 600;
  font-display: swap;
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

nav{
    font-size: 12pt;
    font-family: Pretendard;
    position: relative;
}

nav ul{
    padding: 0;
    margin: 0 auto;
    width: auto;
}

nav a{
    line-height: 50px;
  height: 50px;
}

nav li a{
    box-sizing: border-box;
    -moz-box-sizing: border-box;
    -webkit-box-sizing: border-box;
}

nav li:last-child a{
    border-right: 0;
}

ul{
    /*list-style-type: none;*/
    margin: 0;
    padding: 0;
    background-color: #3767FF;
    text-align: center;
}

li{
    /*position: relative;*/
    display: inline-block;
}

li a{
    color: #FFFFFF;
    text-align: center;
    padding: 14.5px 16px;
    text-decoration: none;
}

li a:hover{
    /*color: #597812;*/
    color: #FFD400;
    font-weight:normal;
}

.menu {
    width: 5000px;
    height: 0px;
    text-align: center;
    max-width: 100%;
    background-position: center;
    background-size: cover;
    background-color: #3767FF;color: white;
    position: absolute;z-index: 1;
}
</style>