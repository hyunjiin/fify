<template>
  <div class="hello">
    <video v-bind:src="src" v-bind:width="width" v-bind:height="height" v-bind:autoplay="autoplay" ref="video"></video>
    <hr/>
    <img v-bind:src="photo" alt="" v-bind:width="width" v-bind:height="height"/>
    <hr/>
    <button type="button" v-on:click="takePhoto">Take Photo</button>
    <hr/>
  </div>
</template>
