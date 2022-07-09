import 'dart:io';
import 'dart:math';
import 'package:dartz/dartz.dart';

class PhraseGenerator {
  PhraseGenerator._internal(this._start);

  final _PhrasePartition _start;
  static final Random _rng = Random();

  String generatePhrase() {
    return _generatePhraseFromPartition(_start);
  }

  String _generatePhraseFromPartition(_PhrasePartition partition) {
    final length = partition.fragments.length;
    if (length == 0) {
      return "";
    }

    var randomFragment = partition.fragments[_rng.nextInt(length)];
    final stringBuffer = StringBuffer();
    for (var part in randomFragment) {
      part.fold(
        (test) => stringBuffer.write(test),
        (partition) =>
            stringBuffer.write(_generatePhraseFromPartition(partition)),
      );
    }

    return stringBuffer.toString();
  }

  static Future<PhraseGenerator> fromFile(File phraseFile) async {
    if (!phraseFile.existsSync()) {
      throw FileSystemException(
        'Phrase file does not exist.',
        phraseFile.path,
      );
    }

    Map<String, _PhrasePartition> partitions = {};
    _PhrasePartition? currentPartition;

    var lines = (await phraseFile.readAsLines()).map((e) => e.trim()).toList();
    for (var i = 0; i < lines.length; ++i) {
      final line = lines[i];
      if (line.startsWith('{')) {
        if (currentPartition != null) {
          throw FileSystemException(
            'Unexpected line number ${i + 1}. Unexpected opening brace.',
            phraseFile.path,
          );
        }

        if (i == lines.length - 1) {
          throw FileSystemException(
            'Unexpected end of file. Expected closing brace.',
            phraseFile.path,
          );
        }

        final nextLine = lines[++i];
        if (!nextLine.startsWith('<')) {
          throw FileSystemException(
            'Unexpected line number ${i + 1}. Expected opening angle bracket.',
            phraseFile.path,
          );
        }

        if (!nextLine.endsWith('>')) {
          throw FileSystemException(
            'Unexpected line number ${i + 1}. Expected closing angle bracket.',
            phraseFile.path,
          );
        }

        // Get name of partition within brackets
        final name = nextLine.substring(1, nextLine.length - 1);

        currentPartition =
            partitions.putIfAbsent(name, () => _PhrasePartition());
        continue;
      }

      if (line.startsWith('}')) {
        if (currentPartition == null) {
          throw FileSystemException(
            'Unexpected line number ${i + 1}. Unexpected closing brace.',
            phraseFile.path,
          );
        }

        currentPartition = null;
        continue;
      }

      if (currentPartition == null) {
        continue;
      }

      _PhraseFragment fragment = [];
      final splitOpen = line.split('<');
      for (var j = 0; j < splitOpen.length; ++j) {
        final fragmentLine = splitOpen[j];
        if (j == 0) {
          if (fragmentLine.isNotEmpty) {
            fragment.add(left(fragmentLine));
          }
          continue;
        }

        final splitClose = fragmentLine.split('>');
        if (splitClose.length < 2) {
          throw FileSystemException(
            'Unexpected line number ${i + 1}. Expected closing angle bracket.',
            phraseFile.path,
          );
        }

        if (splitClose.length > 2) {
          throw FileSystemException(
            'Unexpected line number ${i + 1}. Expected opening angle bracket.',
            phraseFile.path,
          );
        }

        final referencedPartition = splitClose[0];
        final text = splitClose[1];

        fragment.add(
          right(partitions.putIfAbsent(
            referencedPartition,
            () => _PhrasePartition(),
          )),
        );

        if (text.isNotEmpty) {
          fragment.add(left(text));
        }
      }
      currentPartition.fragments.add(fragment);
    }

    if (currentPartition != null) {
      throw FileSystemException(
        'Unexpected end of file. Expected closing brace.',
        phraseFile.path,
      );
    }

    if (partitions.isEmpty) {
      partitions['start'] = _PhrasePartition();
    }

    return PhraseGenerator._internal(
      partitions['start'] ?? partitions.entries.first.value,
    );
  }
}

class _PhrasePartition {
  _PhrasePartition();

  final List<_PhraseFragment> fragments = [];
}

typedef _PhraseFragment = List<Either<String, _PhrasePartition>>;
