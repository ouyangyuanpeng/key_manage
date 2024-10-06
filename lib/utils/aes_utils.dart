import 'dart:math';
import 'dart:convert';
import 'package:encrypt/encrypt.dart' as encrypt;

class AesUtils {

  static String? defaultKey;

  /// 设置默认密钥
  static void setDefaultKey(String key) {
    defaultKey = key;
  }

  /// 生成 AES 密钥
  static String generateAesKey([int length = 32]) {
    // 32字节 = 256位
    final List<int> key =
        List.generate(length, (index) => Random.secure().nextInt(256));
    return base64.encode(key); // 使用 Base64 编码方便展示
  }

  /// 加密
  static String encryptPassword(String password, [String? aesKey]) {

    aesKey ??= defaultKey; // 如果没有提供密钥，使用默认密钥
    if (aesKey == null) {
      throw Exception("AES 密钥未设置");
    }

    final key = encrypt.Key.fromBase64(aesKey);
    final iv = encrypt.IV.fromLength(16); // 生成随机 IV
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    final encrypted = encrypter.encrypt(password, iv: iv);
    return '${iv.base64}:${encrypted.base64}'; // 将 IV 和密文分隔开
  }

  static String decryptPassword(String encryptedData, [String? aesKey]) {
    aesKey ??= defaultKey; // 如果没有提供密钥，使用默认密钥
    if (aesKey == null) {
      throw Exception("AES 密钥未设置");
    }

    final key = encrypt.Key.fromBase64(aesKey);
    final parts = encryptedData.split(':');
    final iv = encrypt.IV.fromBase64(parts[0]); // 提取 IV
    final encrypted = parts[1];

    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    return encrypter.decrypt64(encrypted, iv: iv); // 使用提取的 IV 解密
  }
}
