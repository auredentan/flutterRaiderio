import 'package:raiderio_flutter/CharacterModels.dart';
import 'package:flutter/material.dart';

class Rankings {
  final Dungeon dungeon;
  final List<RankedGroup> rankedGroups;
  final Region region;

  Rankings.fromJson(Map<String, dynamic> jsonMap)
      : dungeon = Dungeon.fromJson(jsonMap['dungeon']),
        rankedGroups =
            jsonMap['rankedGroups'].map((group) => RankedGroup.fromJson(group)).toList(),
        region = Region.fromJson(jsonMap['region']);
}

class Roster {
  final Character character;
  final bool isTransfer;
  final String role;

  Roster.fromJson(Map<String, dynamic> jsonMap)
      : character = Character.fromJson(jsonMap['character']),
        isTransfer = jsonMap['isTransfer'],
        role = jsonMap['role'];
}

class RankedGroup {
  final int rank;
  final double score;
  final DungeonRun run;

  RankedGroup.fromJson(Map<String, dynamic> jsonMap)
      : rank = jsonMap['rank'],
        score = jsonMap['score'],
        run = DungeonRun.fromJson(jsonMap['run']);
}

class DungeonRun {
  final int clearTimeMs;
  final String completedAt;
  final Dungeon dungeon;
  final String faction;
  final int keystoneRunId;
  final int keystoneTeamId;
  final int keystoneTimeMs;
  final int mythicLevel;
  final int numChests;
  final int numModifiersActive;
  final List<Roster> roster;
  final String season;
  final int timeRemainingMs;

  DungeonRun.fromJson(Map<String, dynamic> jsonMap)
      : clearTimeMs = jsonMap['clear_time_ms'],
        completedAt = jsonMap['completed_at'],
        dungeon = Dungeon.fromJson(jsonMap['dungeon']),
        faction = jsonMap['faction'],
        keystoneRunId = jsonMap['keystonre_run_id'],
        keystoneTeamId = jsonMap['keystone_team_id'],
        keystoneTimeMs = jsonMap['keystone_time_ms'],
        mythicLevel = jsonMap['mythic_level'],
        numChests = jsonMap['num_chests'],
        numModifiersActive = jsonMap['num_modifiers_active'],
        roster = jsonMap['roster'].map<Roster>((roster) => Roster.fromJson(roster)).toList(),
        season = jsonMap['season'],
        timeRemainingMs = jsonMap['time_remaining_ms'];
}

class Dungeon {
  final int id;
  final int keystoneTimerMs;
  final String name;
  final String shortName;
  final String slug;

  Dungeon.fromJson(Map<String, dynamic> jsonMap)
      : id = jsonMap['id'],
        keystoneTimerMs = jsonMap['keystone_timer_ms'],
        name = jsonMap['name'],
        shortName = jsonMap['short_name'],
        slug = jsonMap['slug'];

  DataRow toDataRow() {
    return DataRow(cells: [
      DataCell(Text(this.name)),
      DataCell(Text(this.slug)),
      DataCell(Text(this.shortName))
    ]);
  }
}

class WeeklyModifier {
  final String description;
  final String icon;
  final int id;
  final String name;

  WeeklyModifier.fromJson(Map<String, dynamic> jsonMap)
      : id = jsonMap['id'],
        description = jsonMap['description'],
        name = jsonMap['name'],
        icon = jsonMap['icon'];
}
