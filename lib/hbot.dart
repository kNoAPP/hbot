import 'dart:io';

import 'package:hbot/src/phrase_generator.dart';
import 'package:nyxx/nyxx.dart';

Future<void> startBot({
  required String token,
  required File phrasesFile,
}) async {
  final bot =
      NyxxFactory.createNyxxWebsocket(token, GatewayIntents.allUnprivileged)
        ..registerPlugin(Logging())
        ..registerPlugin(CliIntegration())
        ..registerPlugin(IgnoreExceptions())
        ..connect();

  final phraseGenerator = await PhraseGenerator.fromFile(phrasesFile);

  // Listen for message events
  bot.eventsWs.onMessageReceived.listen((event) async {
    final hRole = (await event.message.guild!.getOrDownload())
        .roles
        .entries
        .firstWhere((element) => element.key.id == 421563234651471872)
        .value;
    if (event.message.content == '!h') {
      String phrase = phraseGenerator
          .generatePhrase()
          .replaceAll('%name%', '@${event.message.author.username}');
      event.message.channel
          .sendMessage(MessageBuilder.content(phrase)..appendMention(hRole));
    }
  });
}
