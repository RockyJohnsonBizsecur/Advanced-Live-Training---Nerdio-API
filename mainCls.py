# main.py

from vaultclass import KeyVaultHelper

def main():
    keyvault_url = "https://<your-unique-keyvault-name>.vault.azure.net/"
    secret_name_to_retrieve = "your-secret-name"

    keyvault_helper = KeyVaultHelper(vault_url=keyvault_url)
    retrieved_secret_value = keyvault_helper.get_secret(secret_name_to_retrieve)

    if retrieved_secret_value:
        print(f"Retrieved secret value: {retrieved_secret_value}")
    else:
        print("Failed to retrieve secret.")

if __name__ == "__main__":
    main()
