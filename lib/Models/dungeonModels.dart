import 'package:flutter/material.dart';
import 'package:raiderio_flutter/Models/characterModels.dart';

class Rankings {
  final Dungeon dungeon;
  final List<RankedGroup> rankedGroups;
  final Region region;

  Rankings.fromJson(Map<String, dynamic> jsonMap)
      : dungeon = Dungeon.fromJson(jsonMap['dungeon']),
        rankedGroups = jsonMap['rankedGroups']
            .map((group) => RankedGroup.fromJson(group))
            .toList(),
        region = Region.fromJson(jsonMap['region']);
}

class Roster {
  final Character character;
  final bool isTransfer;
  final String role;
  final Guild guild;
  final CharacterItems items;

  Roster.fromJson(Map<String, dynamic> jsonMap)
      : character = Character.fromJson(jsonMap['character']),
        isTransfer = jsonMap['isTransfer'],
        role = jsonMap['role'],
        guild =
            jsonMap["guild"] != null ? Guild.fromJson(jsonMap["guild"]) : null,
        items = jsonMap["items"] != null
            ? CharacterItems.fromJson(jsonMap["items"])
            : null;
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

class Ranks {
  final int world;
  final int realm;
  final int region;
  final double score;

  Ranks.fromJson(Map<String, dynamic> jsonMap)
      : world = jsonMap["world"],
        realm = jsonMap["realm"],
        region = jsonMap["region"],
        score = jsonMap["score"];
}

class Guild {
  final int id;
  final String faction;
  final String name;
  final String path;
  final Realm realm;
  final Region region;

  Guild.fromJson(Map<String, dynamic> jsonMap)
      : faction = jsonMap["faction"],
        name = jsonMap["name"],
        id = jsonMap["id"],
        path = jsonMap["path"],
        realm = Realm.fromJson(jsonMap["realm"]),
        region = Region.fromJson(jsonMap["region"]);
}

class Realm {
  final String altSlug;
  final int connectedRealmId;
  final int id;
  final bool isConnected;
  final String locale;
  final String name;
  final String slug;

  Realm.fromJson(Map<String, dynamic> jsonMap)
      : altSlug = jsonMap["altSlug"],
        connectedRealmId = jsonMap["connectedRealmId"],
        id = jsonMap["id"],
        isConnected = jsonMap["isConnected"],
        locale = jsonMap["locale"],
        name = jsonMap["name"],
        slug = jsonMap["slug"];
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
        keystoneRunId = jsonMap['keystone_run_id'],
        keystoneTeamId = jsonMap['keystone_team_id'],
        keystoneTimeMs = jsonMap['keystone_time_ms'],
        mythicLevel = jsonMap['mythic_level'],
        numChests = jsonMap['num_chests'],
        numModifiersActive = jsonMap['num_modifiers_active'],
        roster = jsonMap['roster']
            .map<Roster>((roster) => Roster.fromJson(roster))
            .toList(),
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

class KeystoneRun {
  final int clearTimeMs;
  final String completedAt;
  final Dungeon dungeon;
  final bool isTournamentProfile;
  final int keystoneRunId;
  final int keystoneTeamId;
  final int keystoneTimeMs;
  final int mythicLevel;
  final int numChests;
  final int numModifiersActive;
  final List<Roster> roster;
  final double score;
  final String season;
  final int timeRemainingMs;
  final List<WeeklyModifier> weeklyModifiers;

  KeystoneRun.fromJson(Map<String, dynamic> jsonMap)
      : clearTimeMs = jsonMap['clear_time_ms'],
        completedAt = jsonMap['completed_at'],
        dungeon = Dungeon.fromJson(jsonMap['dungeon']),
        isTournamentProfile = jsonMap['isTournamentProfile'],
        keystoneRunId = jsonMap['keystone_run_id'],
        keystoneTeamId = jsonMap['keystone_team_id'],
        keystoneTimeMs = jsonMap['keystone_time_ms'],
        mythicLevel = jsonMap['mythic_level'],
        numChests = jsonMap['num_chests'],
        numModifiersActive = jsonMap['num_modifiers_active'],
        roster = jsonMap['roster']
            .map<Roster>((roster) => Roster.fromJson(roster))
            .toList(),
        score = jsonMap['score'],
        season = jsonMap['season'],
        timeRemainingMs = jsonMap['time_remaining_ms'],
        weeklyModifiers = jsonMap['weekly_modifiers']
            .map<WeeklyModifier>(
                (modifier) => WeeklyModifier.fromJson(modifier))
            .toList();
}
