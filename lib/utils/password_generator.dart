import 'dart:math';

class PasswordGenerator {
  static final String UPPER_CASE_LETTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  static final String LOWER_CASE_LETTERS = "abcdefghijklmnopqrstuvwxyz";
  static final String NUMBERS = "0123456789";
  static final String SPECIAL_CHARACTERS = "!@#\$%^&*()-_=+[]{}|;:,.<>?/";
  static final String ALL_CHARS =
      UPPER_CASE_LETTERS + LOWER_CASE_LETTERS + NUMBERS + SPECIAL_CHARACTERS;

  /// 生成随机密码
  static String generateRandomPassword([int length = 12]) {

    Random random = Random();
    StringBuffer password = StringBuffer();
    password.write(UPPER_CASE_LETTERS[random.nextInt(UPPER_CASE_LETTERS.length)]);
    password.write(LOWER_CASE_LETTERS[random.nextInt(LOWER_CASE_LETTERS.length)]);
    password.write(NUMBERS[random.nextInt(NUMBERS.length)]);
    password.write(SPECIAL_CHARACTERS[random.nextInt(SPECIAL_CHARACTERS.length)]);

    // 随机填充剩余的字符
    for (int i = 4; i < length; i++) {
      int index = random.nextInt(ALL_CHARS.length);
      password.write(ALL_CHARS[index]);
    }

    return password.toString();
  }
}
