import 'package:encrypt/encrypt.dart' as enc;

enc.IV _ivV1 = enc.IV.fromUtf8("pyipIOBTtgRkRWai");

enc.Encrypter _encrypterV1 = enc.Encrypter(
  enc.AES(
    enc.Key.fromUtf8("YoxqPmBoTNwEgJpPrFEcdqWMTttZOGdx"),
    mode: enc.AESMode.cbc,
  ),
);

String encryptStringV1(String plainText) {
  return _encrypterV1.encrypt(plainText, iv: _ivV1).base64;
}

String decryptStringV1(String plainText) {
  return _encrypterV1.decrypt(enc.Encrypted.fromBase64(plainText), iv: _ivV1);
}
