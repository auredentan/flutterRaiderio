import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;
import 'package:intl/date_symbol_data_local.dart';
import 'package:raiderio_flutter/Color.dart';
import 'dart:convert';

import 'package:raiderio_flutter/dungeonModels.dart';

void main() => initializeDateFormatting("fr_FR", null)
    .then((_) => runApp(MythicPlusRankings()));

class MythicPlusRankingsTableDataSource extends DataTableSource {
  final List<RankedGroup> rankedGroups;
  int _rowsSelectedCount = 0;

  MythicPlusRankingsTableDataSource(this.rankedGroups);

  List<TextSpan> _formatDps(dps) {
    return dps
        .map<TextSpan>((dps) => TextSpan(
            text: dps["name"] + "  ",
            style: TextStyle(color: Color(classColors[dps["class"]]))))
        .toList();
  }

  List<Map<String, String>> _extractCharacterFromRankedGroupAndRole(
      String role, RankedGroup rankedGroup) {
    return rankedGroup.run.roster
        .where((character) => character.role == role)
        .toList()
        .map((char) =>
            {"name": char.character.name, "class": char.character.classe.slug})
        .toList();
  }

  _displayRankDetails() {
    print("Display ");
  }

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index > rankedGroups.length) {
      return null;
    }
    final rankedGroup = rankedGroups[index];
    final dungeonName = rankedGroup.run.dungeon.shortName;
    final mythicLevel = rankedGroup.run.mythicLevel;
    var clearTimeMs =
        Duration(milliseconds: rankedGroup.run.clearTimeMs).toString();
    clearTimeMs = clearTimeMs.substring(0, clearTimeMs.indexOf("."));
    final score = rankedGroup.score.toStringAsFixed(1);
    final tank =
        _extractCharacterFromRankedGroupAndRole("tank", rankedGroup)[0];
    final healer =
        _extractCharacterFromRankedGroupAndRole("healer", rankedGroup)[0];
    final dps = _extractCharacterFromRankedGroupAndRole("dps", rankedGroup);
    return DataRow.byIndex(index: index, cells: [
      DataCell(Text("${rankedGroup.rank}"), onTap: _displayRankDetails()),
      DataCell(Text("$dungeonName")),
      DataCell(Text("+$mythicLevel")),
      DataCell(Text("$clearTimeMs")),
      DataCell(Text("Affixes")),
      DataCell(Text(
        "${tank["name"]}",
        style: TextStyle(color: Color(classColors[tank["class"]])),
      )),
      DataCell(Text("${healer["name"]}",
          style: TextStyle(color: Color(classColors[healer["class"]])))),
      DataCell(
        RichText(
          text: TextSpan(
            text: "",
            children: _formatDps(dps),
          ),
        ),
      ),
      DataCell(Text("$score")),
    ]);
  }

  @override
  int get rowCount => 500 * 20; //415221*20

  @override
  int get selectedRowCount => _rowsSelectedCount;

  @override
  bool get isRowCountApproximate => false;
}

class MythicPlusRankingsState extends State<MythicPlusRankings> {
  Future<List<RankedGroup>> rankedGroups;
  int _rowsPerPage = 20;
  int currentPageNumber = 0;

