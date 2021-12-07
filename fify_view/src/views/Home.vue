<template>
<div>
    <div class="menu">
        <nav class="clearfix">
        <ul class="clearfix">
            <li><v-btn icon @click="$router.push({name:'Home'})"><v-icon color="white"></v-icon></v-btn></li>
            <li><v-btn icon @click="$router.push({path:'about', name:'About'})"><v-icon color="white">info</v-icon></v-btn></li>
        </ul>
        </nav>
    </div>

    <div class="container">
        <div style="margin-top:3rem;">
            <span id="textInfo" class="" style="box-shadow: inset 0 -10px #3767FF; line-height:21px;">
                {{message1}}
                <p>{{message2}}</p>
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

    <!-- 1번기능, 2번기능, 영양정보 표시 기능 -->
        <div style="margin-bottom:0.5rem;" id="button_box">
            <button style="margin-right:0.5rem;" name="firstFunction"
                    type='button' class="my_btn"
                    @click="showModal = true">검색</button>
            <button type='button' class="my_btn"
                    @click="secondFunction">확인</button>
        </div>
    <Modal v-if="showModal" @close="showModal = false">
      <div slot="body">
        <input id="inputProduct" type='text' v-model="inputProduct" placeholder="제품을 입력하세요">
        <button @click="[onProductPub(), showModal = false, firstFunction()]">전송</button>
      </div>
    </Modal>
    <div style="display: flex; justify-content: center; align-items: center;">
      <button style="margin-bottom:0.5rem; width: 14.5rem;"
              type='button' class="my_btn"
              @click="showNutritionModal = true">성분표{{salt}}</button>
    </div>
    <NutritionModal v-if="showNutritionModal" @close="showNutritionModal = false">
      <div slot="head" v-text="bold">영양정보</div>
      <div slot="body">
        <div>
          <b-table striped hover :items="items"></b-table>
        </div>
      </div>
    </NutritionModal>

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
        {기준 : 'serving_size', 양 : this.serving_size},
        {기준 : 'calorie_kJ', 양 : this.calorie_kJ},
        {기준 : 'calorie_kcal', 양 : this.calorie_kcal},
        {기준 : 'carbohydrate', 양 : this.carbohydrate},
        {기준 : 'sugar', 양 : this.sugar},
        {기준 : 'protein', 양 : this.protein},
        {기준 : 'fat', 양 : this.fat},
        {기준 : 'fat_2', 양 : this.fat_2},
        {기준 : 'fat_3', 양 : this.fat_3},
        {기준 : 'fat_4', 양 : this.fat_4},
        {기준 : 'fat_5', 양 : this.fat_5},
        {기준 : 'cholesterol', 양 : this.cholesterol},
        {기준 : 'salt', 양 : this.salt},
        {기준 : 'dietary_fiber', 양 : this.dietary_fiber},
        {기준 : 'potassium', 양 : this.potassium}
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

    // 1초에 6번 사진 전송
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
      // context.rect(180, 50, 80, 70)
      context.stroke();

      this.findIndex(this.index)
    },

    // 클라우드로 인덱스 전송
    async findIndex() {
      // let index = ''
      // axios.get(`http://18.142.131.188/nutrition/${index}`).then((response)=>{
      axios.get(`http://18.142.131.188/nutrition/1`).then((response)=>{
      console.log(response.data, 'index전송, 영양정보 받아오기');

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

    open_inputProduct_Modal() {
      this.is_show = !this.is_show
    },

    // 첫 번째 기능
    firstFunction() {
      this.captureVideo()
    },


    // 두 번째 기능
    secondFunction() {
      // this.findIndex()
      this.$mqtt.publish('fify/product', null)
      this.captureVideo()
      if(this.nutritionResult.voice_1 == null && this.nutritionResult.voice_2 == null) {
        this.message1 = this.nutritionResult.product_name
        this.message2 = null
      } else if(this.nutritionResult.voice_1 != null) {
        this.message1 = this.nutritionResult.voice_1
        this.message2 = this.nutritionResult.voice_2
      }

    },

    // 영양정보
    info() {

    },

    // 제품 이름 또는 메시지
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

nav a:hover, nav a:active{
}

nav a#pull{
    display: none;
}

html {
    -webkit-touch-callout:none;
    -webkit-user-select:none;
    -webkit-tap-highlight-color:rgba(0, 0, 0, 0);
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
@media screen and (max-width:560px) {
    .menu #expand-menu:not(:checked) ~ ul {
        display: none;
    }

}
</style>