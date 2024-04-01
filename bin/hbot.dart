import 'dart:io';

import 'package:args/args.dart';
import 'package:hbot/hbot.dart';

void main(List<String> arguments) {
  final parser = ArgParser()
    ..addOption(
      'discordToken',
      help: 'Discord token to authenticate the bot',
      mandatory: true,
    )
    ..addOption(
      'googleApiKey',
      help: 'Google API key to authenticate the image search',
      mandatory: true,
    )
    ..addOption(
      'customSearchEngine',
      help: 'Custom search engine id for the image search',
      mandatory: true,
    )
    ..addOption(
      'googleAiApiKey',
      help: 'Google AI API key to authenticate Gemini-pro model',
      mandatory: true,
    )
    ..addOption(
      'phrases',
      help: 'Relative path to the phrases file to use',
      defaultsTo: 'assets/hbot.phrases',
      mandatory: false,
    );

  ArgResults result;
  try {
    result = parser.parse(arguments);
  } on ArgParserException catch (exception) {
    print(exception.message);
    exit(1);
  }

  startBot(
    discordToken: result['discordToken'],
    googleApiKey: result['googleApiKey'],
    customSearchEngine: result['customSearchEngine'],
    googleAiApiKey: result['googleAiApiKey'],
    phrasesFile: File(result['phrases']),
  );
}
