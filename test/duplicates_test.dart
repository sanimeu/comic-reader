import 'dart:async';
import 'package:comic_reader/domain/duplicates.dart';
import 'package:flutter_test/flutter_test.dart';

FileFingerprint _f(int id, int size, String hash) =>
    FileFingerprint(id: id, path: 'f$id', sizeBytes: size, partialHash: hash);

/// In-memory opener. Each file is served in the chunk sizes given, so tests can
/// prove comparison does not depend on chunk boundaries.
class _FakeOpener implements ByteStreamOpener {
  _FakeOpener(this.data, {this.chunk = 3});
  final Map<int, List<int>> data;
  final int chunk;
  @override
  Stream<List<int>> open(FileFingerprint file) async* {
    final bytes = data[file.id]!;
    for (var i = 0; i < bytes.length; i += chunk) {
      yield bytes.sublist(
        i,
        (i + chunk) > bytes.length ? bytes.length : i + chunk,
      );
    }
  }
}

void main() {
  test(
    'candidates: same size + same partial hash only; singletons dropped',
    () {
      final groups = findDuplicateCandidates([
        _f(1, 100, 'h1'),
        _f(2, 100, 'h1'),
        _f(3, 100, 'h2'),
        _f(4, 200, 'h1'),
      ]);
      expect(groups.length, 1);
      expect(groups.single.map((e) => e.id).toSet(), {1, 2});
    },
  );

  test('streamsEqual: equal across different chunk boundaries', () async {
    final a = Stream<List<int>>.fromIterable([
      [1, 2],
      [3],
      [4, 5, 6],
    ]);
    final b = Stream<List<int>>.fromIterable([
      [1],
      [2, 3, 4],
      [5, 6],
    ]);
    expect(await streamsEqual(a, b), isTrue);
  });

  test('streamsEqual: detects a differing byte and differing length', () async {
    expect(
      await streamsEqual(
        Stream.fromIterable([
          [1, 2, 3],
        ]),
        Stream.fromIterable([
          [1, 2, 4],
        ]),
      ),
      isFalse,
    );
    expect(
      await streamsEqual(
        Stream.fromIterable([
          [1, 2, 3],
        ]),
        Stream.fromIterable([
          [1, 2],
        ]),
      ),
      isFalse,
    );
  });

  test(
    'streamsEqual: two empty streams are equal; empty vs non-empty is not',
    () async {
      expect(
        await streamsEqual(
          const Stream<List<int>>.empty(),
          const Stream<List<int>>.empty(),
        ),
        isTrue,
      );
      expect(
        await streamsEqual(
          const Stream<List<int>>.empty(),
          Stream.fromIterable([
            [1],
          ]),
        ),
        isFalse,
      );
    },
  );

  test(
    'confirmDuplicates: partial-hash collision with different content is NOT a duplicate',
    () async {
      final opener = _FakeOpener({
        1: [1, 2, 3, 4, 5, 6, 7],
        2: [1, 2, 3, 4, 5, 6, 7],
        3: [
          1,
          2,
          3,
          4,
          5,
          6,
          8,
        ], // same size, same (fake) partial hash, last byte differs
      });
      final candidates = findDuplicateCandidates([
        _f(1, 7, 'h'),
        _f(2, 7, 'h'),
        _f(3, 7, 'h'),
      ]);
      expect(candidates.single.length, 3);
      final confirmed = await confirmDuplicates(candidates, opener);
      expect(confirmed.length, 1);
      expect(confirmed.single.map((e) => e.id).toSet(), {1, 2});
    },
  );

  test(
    'confirmDuplicates: two separate identical pairs in one candidate group',
    () async {
      final opener = _FakeOpener({
        1: [1, 1, 1],
        2: [2, 2, 2],
        3: [1, 1, 1],
        4: [2, 2, 2],
      });
      final candidates = findDuplicateCandidates([
        _f(1, 3, 'h'),
        _f(2, 3, 'h'),
        _f(3, 3, 'h'),
        _f(4, 3, 'h'),
      ]);
      final confirmed = await confirmDuplicates(candidates, opener);
      final sets = confirmed.map((g) => g.map((e) => e.id).toSet()).toList();
      expect(sets.length, 2);
      expect(
        sets,
        containsAll([
          {1, 3},
          {2, 4},
        ]),
      );
    },
  );

  test(
    'confirmDuplicates: result is the same for every chunk size (1 byte up to larger than the file)',
    () async {
      final data = {
        1: [1, 2, 3, 4, 5, 6, 7],
        2: [1, 2, 3, 4, 5, 6, 7],
        3: [1, 2, 3, 4, 5, 6, 8],
      };
      final candidates = findDuplicateCandidates([
        _f(1, 7, 'h'),
        _f(2, 7, 'h'),
        _f(3, 7, 'h'),
      ]);
      for (final chunk in [1, 2, 3, 7, 100]) {
        final confirmed = await confirmDuplicates(
          candidates,
          _FakeOpener(data, chunk: chunk),
        );
        expect(confirmed.length, 1, reason: 'chunk=$chunk');
        expect(confirmed.single.map((e) => e.id).toSet(), {
          1,
          2,
        }, reason: 'chunk=$chunk');
      }
    },
  );

  test(
    'filesAreIdentical short-circuits on different size without opening streams',
    () async {
      final opener = _FakeOpener(const {}); // would throw if opened
      expect(
        await filesAreIdentical(_f(1, 5, 'h'), _f(2, 6, 'h'), opener),
        isFalse,
      );
    },
  );
}
