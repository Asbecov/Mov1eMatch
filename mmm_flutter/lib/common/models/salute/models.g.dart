// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NavigationCommand _$NavigationCommandFromJson(Map<String, dynamic> json) =>
    NavigationCommand(
      command: $enumDecode(_$NavCommandEnumMap, json['command']),
    );

Map<String, dynamic> _$NavigationCommandToJson(NavigationCommand instance) =>
    <String, dynamic>{
      'command': _$NavCommandEnumMap[instance.command]!,
    };

const _$NavCommandEnumMap = {
  NavCommand.up: 'UP',
  NavCommand.down: 'DOWN',
  NavCommand.left: 'LEFT',
  NavCommand.right: 'RIGHT',
};

AppState _$AppStateFromJson(Map<String, dynamic> json) => AppState(
      routingState: json['routingState'] as String,
    );

Map<String, dynamic> _$AppStateToJson(AppState instance) => <String, dynamic>{
      'routingState': instance.routingState,
    };

AddFilmCommand _$AddFilmCommandFromJson(Map<String, dynamic> json) =>
    AddFilmCommand(
      json['film'] as String?,
    );

Map<String, dynamic> _$AddFilmCommandToJson(AddFilmCommand instance) =>
    <String, dynamic>{
      'film': instance.film,
    };

StartSessionCommand _$StartSessionCommandFromJson(Map<String, dynamic> json) =>
    StartSessionCommand();

Map<String, dynamic> _$StartSessionCommandToJson(
        StartSessionCommand instance) =>
    <String, dynamic>{};

CloseSessionCommand _$CloseSessionCommandFromJson(Map<String, dynamic> json) =>
    CloseSessionCommand();

Map<String, dynamic> _$CloseSessionCommandToJson(
        CloseSessionCommand instance) =>
    <String, dynamic>{};

ReturnCreateCommand _$ReturnCreateCommandFromJson(Map<String, dynamic> json) =>
    ReturnCreateCommand();

Map<String, dynamic> _$ReturnCreateCommandToJson(
        ReturnCreateCommand instance) =>
    <String, dynamic>{};
