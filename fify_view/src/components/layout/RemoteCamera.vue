<template>
    <v-row>
        <v-col :sm="6">
            <v-img :src="url" :max-width="maxWidth" contain></v-img>
        </v-col>
        <v-col :sm="6" class="text-center">
            <div class="my-3">
                <knob v-model="angle" :options="knobOptions"></knob>
            </div>
            {{angle.value}}°
        </v-col> 
    </v-row>
</template>

<script>
export default {
    name: 'RemoteCamera',
    props: ['url', 'maxWidth'],
    data() {
        return {
            angle: {},
            knobOptions: [],
        }
    },
    
    mounted() {
        for(let i=-90; i<=90; i+=5) {
            this.knobOptions.push({
                value: i,
                label: i % 45 == 0 ? i: false,
                anchor: true
            })
        }
        this.angle.value = 0
    },
    watch: { // 값의 변경을 감지하여 후속 처리
        angle() { // data의 속성명과 동일한 함수로 정의
            this.$mqtt.publish('iot/hong/control/camera', this.angle.value)
            console.log('publish', 'iot/hong/control/camera', this.angle.value)
        }
    }, 
}
</script>

<style>

</style>
