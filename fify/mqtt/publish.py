import paho.mqtt.client as mqtt
import json


def on_connect(client, userdata, flags, rc):
    print("Connected with result code "+ str(rc))
    if rc == 0:
        print("connected OK")
    else:
        print("Bad connection Returned code ", rc)


def on_disconnect(client, userdata, flags, rc=0):
    print(str(rc))


def on_publish(client, userdata, mid):
    print("In on_pub callback mid= ", mid)


client = mqtt.Client()
# 콜백 함수 설정 on_connect(브로커에 접속)
# on_disconnect(브로커에 접속중료)
# on_publish(메세지 발행)
client.on_connect = on_connect
client.on_disconnect = on_disconnect
client.on_publish = on_publish

client.connect('18.142.131.188', 1883)
# client.loop_start()

# client.publish('common', json.dumps({"name": "FIFY"}), 1)
# client.publish('common', "123456", 1)
# client.publish('common123', "123456", 1)
# client.loop_stop()

# client.disconnect()