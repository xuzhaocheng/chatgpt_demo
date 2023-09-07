import os
import sys

from pathlib import Path
sys.path[0] = str(Path(sys.path[0]).parent)

from django.http import JsonResponse
from .models import Listing
from .serializers import ListingSerializer
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from bs4 import BeautifulSoup
from urllib.request import urlopen
from requests_html import HTMLSession
from langchain.document_loaders import SeleniumURLLoader
from langchain.chains import ConversationalRetrievalChain, RetrievalQA
from langchain.chat_models import ChatOpenAI
from langchain.indexes import VectorstoreIndexCreator

import urllib.request

@api_view(['GET', 'POST'])
def listing_list(request):

    if request.method == 'GET':
        # Get all Listing, serialize and return JSON
        listings = Listing.objects.all()
        serializer = ListingSerializer(listings, many=True)
        return JsonResponse({"listings": serializer.data})
     
    if request.method == 'POST':
        url = request.data['url']
        serializer = _parse_data(url)
        if serializer.is_valid():
            # listing = serializer.data
            # serializer.save()
            _load_data(serializer.data['url'])
            return Response(serializer.data, status = status.HTTP_201_CREATED)

def _parse_data(url):
    print('Parsing URL: ' + url)
    # webpage = urlopen(url).read()

    # s = HTMLSession()
    # response = s.get(url)
    # response.html.render()

    try:
        with urllib.request.urlopen(url) as response:
            html = response.read().decode('utf-8')#use whatever encoding as per the webpage
    except urllib.request.HTTPError as e:
        if e.code==404:
            print(f"{url} is not found")
        elif e.code==503:
            print(f'{url} base webservices are not available')
            ## can add authentication here 
        else:
            print('http error',e)

    # print(html)
    # f = open("output.html", "w")
    # f.write(html)
    # f.close()

    soup = BeautifulSoup(html, "html.parser")

    meta_tags = soup.find_all("meta")

    parsed_name = ''
    parsed_description = ''
    parsed_url = ''
    parsed_full_description = ''
    
    for tag in meta_tags:
        # print(tag)
        if tag.get('property', None) == 'og:title':
            parsed_name = tag.get('content', None)
        elif tag.get('property', None) == 'og:description':
            parsed_description = tag.get('content', None)
        elif tag.get('property', None) == 'og:url':
            parsed_url = tag.get('content', None)

# for el in soup.select("[gender='male']"):

    full_description = soup.select("[data-section-id='DESCRIPTION_DEFAULT']")

    print("NAME: " + parsed_name)
    print("DESCRIPTION: " + parsed_description)
    print("URL: " + parsed_url)
    print(full_description)
    return ListingSerializer(data = {'name': parsed_name, 'description': parsed_description, 'url': parsed_url})


def _load_data(url):
    print("Loading URL: " + url)
    if url:
        loader = SeleniumURLLoader(urls=[url])
        # data = loader.load()

        index = VectorstoreIndexCreator().from_loaders([loader])
        print("Hello")

        # chain = ConversationalRetrievalChain.from_llm(
        #     llm=ChatOpenAI(model="gpt-3.5-turbo"),
        #     retriever=index.as_retriever(search_kwargs={"k": 1}),
        # )

        # query = "Does this place have a good view?"
        # result = chain({"question": query, "chat_history": []})
        # print(result['answer'])


