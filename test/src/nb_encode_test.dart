import 'package:test/test.dart';
import 'package:nb_asset_tracking_flutter/src/nb_encode.dart';
import 'dart:convert' show JsonUnsupportedObjectError;

// Test class that implements the mixin
class TestClass with NBEncode {
  final String name;
  final int value;

  TestClass(this.name, this.value);

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'value': value,
    };
  }
}

class NonEncodableClass with NBEncode {
  final Object nonEncodableField = Object();
}

void main() {
  group('NBEncode', () {
    test('encodes simple object to JSON string', () {
      final testObject = TestClass('test', 42);
      final encoded = testObject.encode();
      expect(encoded, '{"name":"test","value":42}');
    });

    test('encodes object with special characters', () {
      final testObject = TestClass('test "quotes"', 42);
      final encoded = testObject.encode();
      expect(encoded, '{"name":"test \\"quotes\\"","value":42}');
    });

    test('encodes object with unicode characters', () {
      final testObject = TestClass('テスト', 42);
      final encoded = testObject.encode();
      expect(encoded, '{"name":"テスト","value":42}');
    });

    test('throws when object contains non-encodable values', () {
      final nonEncodable = NonEncodableClass();
      expect(
        () => nonEncodable.encode(),
        throwsA(isA<JsonUnsupportedObjectError>()),
      );
    });
  });
}
