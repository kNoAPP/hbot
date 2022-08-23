import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:googleapis/customsearch/v1.dart';
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:hbot/core/google_image_search.dart';
import 'package:hbot/core/phrase_generator.dart';
import 'package:hbot/domain/h_bot_data.dart';
import 'package:nyxx/nyxx.dart';

Future<void> startBot({
  required String discordToken,
  required String googleApiKey,
  required String customSearchEngine,
  required File phrasesFile,
}) async {
  final bot = NyxxFactory.createNyxxWebsocket(
      discordToken, GatewayIntents.allUnprivileged)
    ..registerPlugin(Logging())
    ..registerPlugin(CliIntegration())
    ..registerPlugin(IgnoreExceptions());

  await bot.connect();

  final hBotData = await HBotData.load();
  final phraseGenerator = await PhraseGenerator.fromFile(phrasesFile);
  final imageApi = CustomSearchApi(clientViaApiKey(googleApiKey));

  await HDiscordBot(
          bot: bot,
          hBotData: hBotData,
          phraseGenerator: phraseGenerator,
          imageApi: imageApi,
          customSearchEngine: customSearchEngine)
      .start();
}

class HDiscordBot {
  HDiscordBot({
    required this.bot,
    required this.hBotData,
    required this.phraseGenerator,
    required this.imageApi,
    required this.customSearchEngine,
  });

  INyxxWebsocket bot;
  HBotData hBotData;
  PhraseGenerator phraseGenerator;
  CustomSearchApi imageApi;
  String customSearchEngine;

  final _rng = Random();

  Future<void> start() async {
    // Bot is not fully loaded until this completes.
    bot.eventsWs.onReady.listen((_) {
      setRandomPresence();
      Timer.periodic(Duration(hours: 2), (timer) => setRandomPresence());
    });

    bot.eventsWs.onMessageReceived.listen((event) async {
      if (event.message.content == '!h') {
        await handleHMessage(event.message);
      }
    });
  }

  final activities = [
    ActivityBuilder.watching('your epic #plays'),
    ActivityBuilder.watching('the US explode'),
    ActivityBuilder.watching('California burn'),
    ActivityBuilder.watching('Zucc watch you'),
    ActivityBuilder.watching('Jere FC charts'),
    ActivityBuilder.watching('James solo baron'),
    ActivityBuilder.watching('Grant ward bushes'),
    ActivityBuilder.watching('Josh play hentai'),
    ActivityBuilder.watching('kNo gaslight people'),
    ActivityBuilder.watching('DiamondFire'),
    ActivityBuilder.watching('Arcane'),
    ActivityBuilder.watching('puppers go woo'),
    ActivityBuilder.watching('for H pings'),
    ActivityBuilder.watching('Steve Harvey'),
    ActivityBuilder.streaming(
        'DF let\'s plays', 'https://www.twitch.tv/jeremaster104'),
    ActivityBuilder.streaming(
        'Minecraft magic', 'https://www.twitch.tv/jeremaster104'),
    ActivityBuilder.streaming(
        'free \$ giveaways', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ'),
    ActivityBuilder.streaming(
        'cute cat videos', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ'),
    ActivityBuilder.game('League of Legends'),
    ActivityBuilder.game('Legends of Runeterra'),
    ActivityBuilder.game('Apex Legends'),
    ActivityBuilder.game('Beat Saber'),
    ActivityBuilder.game('TFT with HMusic'),
    ActivityBuilder.game('with physics'),
    ActivityBuilder.game('with my own code'),
    ActivityBuilder.game('speedrun 1900s simulator'),
    ActivityBuilder.game('during work hours'),
    ActivityBuilder.listening('your conversations'),
    ActivityBuilder.listening('your music'),
    ActivityBuilder.listening('true crime podcasts'),
    ActivityBuilder.listening('my loud neighbors'),
  ];
  void setRandomPresence() {
    final activity = activities[_rng.nextInt(activities.length)];
    bot.setPresence(PresenceBuilder.of(
      status: UserStatus.online,
      activity: activity,
    ));
  }

  Future<void> handleHMessage(IMessage message) async {
    await message.delete();
    await message.channel.sendMessage(MessageBuilder.content(await getImage(
      imageApi: imageApi,
      customSearchEngine: customSearchEngine,
      query: 'Letter H',
    )));

    final phrase = phraseGenerator
        .generatePhrase()
        .replaceAll('%name%', '<@${message.author.id}>');
    await message.channel
        .sendMessage(MessageBuilder.content('$phrase <@&421563234651471872>'));

    hBotData.count++;
    await hBotData.save();
  }
}
