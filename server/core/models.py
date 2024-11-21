from django.db import models

# Create your models here.

class Quotes(models.Model):
    quote = models.CharField(max_length=400)
    author = models.CharField(max_length=50)

    def __str__(self):
        return self.author 