  @override
  void initState() {
    super.initState();
    rankedGroups = getRankedGroups(0);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
          appBar: AppBar(
            title: Text('Mytic Plus Rankings'),
          ),
          body:
              SingleChildScrollView(child: _buildFutureBuilder(rankedGroups))),
    );
  }

  FutureBuilder<List<RankedGroup>> _buildFutureBuilder(
      Future<List<RankedGroup>> rankedGroups) {
    return FutureBuilder<List<RankedGroup>>(
      future: rankedGroups,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          case ConnectionState.done:
            return _buildMythicPlusRankingTable(snapshot.data);
          default:
        }

        // By default, show a loading spinner.
        return CircularProgressIndicator();
      },
    );
  }

  void _loadNewPage(int value) {
    final newPageNumber = currentPageNumber + 1;
    developer.log("Loading page $newPageNumber");
    setState(() {
      currentPageNumber = newPageNumber;
      rankedGroups = getRankedGroups(newPageNumber);
    });
  }

  PaginatedDataTable _buildMythicPlusRankingTable(
      List<RankedGroup> rankedGroups) {
    return (PaginatedDataTable(
        header: Text("header"),
        rowsPerPage: _rowsPerPage,
        onPageChanged: _loadNewPage,
        columns: _buildMythicPlusRankingColumns(),
        source: MythicPlusRankingsTableDataSource(rankedGroups)));
  }

  List<DataColumn> _buildMythicPlusRankingColumns() {
    return [
      DataColumn(label: const Text("Rank")),
      DataColumn(label: const Text("Dungeon")),
      DataColumn(label: const Text("Level")),
      DataColumn(label: const Text("Time")),
      DataColumn(label: const Text("Affixes")),
      DataColumn(label: const Text("Tank")),
      DataColumn(label: const Text("Healer")),
      DataColumn(label: const Text("Dps")),
      DataColumn(label: const Text("Score"))
    ];
  }

  List<DataRow> _buildMythicPlusRankingRows(List<RankedGroup> rankedGroups) {
    return rankedGroups
        .map<DataRow>((rankedGroup) => _buildMythicPlusRankingRow(rankedGroup))
        .toList();
  }

  List<Map<String, String>> _extractCharacterFromRankedGroupAndRole(
      String role, RankedGroup rankedGroup) {
    return rankedGroup.run.roster
        .where((character) => character.role == role)
        .toList()
        .map((char) =>
            {"name": char.character.name, "class": char.character.classe.slug})
        .toList();
  }

  List<TextSpan> _formatDps(dps) {
    return dps
        .map<TextSpan>((dps) => TextSpan(
            text: dps["name"] + "  ",
            style: TextStyle(color: Color(classColors[dps["class"]]))))
        .toList();
  }

  DataRow _buildMythicPlusRankingRow(RankedGroup rankedGroup) {
    final dungeonName = rankedGroup.run.dungeon.shortName;
    final mythicLevel = rankedGroup.run.mythicLevel;
    var clearTimeMs =
        Duration(milliseconds: rankedGroup.run.clearTimeMs).toString();
    clearTimeMs = clearTimeMs.substring(0, clearTimeMs.indexOf("."));
    final score = rankedGroup.score.toStringAsFixed(1);
    final tank =
        _extractCharacterFromRankedGroupAndRole("tank", rankedGroup)[0];
    final healer =
        _extractCharacterFromRankedGroupAndRole("healer", rankedGroup)[0];
    final dps = _extractCharacterFromRankedGroupAndRole("dps", rankedGroup);
    return DataRow(cells: [
      DataCell(Text("${rankedGroup.rank}")),
      DataCell(Text("$dungeonName")),
      DataCell(Text("+$mythicLevel")),
      DataCell(Text("$clearTimeMs")),
      DataCell(Text("Affixes")),
      DataCell(Text(
        "${tank["name"]}",
        style: TextStyle(color: Color(classColors[tank["class"]])),
      )),
      DataCell(Text("${healer["name"]}",
          style: TextStyle(color: Color(classColors[healer["class"]])))),
      DataCell(
        RichText(
          text: TextSpan(
            text: "",
            children: _formatDps(dps),
          ),
        ),
      ),
      DataCell(Text("$score")),
    ]);
  }
}

class MythicPlusRankings extends StatefulWidget {
  @override
  MythicPlusRankingsState createState() => MythicPlusRankingsState();
}

Future<List<RankedGroup>> getRankedGroups(int page) async {
  developer.log("Getting ranked groups");
  final String url =
      "https://raider.io/api/mythic-plus/rankings/runs?region=world&season=season-bfa-3&dungeon=all&strict=false&page=$page&limit=0&minMythicLevel=0&maxMythicLevel=0&eventId=0&faction=";

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
