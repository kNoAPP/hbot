import 'dart:io';

import 'package:args/args.dart';
import 'package:hbot/hbot.dart';

void main(List<String> arguments) {
  final parser = ArgParser()
    ..addOption(
      'token',
      abbr: 't',
      help: 'Token to authenticate the Discord bot',
      mandatory: true,
    )
    ..addOption(
      'phrases',
      abbr: 'p',
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

  startBot(token: result['token'], phrasesFile: File(result['phrases']));
}
