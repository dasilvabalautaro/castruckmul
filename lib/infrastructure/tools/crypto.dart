
import 'package:encrypt/encrypt.dart';

class Crypto{
//for AES Algorithms

  static Encrypted? encrypted;
  static String? decrypted;

  static encryptAES(plainText){
    final key = Key.fromUtf8('%C*F-JaNdRgUkXp2r5u8x/A?D(G+KbPe');
    final iv = IV.fromLength(16);
    final encryptor = Encrypter(AES(key));
    encrypted = encryptor.encrypt(plainText, iv: iv);

  }

  static decryptAES(plainText){
    final key = Key.fromUtf8('%C*F-JaNdRgUkXp2r5u8x/A?D(G+KbPe');
    final iv = IV.fromLength(16);
    final encryptor = Encrypter(AES(key));
    decrypted = encryptor.decrypt(encrypted!, iv: iv);

  }

  static String decrypt64(plainText){
    final key = Key.fromUtf8('%C*F-JaNdRgUkXp2r5u8x/A?D(G+KbPe');
    final iv = IV.fromLength(16);
    final encryptor = Encrypter(AES(key));
    return encryptor.decrypt64(plainText, iv: iv);
  }
}