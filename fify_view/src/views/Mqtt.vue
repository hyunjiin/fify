<template>
    <div>
        <page-title icon="mdi-access-point-network">MQTT 모니터링</page-title>
        
        <div class="my-3">
            <div v-for="(devices, place) in sensors" :key="place">
                <m-title icon="fas fa-map-marker-alt"> {{place}} </m-title>           
                
                <hr class="mt-1 mb-3">
                
                <v-row > 
                    <v-col class="pa-3" cols="6" sm="4" v-for="(value, device) in devices" :key="device">
                        <temperature v-if="device==='temp'" :value="value"></temperature>
                        <humidity v-if="device==='humi'" :value="value"></humidity>
                        <illusion v-if="device==='illu'" :value="value"></illusion>
                    </v-col>
                </v-row>
            </div>
            <m-title class="mt-5" icon="mdi-devices"> 장치 제어</m-title>
            <hr class="my-3">
            <v-row>
                <v-col cols="6" sm="4" v-for="(led, ix) in leds" :key="ix">
                    <led :led="led" :topic="topic"></led>
                </v-col>
            </v-row>
        </div>
    </div>
</template>

<script>
export default {
    name: 'Mqtt',
    data() {
        return {
            sensors: {
                // room1 : {
                //     temp : 20.2,
                //     humi : 54,
                //     illu : 80
                // },
                // livingroom : {
                //     temp : 21.5,
                //     humi : 52,
                //     illu : 70
                // }
            },
            topic: 'common123', 
            leds : [
                { place: 'livingroom', placeTitle: '거실', color: 'red', state: 
                false},
                { place: 'kitchen', placeTitle: '부엌', color: 'green', state: true},
                { place: 'bedroom', placeTitle: '침실', color: 'blue', state: false},
            ],
        };
    },
    mqtt: {
        'common123': function(value, topic) {
            let [,,,place, device] = topic.split('/')

            // 처음 인식된 장소면 빈 객체 추가
            !this.sensors[place] && (this.sensors[place] = {})
            this.sensors[place][device] = value
            // this.sensors 참조를 변경해서 Vue에게 통보해줘야 함
            this.sensors = {...this.sensors}    // **kwags
            console.log(this.sensors)
        }
    },
    mounted() {
        // 구독 신청
        this.$mqtt.subscribe('common123')
    },
    unmounted() {
        // 구독 해제
        this.$mqtt.unsubscribe('common123')
    },
};
</script>

<style scoped>
</style>
