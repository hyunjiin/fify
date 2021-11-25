from django.http import HttpResponse
from django.shortcuts import render
from mqtt import subscriber
from rest_framework.decorators import api_view


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

    return None


@api_view(['POST'])
def result():
    """
    제품인식된 결과
    json 형태로 들어오면 처리하기
    """
    subscriber.client.loop_start()

    message = subscriber.client.on_message

    return HttpResponse(message)
