import 'dart:io';
import 'package:crypto/crypto.dart';

void main() async {
  var file = File(r"E:\Code\Flutter\app-release.apk");
  print(md5.convert(file.readAsBytesSync()));
}

