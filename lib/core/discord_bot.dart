import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:google_generative_ai/google_generative_ai.dart';
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
  required String googleAiApiKey,
  required File phrasesFile,
}) async {
  final bot = await Nyxx.connectGateway(
    discordToken,
    GatewayIntents.all,
    options: GatewayClientOptions(
      plugins: [
        Logging(),
        CliIntegration(),
        IgnoreExceptions(),
      ],
    ),
  );

  final hBotData = await HBotData.load();
  final phraseGenerator = await PhraseGenerator.fromFile(phrasesFile);
  final imageApi = CustomSearchApi(clientViaApiKey(googleApiKey));
  final model = GenerativeModel(model: 'gemini-pro', apiKey: googleAiApiKey);

  await HDiscordBot(
    bot: bot,
    hBotData: hBotData,
    phraseGenerator: phraseGenerator,
    imageApi: imageApi,
    customSearchEngine: customSearchEngine,
    model: model,
  ).start();
}

class HDiscordBot {
  HDiscordBot({
    required this.bot,
    required this.hBotData,
    required this.phraseGenerator,
    required this.imageApi,
    required this.customSearchEngine,
    required this.model,
  });

  NyxxGateway bot;
  HBotData hBotData;
  PhraseGenerator phraseGenerator;
  CustomSearchApi imageApi;
  String customSearchEngine;
  GenerativeModel model;

  final _rng = Random();
  final _log = Logger('HDiscordBot');

  Future<void> start() async {
    // Bot is not fully loaded until this completes.
    bot.onReady.listen((_) {
      setRandomPresence();
      Timer.periodic(Duration(hours: 2), (timer) => setRandomPresence());
    });

    bot.onMessageCreate.listen((event) async {
      if (event.message.content == '!h') {
        await handleHMessage(event.message);
      }
    });
  }

  final activities = [
    ActivityBuilder(
      name: 'your epic #plays',
      type: ActivityType.watching,
    ),
    ActivityBuilder(
      name: 'the US explode',
      type: ActivityType.watching,
    ),
    ActivityBuilder(
      name: 'California burn',
      type: ActivityType.watching,
    ),
    ActivityBuilder(
      name: 'Zucc watch you',
      type: ActivityType.watching,
    ),
    ActivityBuilder(
      name: 'Jere FC charts',
      type: ActivityType.watching,
    ),
    ActivityBuilder(
      name: 'James solo baron',
      type: ActivityType.watching,
    ),
    ActivityBuilder(
      name: 'Grant ward bushes',
      type: ActivityType.watching,
    ),
    ActivityBuilder(
      name: 'Josh play hentai',
      type: ActivityType.watching,
    ),
    ActivityBuilder(
      name: 'kNo gaslight people',
      type: ActivityType.watching,
    ),
    ActivityBuilder(
      name: 'DiamondFire',
      type: ActivityType.watching,
    ),
    ActivityBuilder(
      name: 'Arcane Season 2',
      type: ActivityType.watching,
    ),
    ActivityBuilder(
      name: 'puppers go woo',
      type: ActivityType.watching,
    ),
    ActivityBuilder(
      name: 'for H pings',
      type: ActivityType.watching,
    ),
    ActivityBuilder(
      name: 'Steve Harvey',
      type: ActivityType.watching,
    ),
    ActivityBuilder(
      name: 'Steve Harvey',
      type: ActivityType.streaming,
      url: Uri.parse('https://www.twitch.tv/jeremaster104'),
    ),
    ActivityBuilder(
      name: 'Minecraft magic',
      type: ActivityType.streaming,
      url: Uri.parse('https://www.twitch.tv/jeremaster104'),
    ),
    ActivityBuilder(
      name: 'free \$ giveaways',
      type: ActivityType.streaming,
      url: Uri.parse('https://www.youtube.com/watch?v=dQw4w9WgXcQ'),
    ),
    ActivityBuilder(
      name: 'cute cat videos',
      type: ActivityType.streaming,
      url: Uri.parse('https://www.youtube.com/watch?v=dQw4w9WgXcQ'),
    ),
    ActivityBuilder(
      name: 'League of Legends',
      type: ActivityType.game,
    ),
    ActivityBuilder(
      name: 'Legends of Runeterra',
      type: ActivityType.game,
    ),
    ActivityBuilder(
      name: 'Apex Legends',
      type: ActivityType.game,
    ),
    ActivityBuilder(
      name: 'Beat Saber',
      type: ActivityType.game,
    ),
    ActivityBuilder(
      name: 'Lethal Company',
      type: ActivityType.game,
    ),
    ActivityBuilder(
      name: 'TFT',
      type: ActivityType.game,
    ),
    ActivityBuilder(
      name: 'Outer Wilds',
      type: ActivityType.game,
    ),
    ActivityBuilder(
      name: 'with physics',
      type: ActivityType.game,
    ),
    ActivityBuilder(
      name: 'with my own code',
      type: ActivityType.game,
    ),
    ActivityBuilder(
      name: 'speedrun 1900s simulator',
      type: ActivityType.game,
    ),
    ActivityBuilder(
      name: 'during work hours',
      type: ActivityType.game,
    ),
    ActivityBuilder(
      name: 'your conversations',
      type: ActivityType.listening,
    ),
    ActivityBuilder(
      name: 'your music',
      type: ActivityType.listening,
    ),
    ActivityBuilder(
      name: 'true crime podcasts',
      type: ActivityType.listening,
    ),
    ActivityBuilder(
      name: 'my loud neighbors',
      type: ActivityType.listening,
    ),
  ];

  void setRandomPresence() {
    final activity = activities[_rng.nextInt(activities.length)];
    bot.updatePresence(PresenceBuilder(
      status: CurrentUserStatus.online,
      isAfk: false,
      activities: [activity],
    ));
  }

  Future<void> handleHMessage(Message message) async {
    _log.info('Handling h message from ${message.author.username}');

    await message.delete();

    final response = await model.generateContent([
      Content.text(
        'Tell me an interesting fact about today\'s date in history.',
      )
    ], safetySettings: [
      for (final category in [
        HarmCategory.harassment,
        HarmCategory.hateSpeech,
        HarmCategory.sexuallyExplicit,
        HarmCategory.dangerousContent,
      ])
        SafetySetting(category, HarmBlockThreshold.none),
    ]);

    final phrase = response.text ?? 'H now or else.';

    await message.channel.sendMessage(MessageBuilder(
      content: await getImage(
        imageApi: imageApi,
        customSearchEngine: customSearchEngine,
        query: phrase,
      ),
    ));

    await message.channel.sendMessage(MessageBuilder(
      content: '$phrase <@${message.author.id}> <@&421563234651471872>',
    ));

    hBotData.count++;
    await hBotData.save();

    if (hBotData.count % 100 == 0) {
      await message.channel.sendMessage(MessageBuilder(
        content:
            'This is the ${hBotData.count}th H ping since April 5th, 2019. Crazy!',
      ));
    }
  }
}
