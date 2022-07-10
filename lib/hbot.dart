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

  final hBotPhraseGenerator = await PhraseGenerator.fromFile(phrasesFile);

  // Listen for message events
  bot.eventsWs.onMessageReceived.listen((event) async {
    if (event.message.content == '!h') {
      final phrase = hBotPhraseGenerator
          .generatePhrase()
          .replaceAll('%name%', '<@${event.message.author.id}>');
      final message = '$phrase <@&421563234651471872>';
      event.message.channel.sendMessage(MessageBuilder.content(message));
      event.message.delete();
    }
  });
}
