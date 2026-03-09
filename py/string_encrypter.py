# pip install cryptography

from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives import padding
import base64
import os

# Encryption key and IV must be bytes
key = b"ToxqPmBoTNwEgJpPrFEcdqWMTttZIGdx"  # 32 bytes (256 bits)
iv = b"pyipIQBTtgRkPWai"                   # 16 bytes (128 bits)

def pad(data: bytes) -> bytes:
    padder = padding.PKCS7(algorithms.AES.block_size).padder()
    return padder.update(data) + padder.finalize()

def unpad(data: bytes) -> bytes:
    unpadder = padding.PKCS7(algorithms.AES.block_size).unpadder()
    return unpadder.update(data) + unpadder.finalize()

def encrypt_string(plain_text: str) -> str:
    backend = default_backend()
    cipher = Cipher(algorithms.AES(key), modes.CBC(iv), backend=backend)
    encryptor = cipher.encryptor()

    # Convert plain text to bytes and pad
    padded_data = pad(plain_text.encode('utf-8'))
    encrypted = encryptor.update(padded_data) + encryptor.finalize()

    # Encode to base64 and return as a string
    return base64.b64encode(encrypted).decode('utf-8')

def decrypt_string(encrypted_text: str) -> str:
    backend = default_backend()
    cipher = Cipher(algorithms.AES(key), modes.CBC(iv), backend=backend)
    decryptor = cipher.decryptor()

    # Decode base64 and decrypt
    encrypted_data = base64.b64decode(encrypted_text)
    decrypted = decryptor.update(encrypted_data) + decryptor.finalize()

    # Unpad the decrypted data and return as a string
    return unpad(decrypted).decode('utf-8')



txtData = ""

with open("others/py/unSyncedData_24.txt") as f:
    txtData = f.read()



print(txtData)

# Example usage
# plain_text = "Hello, World!"
# encrypted = encrypt_string(plain_text)
# print("Encrypted:", encrypted)

decrypted = decrypt_string(txtData)
print("Decrypted:", decrypted)
