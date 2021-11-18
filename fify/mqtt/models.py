from django.db import models
from django.db.models.expressions import ValueRange

# Create your models here.
class Sensor(models.Model):
    username = models.CharField('사용자명', max_length=20, null=True, blank=True)
    place = models.CharField('설치장소', max_length=30, null=True)
    sensor = models.CharField('센서', max_length=30, null=True)
    value = models.CharField('센서값')
    reg_date = models.CharField('등록일', auto_now_add=True, null=True, blank=True)

    def __Str__(self):
        return f'{self.username}/{self.place}/{self.sensor} {self.value}'