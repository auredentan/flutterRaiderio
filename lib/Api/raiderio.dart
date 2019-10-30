import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:raiderio_flutter/Models/dungeonModels.dart';
import 'package:raiderio_flutter/Models/characterModels.dart';

Future<List<RankedGroup>> getRankedGroups(int page,
    {String season = "season-bfa-3"}) async {
  developer.log("Getting ranked groups for season $season");
  final String url =
      "https://raider.io/api/mythic-plus/rankings/runs?region=world&season=$season&dungeon=all&strict=false&page=$page&limit=0&minMythicLevel=0&maxMythicLevel=0&eventId=0&faction=";

  final response = await http.get(url);

  if (response.statusCode == 200) {
    // If server returns an OK response, parse the JSON.
    final jsonResult = json.decode(response.body)["rankings"]["rankedGroups"];
    return jsonResult
        .map<RankedGroup>((group) => RankedGroup.fromJson(group))
        .toList();
  } else {
    // If that response was not OK, throw an error.
    throw Exception('Failed to load ranked groups');
  }
}

Future<KeystoneRun> getRunDetails(String runIdentifier) async {
  developer.log("Getting run details for run $runIdentifier");
  final String url =
      "https://raider.io/api/mythic-plus/runs/season-bfa-3/$runIdentifier";

  final response = await http.get(url);

  if (response.statusCode == 200) {
    // If server returns an OK response, parse the JSON.
    final jsonResult =
        KeystoneRun.fromJson(json.decode(response.body)["keystoneRun"]);
    return jsonResult;
  } else {
    // If that response was not OK, throw an error.
    throw Exception('Failed to load ranked groups');
  }
}

Future<WowheadTooltip> getTooltip(String url) async {
  final response = await http.get(url);

  if (response.statusCode == 200) {
    // If server returns an OK response, parse the JSON.
    final jsonResult = WowheadTooltip.fromJson(json.decode(response.body));
    return jsonResult;
  } else {
    // If that response was not OK, throw an error.
    throw Exception('Failed to load ranked groups');
  }
}
