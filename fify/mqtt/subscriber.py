import paho.mqtt.client as mqtt

def on_connect(client, userdata, flags, rc):
    print("Connected with result code "+ str(rc))
    if rc == 0:
        print("connected OK")
    else:
        print("Bad connection Returned code ", rc)


def on_disconnect(client, userdata, flags, rc=0):
    print(str(rc))


def on_subscribe(client, userdata, mid, granted_qos):
    print("subscribed: " + str(mid) + " " + str(granted_qos))


def on_message(client, userdata, msg):
    # print("이미지 도착")
    print(msg)
    image_result = open('fify_image.jpeg', 'wb')
    image_result.write(msg.payload)


client = mqtt.Client()

client.on_connect = on_connect
client.on_disconnect = on_disconnect
client.on_subscribe = on_subscribe
client.on_message = on_message

client.connect('18.142.131.188', 1883)

client.subscribe('common3', 1)
client.loop_forever()
