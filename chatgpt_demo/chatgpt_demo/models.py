from django.db import models

class Listing(models.Model):
    name = models.CharField(max_length=1000)
    description = models.CharField(max_length=1000)
    url = models.CharField(max_length=5000)
    full_description = models.TextField(default='')

    def __str__(self):
        return self.name + ', url: ' + self.url