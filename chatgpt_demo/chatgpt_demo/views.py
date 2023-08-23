from django.http import JsonResponse
from .models import Listing
from .serializers import ListingSerializer

def ListingList(request):

    # Get all Listing, serialize and return JSON
    listings = Listing.objects.all()
    serializer = ListingSerializer(listings, many=True)
    return JsonResponse(serializer.data, safe=False)