import 'dart:convert';

mixin NBEncode {
  String encode() => jsonEncode(this);
}
