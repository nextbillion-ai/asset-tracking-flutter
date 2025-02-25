import 'package:test/test.dart';
import 'package:nb_asset_tracking_flutter/src/trips/trip_state.dart';

void main() {
  group('TripState', () {
    test('fromString converts valid strings to TripState', () {
      expect(
          TripStateExtension.fromString('STARTED'), equals(TripState.started));
      expect(TripStateExtension.fromString('ENDED'), equals(TripState.ended));
      expect(TripStateExtension.fromString('END'), equals(TripState.ended));
      expect(
          TripStateExtension.fromString('UPDATED'), equals(TripState.updated));
      expect(
          TripStateExtension.fromString('DELETED'), equals(TripState.deleted));
    });

    test('fromString handles case insensitive input', () {
      expect(
          TripStateExtension.fromString('started'), equals(TripState.started));
      expect(
          TripStateExtension.fromString('Started'), equals(TripState.started));
    });

    test('fromString throws ArgumentError for invalid state', () {
      expect(
        () => TripStateExtension.fromString('INVALID'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('toShortString returns correct string representation', () {
      expect(TripState.started.toShortString(), equals('started'));
      expect(TripState.ended.toShortString(), equals('ended'));
      expect(TripState.updated.toShortString(), equals('updated'));
      expect(TripState.deleted.toShortString(), equals('deleted'));
    });
  });
}
