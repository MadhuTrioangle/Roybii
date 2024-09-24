import 'dart:convert';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:zodeakx_mobile/Utils/Constant/AppConstants.dart';

CryptoJS encryptDecrypt = CryptoJS();

class CryptoJS {
 
  String encryptUsingAESAlgorithm(String plainText) {
    try {
      final key = encrypt.Key.fromUtf8(constant.encrytAndDecryptCode);
      final iv = encrypt.IV.fromUtf8(constant.encrytAndDecryptCode);

      final encrypter = encrypt.Encrypter(
          encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: "PKCS7"));
      final encrypted = encrypter.encrypt(plainText, iv: iv);
      Uint8List encryptedBytesWithSalt = Uint8List.fromList(encrypted.bytes);
      return base64.encode(encryptedBytesWithSalt);
    } catch (error) {
      throw error;
    }
  }

  String decryptUsingAESAlgorithm(String encrypted) {
    try {
      Uint8List encryptedBytesWithSalt = base64.decode(encrypted);

      final key = encrypt.Key.fromUtf8(constant.encrytAndDecryptCode);
      final iv = encrypt.IV.fromUtf8(constant.encrytAndDecryptCode);

      final encrypter = encrypt.Encrypter(
          encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: "PKCS7"));
      final decrypted =
          encrypter.decrypt64(base64.encode(encryptedBytesWithSalt), iv: iv);
      return decrypted;
    } catch (error) {
      throw error;
    }
  }
}
