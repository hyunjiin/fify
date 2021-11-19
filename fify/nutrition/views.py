from rest_framework.decorators import api_view


@api_view(['GET'])
def info(index):
    """
    제품 index 받아서 db에서 불러오기
    vue로 넘기기
    """

    return None
