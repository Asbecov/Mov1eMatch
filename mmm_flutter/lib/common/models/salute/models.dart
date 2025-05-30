import "package:json_annotation/json_annotation.dart";

part 'models.g.dart';

@JsonEnum()
enum NavCommand {
  @JsonValue("UP")
  up,
  @JsonValue("DOWN")
  down,
  @JsonValue("LEFT")
  left,
  @JsonValue("RIGHT")
  right,
}

@JsonSerializable()
class NavigationCommand {
  final NavCommand command;

  NavigationCommand({required this.command});

  factory NavigationCommand.fromJson(Map<String, dynamic> json) =>
      _$NavigationCommandFromJson(json);
  Map<String, dynamic> toJson() => _$NavigationCommandToJson(this);
}

@JsonSerializable()
class AppState {
  final String routingState;

  AppState({required this.routingState});

  factory AppState.fromJson(Map<String, dynamic> json) =>
      _$AppStateFromJson(json);
  Map<String, dynamic> toJson() => _$AppStateToJson(this);
}

abstract class BaseCommand {
  factory BaseCommand.fromJson(Map<String, dynamic> json) {
    switch (json['command']) {
      case 'add_film':
        return AddFilmCommand.fromJson(json);
      case 'open_session':
        return StartSessionCommand.fromJson(json);
      case 'end_session':
        return CloseSessionCommand.fromJson(json);
      case 'return_create':
        return ReturnCreate.fromJson(json);
      case 'help':
        return HelpCommand.fromJson(json);
      default:
        throw Exception('Unknown command type: ${json['command']}');
    }
  }
}

@JsonSerializable()
class AddFilmCommand implements BaseCommand {
  final String? film;

  AddFilmCommand(this.film);

  factory AddFilmCommand.fromJson(Map<String, dynamic> json) =>
      _$AddFilmCommandFromJson(json);
  Map<String, dynamic> toJson() => _$AddFilmCommandToJson(this);
}

@JsonSerializable()
class StartSessionCommand implements BaseCommand {
  StartSessionCommand();

  factory StartSessionCommand.fromJson(Map<String, dynamic> json) =>
      _$StartSessionCommandFromJson(json);
  Map<String, dynamic> toJson() => _$StartSessionCommandToJson(this);
}

@JsonSerializable()
class CloseSessionCommand implements BaseCommand {
  CloseSessionCommand();

  factory CloseSessionCommand.fromJson(Map<String, dynamic> json) =>
      _$CloseSessionCommandFromJson(json);
  Map<String, dynamic> toJson() => _$CloseSessionCommandToJson(this);
}

@JsonSerializable()
class HelpCommand implements BaseCommand {
  HelpCommand();

  factory HelpCommand.fromJson(Map<String, dynamic> json) =>
      _$HelpCommandFromJson(json);
  Map<String, dynamic> toJson() => _$HelpCommandToJson(this);
}

@JsonSerializable()
class ReturnCreate implements BaseCommand {
  ReturnCreate();

  factory ReturnCreate.fromJson(Map<String, dynamic> json) =>
      _$ReturnCreateFromJson(json);
  Map<String, dynamic> toJson() => _$ReturnCreateToJson(this);
}
