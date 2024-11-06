import os
import requests
import json
from dotenv import load_dotenv
from vault import getSecret

#setup global variables
baseUrl = 'https://web-admin-portal-bqci3klofchas.azurewebsites.net/'

#load environment variables from .env file
load_dotenv()

#read NMM API keys/values from environment variables
#api_tenantId = os.getenv("tenantId")
api_scope = os.getenv("scope")
api_tokenUrl = os.getenv('tokenURL')
api_clientId = os.getenv('clientId')

#get the NMM API Secret from the key vault
api_secret = getSecret()

combinedData = []

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
        return (data)
        
    else:
        print(f"Error making API call. Status code: {response.status_code}")
        print(response.text)

def acctDetails(acctData):
    for row in acctData:
        acctId = row['id']
        acctDetail = callEndpoint(f'/rest-api/v1/accounts/{acctId}/backup/protectedItems', bearer, '')
        combinedData.append(acctDetail)        
    return combinedData

bearer = getToken()
print (bearer['access_token'])
bearer = bearer['access_token']

accounts = callEndpoint('/rest-api/v1/accounts', bearer, '')

formattedAccounts = json.dumps(accounts, indent=2)
print (formattedAccounts)

processDetail = acctDetails(accounts)
backUpDetails = json.dumps(processDetail, indent=2)
print (backUpDetails)

with open('backUpDetails.json', 'w') as f:
    json.dump(processDetail, f, indent=4)