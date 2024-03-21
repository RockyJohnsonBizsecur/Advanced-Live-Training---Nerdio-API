#Advanced Live Training Nashville
#libraries needed keyvault access and secret retrieval
from azure.identity import ClientSecretCredential
from azure.keyvault.secrets import SecretClient
from dotenv import load_dotenv
import os

load_dotenv()

def getSecret():
    #setup the variables to assign to creds
    clientId = os.environ['spClientId']
    tenantId = os.environ['spTenantId']
    clientSecret = os.environ['spSecret']
    vaultURL = os.environ['vaultURL']

    secretName = 'nmmApiSecret'
    #initialize credentials
    credential = ClientSecretCredential(
        client_id=clientId,
        client_secret=clientSecret,
        tenant_id=tenantId
    )

    # Initialize the SecretClient
    secret_client = SecretClient(vault_url=vaultURL, credential=credential)

    # Retrieve a secret by name
    retrieved_secret = secret_client.get_secret(secretName)

    # Print the secret details
    print(f"Secret Name: {retrieved_secret.name}")
    print(f"Secret Value: {retrieved_secret.value}")

    return retrieved_secret.value