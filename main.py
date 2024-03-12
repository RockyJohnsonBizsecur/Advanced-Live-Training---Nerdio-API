import os
import requests
from dotenv import load_dotenv

#setup global variables
baseUrl = 'https://web-admin-portal-ahww6352rclse.azurewebsites.net'

#load environment variables from .env file
load_dotenv()

#read NMM API keys/values from environment variables
api_tenantId = os.getenv("tenantId")
api_scope = os.getenv("scope")
api_secret = os.getenv("secret")
api_tokenUrl = os.getenv('tokenURL')
api_clientId = os.getenv('clientId')

#get the bearer token from NMM API
def getToken ():

    # Make an API call (replace with your actual API endpoint)
    url = api_tokenUrl
    headers = {
        "Content-Type": "application/x-www-form-urlencoded"
    }
    data = {
        "grant_type": "client_credentials",
        "client_id": api_clientId,
        "scope": api_scope,
        "client_secret": api_secret
    }

    # Example GET request
    response = requests.get(url, headers=headers, data=data)

    if response.status_code == 200:
        data = response.json()
        #print("API response data:", data)
        return data
    else:
        print(f"Error making API call. Status code: {response.status_code}")
        print(response.text)

def callEndpoint(epUrl, bearer, params):
    url = baseUrl + epUrl
    headers = {
        "Authorization": f"Bearer {bearer}",
        "accept": "application/json"
    }
    params = params
    response = requests.get(url, headers=headers)

    if response.status_code == 200:
        data = response.json()
        #print("API response data:", data)
        return data
    else:
        print(f"Error making API call. Status code: {response.status_code}")
        print(response.text)

def evalResults():
    pass

bearer = getToken()
print (bearer['access_token'])
bearer = bearer['access_token']

accounts = callEndpoint('/rest-api/v1/accounts', bearer, '')
print (accounts)