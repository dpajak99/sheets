import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:sheets/utils/streamable.dart';

void main() {
  group('Tests of Streamable<T>', () {
    group('Tests of Streamable constructor', () {
      test('Should [initialize StreamController] when [Streamable is instantiated]', () {
        // Arrange & Act
        Streamable<int> streamable = Streamable<int>();

        // Assert
        expect(streamable, isNotNull);
        // Cannot directly test _streamController as it's private,
        // but we can check that we can get the stream
        expect(streamable.stream, isA<Stream<int>>());
      });
    });

    group('Tests of listen()', () {
      test('Should [receive events] when [events are added after listening]', () async {
        // Arrange
        Streamable<int> streamable = Streamable<int>();
        List<int> receivedEvents = <int>[];

        // Act
        streamable.listen((int event) {
          receivedEvents.add(event);
        });

        streamable.addEvent(1);
        streamable.addEvent(2);
        streamable.addEvent(3);

        // Need to wait for the events to be processed
        await Future<void>.delayed(Duration.zero);

        // Assert
        expect(receivedEvents, equals(<int>[1, 2, 3]));
      });

      test('Should [throw StateError] when [trying to listen multiple times]', () async {
        // Arrange
        Streamable<int> streamable = Streamable<int>();
        List<int> receivedEvents1 = <int>[];
        List<int> receivedEvents2 = <int>[];

        // Act
        streamable.listen((int event) {
          receivedEvents1.add(event);
        });

        // Assert
        expect(() {
          streamable.listen((int event) {
            receivedEvents2.add(event);
          });
        }, throwsA(isA<StateError>()));
      });
    });

    group('Tests of addEvent()', () {
      test('Should [add event to stream] when [addEvent is called]', () async {
        // Arrange
        Streamable<String> streamable = Streamable<String>();
        String? receivedEvent;

        // Act
        streamable.listen((String event) {
          receivedEvent = event;
        });

        streamable.addEvent('test');

        // Need to wait for the event to be processed
        await Future<void>.delayed(Duration.zero);

        // Assert
        expect(receivedEvent, equals('test'));
      });

      test('Should [throw StateError] when [adding event after dispose]', () async {
        // Arrange
        Streamable<int> streamable = Streamable<int>();
        await streamable.dispose();

        // Act & Assert
        expect(() => streamable.addEvent(1), throwsA(isA<StateError>()));
      });
    });

    group('Tests of dispose()', () {
      test('Should [close the stream controller] when [dispose is called]', () async {
        // Arrange
        Streamable<int> streamable = Streamable<int>();

        // Act
        await streamable.dispose();

        // Assert
        // Cannot directly test _streamController as it's private,
        // but attempting to add an event should throw an error
        expect(() => streamable.addEvent(1), throwsA(isA<StateError>()));
      });

      test('Should [complete the stream] when [dispose is called]', () async {
        // Arrange
        Streamable<int> streamable = Streamable<int>();
        bool isDone = false;

        // Act
        streamable.stream.listen(
          (int event) {},
          onDone: () {
            isDone = true;
          },
        );

        await streamable.dispose();

        // Need to wait for the stream to close
        await Future<void>.delayed(Duration.zero);

        // Assert
        expect(isDone, isTrue);
      });
    });

    group('Tests of stream getter', () {
      test('Should [return a Stream<T>] when [stream is accessed]', () {
        // Arrange
        Streamable<double> streamable = Streamable<double>();

        // Act
        Stream<double> stream = streamable.stream;

        // Assert
        expect(stream, isA<Stream<double>>());
      });

      test('Should [allow listening to events via stream] when [stream is accessed]', () async {
        // Arrange
        Streamable<String> streamable = Streamable<String>();
        List<String> receivedEvents = <String>[];

        // Act
        streamable.stream.listen((String event) {
          receivedEvents.add(event);
        });

        streamable.addEvent('event1');
        streamable.addEvent('event2');

        // Need to wait for the events to be processed
        await Future<void>.delayed(Duration.zero);

        // Assert
        expect(receivedEvents, equals(<String>['event1', 'event2']));
      });

      test('Should [throw StateError] when [trying to listen multiple times via stream]', () {
        // Arrange
        Streamable<int> streamable = Streamable<int>();
        streamable.stream.listen((int event) {});

        // Act & Assert
        expect(() {
          streamable.stream.listen((int event) {});
        }, throwsA(isA<StateError>()));
      });
    });
  });
}
