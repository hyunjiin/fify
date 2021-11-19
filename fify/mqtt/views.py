import paho
from django.shortcuts import render
from mqtt import subscriber


def index(request):
    subscriber.client.loop_start()

    message = subscriber.client.on_message

    return render(request, 'index.html')
