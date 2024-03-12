# keyvault_helper.py

from azure.identity import DefaultAzureCredential
from azure.keyvault.secrets import SecretClient

class KeyVaultHelper:
    def __init__(self, vault_url):
        self.vault_url = vault_url
        self.credential = DefaultAzureCredential()
        self.secret_client = SecretClient(vault_url=self.vault_url, credential=self.credential)

    def get_secret(self, secret_name):
        try:
            secret = self.secret_client.get_secret(secret_name)
            return secret.value
        except Exception as e:
            print(f"Error retrieving secret '{secret_name}': {str(e)}")
            return None

# Example usage:
if __name__ == "__main__":
    keyvault_url = "https://<your-unique-keyvault-name>.vault.azure.net/"
    secret_name_to_retrieve = "your-secret-name"

    keyvault_helper = KeyVaultHelper(vault_url=keyvault_url)
    retrieved_secret_value = keyvault_helper.get_secret(secret_name_to_retrieve)

    if retrieved_secret_value:
        print(f"Retrieved secret value: {retrieved_secret_value}")
    else:
        print("Failed to retrieve secret.")
