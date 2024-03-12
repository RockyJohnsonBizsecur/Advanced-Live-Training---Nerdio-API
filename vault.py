from azure.identity import DefaultAzureCredential
from azure.keyvault.secrets import SecretClient

# Initialize credentials
credential = DefaultAzureCredential()

# Initialize the SecretClient
secret_client = SecretClient(vault_url="https://<your-unique-keyvault-name>.vault.azure.net/", credential=credential)

# Retrieve a secret by name
secret_name = "your-secret-name"
retrieved_secret = secret_client.get_secret(secret_name)

# Print the secret details
print(f"Secret Name: {retrieved_secret.name}")
print(f"Secret Value: {retrieved_secret.value}")