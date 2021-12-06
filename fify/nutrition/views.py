from django.http import HttpResponse
from rest_framework.decorators import api_view
from rest_framework.response import Response

from .models import Nutrition, Yolo
from .serializers import NutritionSerializer


@api_view(['GET'])
def info(request, index):
    """
    제품 index 받아서 db에서 불러오기
    vue로 넘기기
    """

    yolo_index = index  # index 파라미터 값, 임시로 할당

    yolo_model = Yolo.objects.get(index=yolo_index)  # 넘어온 index로 class_name 확인
    nutrition = Nutrition.objects.get(class_name=yolo_model.class_name)  # class_name로 영양정보 검색
    serializer = NutritionSerializer(nutrition, many=False)  # 혹시 몰라서 하긴 했는데 굳이 안해도 될 듯한 기분

    return Response(serializer.data)
