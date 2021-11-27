from django.http import HttpResponse
from django.shortcuts import render
from mqtt.subscriber import client as subscriber
from mqtt.publish import client as publish
from rest_framework.decorators import api_view

count = 0


@api_view(['GET'])
def index(request):
    """
    메인화면
    접속하면 vue 화면 보여주기
    """

    return render(request, 'index.html')


@api_view(['GET'])
def camera():
    """
    제품 인식 서비스 화면
    이미지 및 음성 정보 mqtt publish
    """
    publish.loop_start()
    publish.publish('common1', """촬영한 이미지 url""", 1)
    publish.loop_stop()

    publish.disconnect()
    subscriber.loop_start()
    return None


@api_view(['POST'])
def result(result):
    """
    1번 기능
    제품인식 결과
    json 형태로 들어오면 처리하기
    """

    print(result)

    global count
    zzz = result

    if result['exist'] == 'n':
        zzz = {"message": "등록되지 않은 제품입니다."}
    elif result['detact'] == 'n':
        count += 1
        if count < 60:
            return count
        else:
            zzz = {"message": "매대를 비춰주세요."}
    else:
        count = 0

    publish.loop_start()
    publish.publish('common3', zzz, 1)
    publish.loop_stop()

    publish.disconnect()

    return count


@api_view(['POST'])
def result2(result):
    """
    2번기능
    제품인식 결과
    json 형태로 들어오면 처리하기
    """

    global count
    zzz = result

    if result.len > 1:
        zzz = {"message": "하나의 제품만 비춰주세요."}
    elif result['detact'] == 'n':
        count += 1
        if count < 60:
            return count
        else:
            zzz = {"message": "매대를 비춰주세요."}
    else:
        count = 0

    publish.loop_start()
    publish.publish('common3', zzz, 1)
    publish.loop_stop()

    publish.disconnect()

    return count
