from rest_framework import serializers
from .models import Quotes

# Create your views here.


class QuoteSerializer(serializers.ModelSerializer):
    class Meta:
        model = Quotes
        fields = ["id", "quote", "author"]
