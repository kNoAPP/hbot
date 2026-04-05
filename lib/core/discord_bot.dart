import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:googleapis/customsearch/v1.dart';
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:hbot/core/google_image_search.dart';
import 'package:hbot/core/phrase_generator.dart';
import 'package:hbot/domain/h_bot_data.dart';
import 'package:intl/intl.dart';
import 'package:nyxx/nyxx.dart';

Future<void> startBot({
  required String discordToken,
  required String googleApiKey,
  required String customSearchEngine,
  required File phrasesFile,
}) async {
  final bot = await Nyxx.connectGateway(
    discordToken,
    GatewayIntents.all,
    options: GatewayClientOptions(
      plugins: [Logging(), CliIntegration(), IgnoreExceptions()],
    ),
  );

  final hBotData = await HBotData.load();
  final phraseGenerator = await PhraseGenerator.fromFile(phrasesFile);
  final imageApi = CustomSearchApi(clientViaApiKey(googleApiKey));
  final model = GenerativeModel(
    model: 'gemini-2.5-flash-lite',
    apiKey: googleApiKey,
  );

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

  static const _hCommand = 'h';
  static const _hSetCommand = 'hset';

  final _rng = Random();
  final _log = Logger('HDiscordBot');

  Future<void> start() async {
    // Bot is not fully loaded until this completes.
    bot.onReady.listen((_) {
      setRandomPresence();
      Timer.periodic(Duration(hours: 2), (timer) => setRandomPresence());
    });

    // Register slash commands.
    await bot.commands.bulkOverride([
      ApplicationCommandBuilder.chatInput(
        name: _hCommand,
        description: 'Summon the gamers!',
        options: [
          CommandOptionBuilder.role(
            name: 'role1',
            description: 'Optional role to ping instead of H-Gang',
          ),
          CommandOptionBuilder.role(
            name: 'role2',
            description: 'Optional additional role to ping',
          ),
          CommandOptionBuilder.role(
            name: 'role3',
            description: 'Optional additional role to ping',
          ),
        ],
      ),
      ApplicationCommandBuilder.chatInput(
        name: _hSetCommand,
        description: 'Set the role to ping with /h',
        defaultMemberPermissions: Permissions.administrator,
        options: [
          CommandOptionBuilder.role(
            name: 'role',
            description: 'The role to ping',
            isRequired: true,
          ),
        ],
      ),
    ]);

    bot.onApplicationCommandInteraction.listen((event) async {
      switch (event.interaction.data.name) {
        case _hCommand:
          await handleHInteraction(event.interaction);
        case _hSetCommand:
          await handleHSetInteraction(event.interaction);
      }
    });
  }

  final activities = [
    ActivityBuilder(name: 'your epic #plays', type: ActivityType.watching),
    ActivityBuilder(name: 'the US explode', type: ActivityType.watching),
    ActivityBuilder(name: 'California burn', type: ActivityType.watching),
    ActivityBuilder(name: 'Zucc watch you', type: ActivityType.watching),
    ActivityBuilder(name: 'Jere FC charts', type: ActivityType.watching),
    ActivityBuilder(name: 'James solo baron', type: ActivityType.watching),
    ActivityBuilder(name: 'Grant ward bushes', type: ActivityType.watching),
    ActivityBuilder(name: 'Josh play hentai', type: ActivityType.watching),
    ActivityBuilder(name: 'kNo gaslight people', type: ActivityType.watching),
    ActivityBuilder(name: 'DiamondFire', type: ActivityType.watching),
    ActivityBuilder(name: 'Arcane Season 2', type: ActivityType.watching),
    ActivityBuilder(name: 'puppers go woo', type: ActivityType.watching),
    ActivityBuilder(name: 'for H pings', type: ActivityType.watching),
    ActivityBuilder(name: 'Steve Harvey', type: ActivityType.watching),
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
    ActivityBuilder(name: 'League of Legends', type: ActivityType.game),
    ActivityBuilder(name: 'Legends of Runeterra', type: ActivityType.game),
    ActivityBuilder(name: 'Apex Legends', type: ActivityType.game),
    ActivityBuilder(name: 'Beat Saber', type: ActivityType.game),
    ActivityBuilder(name: 'Lethal Company', type: ActivityType.game),
    ActivityBuilder(name: 'TFT', type: ActivityType.game),
    ActivityBuilder(name: 'Outer Wilds', type: ActivityType.game),
    ActivityBuilder(name: 'with physics', type: ActivityType.game),
    ActivityBuilder(name: 'with my own code', type: ActivityType.game),
    ActivityBuilder(name: 'speedrun 1900s simulator', type: ActivityType.game),
    ActivityBuilder(name: 'during work hours', type: ActivityType.game),
    ActivityBuilder(name: 'your conversations', type: ActivityType.listening),
    ActivityBuilder(name: 'your music', type: ActivityType.listening),
    ActivityBuilder(name: 'true crime podcasts', type: ActivityType.listening),
    ActivityBuilder(name: 'my loud neighbors', type: ActivityType.listening),
  ];

  void setRandomPresence() {
    final activity = activities[_rng.nextInt(activities.length)];
    bot.updatePresence(
      PresenceBuilder(
        status: CurrentUserStatus.online,
        isAfk: false,
        activities: [activity],
      ),
    );
  }

  Future<void> handleHInteraction(
    ApplicationCommandInteraction interaction,
  ) async {
    final user = interaction.member?.user ?? interaction.user;
    final channel = await interaction.channel!.get() as TextChannel;
    _log.info('Handling /$_hCommand command from ${user?.username}');

    // Collect any optional role overrides from the command options.
    final roleIds = <String>[
      for (final option in interaction.data.options ?? [])
        if (option.name.startsWith('role') && option.value != null)
          option.value.toString(),
    ];

    // Fall back to the default H-Gang role if none were provided.
    if (roleIds.isEmpty) {
      if (hBotData.roleId == null) {
        await interaction.respond(
          MessageBuilder(
            content:
                'No H-Gang role set! Use /$_hSetCommand to configure one first.',
            flags: MessageFlags.ephemeral,
          ),
        );
        return;
      }
      roleIds.add(hBotData.roleId!);
    }

    // Acknowledge immediately since the response may take time.
    await interaction.respond(
      MessageBuilder(content: ':thumbsup:', flags: MessageFlags.ephemeral),
    );

    // Hack for PST timezone
    final date = DateFormat(
      'MMMM d',
    ).format(DateTime.now().subtract(Duration(hours: 8)));

    final response = await model.generateContent(
      [
        Content.text(
          'Tell me an interesting fact about today\'s date ($date) in history.',
        ),
      ],
      safetySettings: [
        for (final category in [
          HarmCategory.harassment,
          HarmCategory.hateSpeech,
          HarmCategory.sexuallyExplicit,
          HarmCategory.dangerousContent,
        ])
          SafetySetting(category, HarmBlockThreshold.none),
      ],
    );

    final phrase = response.text ?? 'H now or else.';

    final imageUrl = await getImage(
      imageApi: imageApi,
      customSearchEngine: customSearchEngine,
      query: phrase,
    );

    // Respond to the interaction with the image.
    await channel.sendMessage(MessageBuilder(content: imageUrl));

    // Send the phrase + mentions as a regular channel message so role pings
    // actually notify users (interaction responses suppress role mentions).
    final roleMentions = roleIds.map((id) => '<@&$id>').join(' ');
    await channel.sendMessage(
      MessageBuilder(content: '$phrase <@${user?.id}> $roleMentions'),
    );

    hBotData.count++;
    await hBotData.save();

    if (hBotData.count % 100 == 0) {
      await channel.sendMessage(
        MessageBuilder(
          content:
              'This is the ${hBotData.count}th H ping since April 5th, 2019. Crazy!',
        ),
      );
    }
  }

  Future<void> handleHSetInteraction(
    ApplicationCommandInteraction interaction,
  ) async {
    final roleOption = interaction.data.options?.firstWhere(
      (o) => o.name == 'role',
    );
    final roleId = switch (roleOption?.value) {
      final String s => Snowflake.parse(s),
      final Snowflake s => s,
      _ => null,
    };

    if (roleId == null) {
      await interaction.respond(
        MessageBuilder(
          content: 'Please provide a role.',
          flags: MessageFlags.ephemeral,
        ),
      );
      return;
    }

    hBotData.roleId = roleId.toString();
    await hBotData.save();

    await interaction.respond(
      MessageBuilder(
        content: 'H-Gang role set to <@&$roleId>!',
        flags: MessageFlags.ephemeral,
      ),
    );
  }
}
