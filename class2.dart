// ignore_for_file: curly_braces_in_flow_control_structures

/*
 * Performance benchmark of different ways to append data to a list.
 * https://gist.github.com/PlugFox/9849994d1f229967ef5dc408cb6b7647
 *
 * BytesBuilder  | builder.add(chunk)  | 7 us.
 * AddAll        | list.addAll(chunk)  | 594 us.
 * Spread        | [...list, ...chunk] | 1016446 us.
 * Concatenation | list + chunk        | 1005022 us.
 */

import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:benchmark_harness/benchmark_harness.dart';

/// Chunk of data to append to a list.
final Uint8List $chunk = Uint8List.fromList(
  List<int>.generate(512, (i) => i % 256),
);

/// Test performance of different ways to append data to a list.
///
/// Run benchmarks:
/// `dart run .\bin\benchmark.dart`
/// or
/// `dart compile exe .\bin\benchmark.dart -o benchmark.exe && .\benchmark.exe`
void main() =>
    Stream<Future<String> Function()>.fromIterable(<Future<String> Function()>[
      () => _measure(BytesBuilderBenchmark($chunk)),
      () => _measure(AddAllBenchmark($chunk)),
      () => _measure(SpreadBenchmark($chunk)),
      () => _measure(ConcatenationBenchmark($chunk)),
    ]).asyncMap<String>(Future<String>.new).forEach(print);

Future<String> _measure(BenchmarkBase benchmark) => Isolate.run<String>(
    () => '${benchmark.name}: ${benchmark.measure().round()} us.');

/// Concatenation: List<int> + List<int>
class ConcatenationBenchmark extends BenchmarkBase {
  ConcatenationBenchmark(Uint8List chunk)
      : _chunk = chunk,
        super('Concatenation');

  final Uint8List _chunk;
  late List<int> _buffer;

  @override
  void setup() {
    super.setup();
    _buffer = Uint8List(0);
  }

  @override
  void teardown() {
    _buffer.clear();
    super.teardown();
  }

  @override
  void exercise() {
    for (var i = 0; i < 100; i++) run();
    _buffer.last;
  }

  @override
  void run() => _buffer += _chunk;
}

/// Spread: [...List<int>, ...List<int>]
class SpreadBenchmark extends BenchmarkBase {
  SpreadBenchmark(Uint8List chunk)
      : _chunk = chunk,
        super('Spread');

  final Uint8List _chunk;

  late List<int> _buffer;

  @override
  void setup() {
    super.setup();
    _buffer = Uint8List(0);
  }

  @override
  void teardown() {
    _buffer.clear();
    super.teardown();
  }

  @override
  void exercise() {
    for (var i = 0; i < 100; i++) run();
    _buffer.last;
  }

  @override
  void run() => _buffer = <int>[..._buffer, ..._chunk];
}

/// AddAll: List<int>.addAll(List<int>)
class AddAllBenchmark extends BenchmarkBase {
  AddAllBenchmark(Uint8List chunk)
      : _chunk = chunk,
        super('AddAll');

  final Uint8List _chunk;

  late List<int> _buffer;

  @override
  void setup() {
    super.setup();
    _buffer = List.empty(growable: true);
  }

  @override
  void teardown() {
    _buffer.clear();
    super.teardown();
  }

  @override
  void exercise() {
    for (var i = 0; i < 100; i++) run();
    _buffer.last;
  }

  @override
  void run() => _buffer.addAll(_chunk);
}

/// BytesBuilder: BytesBuilder.add(List<int>)
class BytesBuilderBenchmark extends BenchmarkBase {
  BytesBuilderBenchmark(Uint8List chunk)
      : _chunk = chunk,
        super('BytesBuilder');

  final Uint8List _chunk;

  late BytesBuilder _buffer;

  @override
  void setup() {
    super.setup();
    _buffer = BytesBuilder(copy: true);
  }

  @override
  void teardown() {
    _buffer.clear();
    super.teardown();
  }

  @override
  void exercise() {
    for (var i = 0; i < 100; i++) run();
    _buffer.takeBytes();
  }

  @override
  void run() => _buffer.add(_chunk);
}