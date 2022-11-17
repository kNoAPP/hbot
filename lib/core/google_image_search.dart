import 'dart:math';

import 'package:googleapis/customsearch/v1.dart';
import 'package:logging/logging.dart';

final _log = Logger('GoogleImageSearch');

Future<String> getImage({
  required CustomSearchApi imageApi,
  required String customSearchEngine,
  required String query,
}) async {
  final rng = Random();

  // Attempt image search three times.
  for (var i = 0; i < 3; ++i) {
    Search imageSearch;
    try {
      imageSearch = await imageApi.cse.list(
        cx: customSearchEngine,
        q: query,
        safe: 'active',
        num: 3,
        start: rng.nextInt(97) + 1,
        searchType: 'image',
        fileType: 'jpg,png,gif',
      );
    } catch (exception) {
      _log.warning('Failed to get image.', exception);
      await Future.delayed(Duration(seconds: 3));
      continue;
    }

    final imageResults = imageSearch.items;
    if (imageResults == null) {
      _log.warning('No image results for query: $query');
      await Future.delayed(Duration(microseconds: 250));
      continue;
    }

    final usableImages = imageResults.where((result) {
      final url = result.image?.thumbnailLink;
      return url != null;
    }).toList();
    if (usableImages.isEmpty) {
      _log.warning('No usable results for query: $query');
      await Future.delayed(Duration(microseconds: 250));
      continue;
    }

    return usableImages.first.image!.thumbnailLink!;
  }

  _log.severe('Failed to find image for: $query');
  throw Exception('Failed to get image.');
}
