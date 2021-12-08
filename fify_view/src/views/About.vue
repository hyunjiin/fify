<template>
<div style="width=100%;">
    <div class="menu">
        <nav class="clearfix">
        <ul class="clearfix">
            <li><v-btn icon @click="$router.push({name:'Home'})"><v-icon color="white">home</v-icon></v-btn></li>
            <li><v-btn icon @click="$router.push({path:'about', name:'About'})"><v-icon color="white">info</v-icon></v-btn></li>
        </ul>
        </nav>
    </div>
    <div id="template" style="width=100%;">
        <head>
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
        </head>



        <div class="about" style="padding-top:30px; h=100%;">
        <div id="title">
        <img src="@/logo.png" height="120">
        <div style = "font-weight:900; font-size:1.5rem; margin:0px;">Find It For You : 대신 찾고, 알려드릴게요</div>
        <div style = "font-weight:900; font-size:1.5rem; margin-bottom:2rem; padding-top:-10px;">저시력자를 위한 제품 안내 서비스</div>


        <span style = "font-weight:900; font-size:1.2rem; box-shadow: inset 0 -10px #3767FF; line-height:21px; margin:0"> 검색 기능</span>
        <div><span class="dot">●</span>매대에서 찾고 싶은 제품을 대신 찾아드리는 기능입니다</div>
        <div><span class="dot">●</span>하나, 검색 버튼을 누르고 찾고자 하는 제품명을 입력한 뒤 엔터 버튼을 눌러주세요</div>
        <div><span class="dot">●</span>후면 카메라를 통해 제품을 인식하기 시작합니다</div>
        <div><span class="dot">●</span>둘, 가능한 어깨 주변까지 스마트폰을 가까이 위치하고 스마트폰을 천천히 움직여 매대를 골고루 비춰주세요</div>
        <div><span class="dot">●</span>입력하신 제품이 탐지되면 진동이 울리고 해당 제품 위로 테두리가 그려집니다</div>
        <div><span class="dot">●</span>이때 영양 정보 버튼을 누르시면 해당 제품의 성분을 볼 수 있어요</div>
        <div style = "margin-bottom:30px;"><span class="dot">●</span>다른 제품을 찾고 싶으실 땐 검색, 혹은 확인 버튼을 다시 눌러주세요</div>
        <span style = "font-weight:900; font-size:1.2rem; box-shadow: inset 0 -10px #3767FF; line-height:21px; margin:0">확인 기능</span>
        <div><span class="dot">●</span>손에 들고 있는, 혹은 앞에 있는 제품이 무엇인지 알려드리는 기능입니다</div>
        <div><span class="dot">●</span>반드시 제품을 하나만 손에 들어주시고, 혹은 깨끗한 책상 위 등에 제품을 올려놓고 카메라를 제품에 가까이 대어 주세요</div>
        <div><span class="dot">●</span>확인 기능을 누르시면 후면 카메라를 통해 제품을 인식하기 시작합니다</div>
        <div><span class="dot">●</span>제품이 탐지되면 진동이 울리고 제품 위로 테두리가 그려집니다</div>
        <div><span class="dot">●</span>이때 영양 정보 버튼을 누르시면 해당 제품의 성분을 볼 수 있어요</div>
        <div style = "margin-bottom:20px;"><span class="dot">●</span>다른 제품을 찾고 싶으실 땐 검색, 혹은 확인 버튼을 다시 눌러주세요</div>
        </div>
        </div>
    </div>
</div>
</template>

<style>
@import url('https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard-dynamic-subset.css');

#template {
    margin-top: 2rem;
	position: absolute; left: 50%;
    transform: translateX(-50%); text-align: center;
	justify-content: left;
	align-items: left;
}

.dot {
    font-size:0.5rem;
    color:#3767FF;
    margin-right: 5px;
}

.about {
	font-family: Pretendard;
	font-weight: 600;
	font-display: swap;
	font-size: 1rem;
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

nav a#pull{
    display: none;
}

html {
    -webkit-touch-callout:none;
    -webkit-user-select:none;
        user-select: none;
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
</style>