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
    # print(str(msg.payload.decode("utf-8")))
    print("이미지 도착")
    # img_string = msg.payload
    # image_64_decode = base64.b64decode(img_string)
    image_result = open('111.jpeg', 'wb')
    image_result.write(msg.payload)
    # image_result.close()


client = mqtt.Client()

client.on_connect = on_connect
client.on_disconnect = on_disconnect
client.on_subscribe = on_subscribe
client.on_message = on_message

client.connect('18.142.131.188', 1883)
# client.connect('192.168.35.200', 1883)

client.subscribe('fify/image', 1)
client.loop_forever()
