from django.http import JsonResponse
from .models import Listing
from .serializers import ListingSerializer
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from bs4 import BeautifulSoup
from urllib.request import urlopen

@api_view(['GET', 'POST'])
def listing_list(request):

    if request.method == 'GET':
        # Get all Listing, serialize and return JSON
        listings = Listing.objects.all()
        serializer = ListingSerializer(listings, many=True)
        return JsonResponse({"listings": serializer.data})
     
    if request.method == 'POST':
        url = request.data['url']
        _parse_data(url)
        return Response(request.data['url'], status = status.HTTP_201_CREATED)
        # serializer = ListingSerializer(data = request.data) 
        # if serializer.is_valid():
        #     listing = serializer.data
        #     # serializer.save()
        #     print('GOT LISTING: ' + list.url)
        #     return Response(serializer.data, status = status.HTTP_201_CREATED)

def _parse_data(url):
    print('Parsing URL: ' + url)
    webpage = urlopen(url).read()
    soup = BeautifulSoup(webpage, "lxml")

    meta_tags = soup.find("meta")
    for tag in meta_tags:
        print('Tag: ' + tag)
    # serializer = ListingSerializer(data = {'name' = soup.}) 

