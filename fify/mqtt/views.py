import paho.mqtt.client as client
from django.shortcuts import render
from rest_framework.decorators import api_view
from rest_framework.response import Response
from nutrition.models import Nutrition
from nutrition.models import Yolo
import json



count = 0


@api_view(['GET'])
def index(request):
    """
    메인화면
    접속하면 vue 화면 보여주기
    """

    return render(request, 'index.html')


@api_view(['GET'])
def camera(request):
    """
    제품 인식 서비스 화면
    이미지 및 음성 정보 mqtt publish
    """
    # client.loop_start()
    # client.publish('common1', """촬영한 이미지 url""", 1)
    # client.loop_stop()
    #
    # client.disconnect()
    # subscriber.loop_start()
    return None


@api_view(['POST'])
def result(request):
    """
    1번 기능
    제품인식 결과
    {'index': {'first': 0}, 'exist': 'y', 'detact': 'y',
            'coord': {'first': [0.5661057692307693, 0.4519230769230769, 0.5204326923076923, 0.7944711538461539]},
            'center': [0.5661057692307693, 0.4519230769230769]}
    """

    global count

    request_data = request.data
    print(request_data)

    if request_data['index'] is None:
        request_data['product_name'] = ''
    if request_data['exist'] == 'n':
        request_data["message"] = "등록되지 않은 제품입니다."
    elif request_data['detact'] == 'n':
        count += 1
        if count < 60:
            return Response(str(count))
        else:
            request_data["message"] = "매대를 비춰주세요."
    else:
        count = 0

    yolo_model = Yolo.objects.get(index=request.data['index']['first'])
    nutrition = Nutrition.objects.get(class_name=yolo_model.class_name)
    request_data['product_name'] = nutrition.product_name

    print(request_data)
    print(json.dumps(request_data))
    client.publish('common3', json.dumps(request_data), 1)

    return Response(request_data)


@api_view(['POST'])
def result2(request):
    """
    2번기능
    제품인식 결과
    json 형태로 들어오면 처리하기
    """

    global count

    request_data = request.data


    if len(request.data['index']) > 1:
        request_data["message"] = "하나의 제품만 비춰주세요."
    if request_data['index'] is None:
        request_data['product_name'] = ''
    elif request_data['exist'] == 'n':
        request_data["message"] = "등록되지 않은 제품입니다."
    elif request_data['detact'] == 'n':
        count += 1
        if count < 60:
            return Response(str(count))
        else:
            request_data["message"] = "매대를 비춰주세요."
    else:
        count = 0

    yolo_model = Yolo.objects.get(index=request.data['index']['first'])
    nutrition = Nutrition.objects.get(class_name=yolo_model.class_name)
    request_data['product_name'] = nutrition.product_name

    print(request_data)
    print(json.dumps(request_data))
    client.publish('common3', json.dumps(request_data), 1)

    return Response(request_data)


def on_connect(client, userdata, flags, rc):
    print("Connected with result code " + str(rc))
    if rc == 0:
        print("connected OK")
    else:
        print("Bad connection Returned code ", rc)


def on_disconnect(client, userdata, flags, rc=0):
    print(str(rc))


def on_publish(client, userdata, mid):
    print("In on_pub callback mid= ", mid)


client = client.Client()
client.on_connect = on_connect
client.on_disconnect = on_disconnect
client.on_publish = on_publish

client.connect('18.142.131.188', 1883)
