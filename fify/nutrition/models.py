from django.db import models


class Yolo(models.Model):
    objects = models.Manager()
    index = models.IntegerField()
    class_name = models.CharField(max_length=50)


class Nutrition(models.Model):
    objects = models.Manager()
    yolo_id = models.ForeignKey(Yolo, on_delete=models.CASCADE)
    class_name = models.CharField(max_length=50)
    product_name = models.CharField(max_length=50)  # 제품이름
    serving_size = models.CharField(max_length=30)  # 서빙 사이즈
    calorie_kJ = models.CharField(max_length=10)  # 열량(kJ)
    calorie_kcal = models.CharField(max_length=10)  # 열량(kcal)
    carbohydrate = models.CharField(max_length=10)  # 탄수화물(g)
    sugar = models.CharField(max_length=10)  # 설탕당(g)
    protein = models.CharField(max_length=10)  # 단백질(g)
    fat = models.CharField(max_length=10)  # 지방(g)
    fat_2 = models.CharField(max_length=10)  # 포화지방(g)
    fat_3 = models.CharField(max_length=10)  # 트랜스지방(g)
    fat_4 = models.CharField(max_length=10, null=True)
    fat_5 = models.CharField(max_length=10, null=True)
    dietary_fiber = models.CharField(max_length=10, null=True)
    potassium = models.CharField(max_length=10, null=True)
    cholesterol = models.CharField(max_length=10)  # 콜레스테롤(mg)
    salt = models.CharField(max_length=10, null=True)  # 나트륨(mg)
    voice1 = models.CharField(max_length=255)
    voice2 = models.CharField(max_length=255)
