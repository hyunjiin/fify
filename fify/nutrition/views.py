from django.http import HttpResponse
from rest_framework.decorators import api_view

from .models import Nutrition, Yolo
from .serializers import NutritionSerializer


@api_view(['GET'])
def info(index):
    """
    제품 index 받아서 db에서 불러오기
    vue로 넘기기
    """

    yolo_index = 3  # index 파라미터 값, 임시로 할당

    yolo_model = Yolo.objects.get(index=yolo_index)  # 넘어온 index로 db의 pk 검색
    print(yolo_model.id, yolo_model.index)
    nutrition = Nutrition.objects.get(yolo_id_id=yolo_model.id)  # pk로 영양정보 검색
    serializer = NutritionSerializer(nutrition, many=False)
    print(serializer.data)
    return HttpResponse(serializer.data)
