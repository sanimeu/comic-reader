import 'dart:async';

/// Duplicate detection contract (spec sections 11 and review item 6).
///
/// A PARTIAL hash (size + sampled head/tail blocks, computed during scanning)
/// only nominates CANDIDATES. It is never proof. A pair is reported as
/// "identical" only after [confirmDuplicates] has compared the full content.
/// The UI must label unconfirmed groups "possible duplicates".
class FileFingerprint {
  const FileFingerprint({
    required this.id,
    required this.path,
    required this.sizeBytes,
    required this.partialHash,
  });
  final int id;
  final String path;
  final int sizeBytes;
  final String partialHash;
}

/// Opens a file's bytes as a stream. Implemented per platform (dart:io on Windows,
/// SAF descriptor on Android). Tests use in-memory fakes.
abstract class ByteStreamOpener {
  Stream<List<int>> open(FileFingerprint file);
}

/// Groups files that share size and partial hash. Groups of one are dropped.
List<List<FileFingerprint>> findDuplicateCandidates(
  Iterable<FileFingerprint> files,
) {
  final buckets = <String, List<FileFingerprint>>{};
  for (final f in files) {
    buckets.putIfAbsent('${f.sizeBytes}:${f.partialHash}', () => []).add(f);
  }
  return buckets.values.where((g) => g.length > 1).toList();
}

class _Chunks {
  _Chunks(Stream<List<int>> s) : _it = StreamIterator<List<int>>(s);
  final StreamIterator<List<int>> _it;
  List<int> buf = const <int>[];
  int pos = 0;
  bool _done = false;

  Future<bool> ensure() async {
    while (pos >= buf.length) {
      if (_done) return false;
      if (!await _it.moveNext()) {
        _done = true;
        return false;
      }
      buf = _it.current;
      pos = 0;
    }
    return true;
  }

  Future<void> close() => _it.cancel();
}

/// Byte-for-byte comparison of two streams, independent of chunk boundaries.
Future<bool> streamsEqual(Stream<List<int>> a, Stream<List<int>> b) async {
  final ra = _Chunks(a), rb = _Chunks(b);
  try {
    while (true) {
      final ha = await ra.ensure();
      final hb = await rb.ensure();
      if (!ha || !hb) return ha == hb; // both ended together => equal
      final n = (ra.buf.length - ra.pos) < (rb.buf.length - rb.pos)
          ? ra.buf.length - ra.pos
          : rb.buf.length - rb.pos;
      for (var i = 0; i < n; i++) {
        if (ra.buf[ra.pos + i] != rb.buf[rb.pos + i]) return false;
      }
      ra.pos += n;
      rb.pos += n;
    }
  } finally {
    await ra.close();
    await rb.close();
  }
}

Future<bool> filesAreIdentical(
  FileFingerprint a,
  FileFingerprint b,
  ByteStreamOpener opener,
) async {
  if (a.sizeBytes != b.sizeBytes) return false;
  return streamsEqual(opener.open(a), opener.open(b));
}

/// Splits each candidate group into sets of files PROVEN identical by content.
/// Files that matched the partial hash but differ in content end up in no group.
Future<List<List<FileFingerprint>>> confirmDuplicates(
  List<List<FileFingerprint>> candidates,
  ByteStreamOpener opener,
) async {
  final confirmed = <List<FileFingerprint>>[];
  for (final group in candidates) {
    final classes = <List<FileFingerprint>>[];
    for (final f in group) {
      var placed = false;
      for (final cls in classes) {
        if (await filesAreIdentical(cls.first, f, opener)) {
          cls.add(f);
          placed = true;
          break;
        }
      }
      if (!placed) classes.add([f]);
    }
    confirmed.addAll(classes.where((c) => c.length > 1));
  }
  return confirmed;
}
