import 'dart:io';

import 'package:googleapis/customsearch/v1.dart';
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:hbot/src/google_image_search.dart';
import 'package:hbot/src/phrase_generator.dart';
import 'package:nyxx/nyxx.dart';

Future<void> startBot({
  required String discordToken,
  required String googleApiKey,
  required String customSearchEngine,
  required File phrasesFile,
}) async {
  final imageApi = CustomSearchApi(clientViaApiKey(googleApiKey));

  final bot = NyxxFactory.createNyxxWebsocket(
      discordToken, GatewayIntents.allUnprivileged)
    ..registerPlugin(Logging())
    ..registerPlugin(CliIntegration())
    ..registerPlugin(IgnoreExceptions())
    ..connect();

  final hBotPhraseGenerator = await PhraseGenerator.fromFile(phrasesFile);

  // Listen for message events
  bot.eventsWs.onMessageReceived.listen((event) async {
    if (event.message.content == '!h') {
      await event.message.delete();
      await event.message.channel
          .sendMessage(MessageBuilder.content(await getImage(
        imageApi: imageApi,
        customSearchEngine: customSearchEngine,
        query: 'Letter H',
      )));

      final phrase = hBotPhraseGenerator
          .generatePhrase()
          .replaceAll('%name%', '<@${event.message.author.id}>');
      final message = '$phrase <@&421563234651471872>';
      await event.message.channel.sendMessage(MessageBuilder.content(message));
    }
  });
}
