import 'package:raiderio_flutter/Models/dungeonModels.dart';
import 'package:raiderio_flutter/Models/wowColors.dart';
import 'package:raiderio_flutter/Api/raiderio.dart';
import 'package:raiderio_flutter/Views/MythicPlusRunDetails.dart';

import 'package:flutter/material.dart';
import 'dart:developer' as developer;

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
          body: SingleChildScrollView(
              child: _buildFutureBuilder(rankedGroups, context))),
    );
  }

  FutureBuilder<List<RankedGroup>> _buildFutureBuilder(
      Future<List<RankedGroup>> rankedGroups, BuildContext context) {
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
            return _buildMythicPlusRankingTable(snapshot.data, context);
          default:
        }

        // By default, show a loading spinner.
        return Center(child: CircularProgressIndicator());
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
      List<RankedGroup> rankedGroups, BuildContext context) {
    return (PaginatedDataTable(
        header: Text("header"),
        rowsPerPage: _rowsPerPage,
        onPageChanged: _loadNewPage,
        columns: _buildMythicPlusRankingColumns(),
        source: MythicPlusRankingsTableDataSource(rankedGroups, context)));
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
}

class MythicPlusRankings extends StatefulWidget {
  @override
  MythicPlusRankingsState createState() => MythicPlusRankingsState();
}

class MythicPlusRankingsTableDataSource extends DataTableSource {
  final List<RankedGroup> rankedGroups;
  final BuildContext context;
  int _rowsSelectedCount = 0;

  MythicPlusRankingsTableDataSource(this.rankedGroups, this.context);

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
    final runIdentifier = "${rankedGroup.run.keystoneRunId}-${rankedGroup.run.mythicLevel}-${rankedGroup.run.dungeon.slug}";
    return DataRow.byIndex(index: index, cells: [
      DataCell(Text("${rankedGroup.rank}"), onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MythicPlusRunDetails(runIdentifier)),
        );
      }),
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
