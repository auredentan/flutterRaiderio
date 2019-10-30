import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:raiderio_flutter/Models/dungeonModels.dart';
import 'package:raiderio_flutter/Models/characterModels.dart';
import 'package:raiderio_flutter/Api/raiderio.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:developer' as developer;

class MythicPlusRunDetailsTable extends StatelessWidget {
  final KeystoneRun keystoneRun;

  MythicPlusRunDetailsTable(this.keystoneRun);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(columns: [
          DataColumn(label: Text("Role")),
          DataColumn(label: Text("Character")),
          DataColumn(label: Text("ILVL")),
          DataColumn(label: Text("HoA LVL")),
          DataColumn(label: Text("Essences")),
          DataColumn(label: Text("Azerite Powers")),
          DataColumn(label: Text("Trinkets")),
          DataColumn(label: Text("Talents"))
        ], rows: _buildRows()));
  }

  List<DataRow> _buildRows() {
    return keystoneRun.roster
        .map<DataRow>((roster) => _buildRow(roster))
        .toList();
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  ActionChip buildEssenceIcon(HeartOfAzerothEssence essence) {
    final essenceId = essence.power.id;
    final essenceIconName = essence.power.majorPowerSpell.icon;
    final essenceImageUrl =
        "https://wow.zamimg.com/images/wow/icons/small/${essenceIconName}.jpg";
    final wowHeadUrl = "https://wowhead.com/azerite-essence-power/$essenceId";

    return ActionChip(
      avatar: CircleAvatar(
        radius: 13,
        backgroundImage: NetworkImage(essenceImageUrl),
      ),
      label: Text(""),
      onPressed: () {
        _launchURL(wowHeadUrl);
      },
    );
  }

  ActionChip buildAzeritePowerIcon(AzeritePower power) {
    final spellId = power.spell.id;
    final iconName = power.spell.icon;
    final imageUrl =
        "https://wow.zamimg.com/images/wow/icons/small/$iconName.jpg";
    final wowHeadUrl = "https://wowhead.com/spell=$spellId";
    // Only tier 3 essence
    return ActionChip(
      avatar: CircleAvatar(
        radius: 13,
        backgroundImage: NetworkImage(imageUrl),
      ),
      label: Text(""),
      onPressed: () {
        _launchURL(wowHeadUrl);
      },
    );
  }

  FutureBuilder buildTrinketIcon(GearItem gearItem) {
    final itemId = gearItem.itemId;
    developer.log("${gearItem.bonuses}");
    final bonuses = gearItem.bonuses.join(":");
    developer.log("$bonuses");
    // final iconName = power.spell.icon;
    final imageUrl =
        "https://www.wowhead.com/tooltip/item/$itemId?bonus=$bonuses&ilvl=${gearItem.itemLevel}";
    final tooltip = getTooltip(imageUrl);
    final wowHeadUrl = "https://wowhead.com/item=$itemId";
    // Only tier 3 essence
    return FutureBuilder<WowheadTooltip>(
      future: tooltip,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            return ActionChip(
              avatar: CircleAvatar(
                radius: 13,
                backgroundImage: NetworkImage(
                    "https://wow.zamimg.com/images/wow/icons/small/${snapshot.data.icon}.jpg"),
              ),
              label: Text(""),
              onPressed: () {
                _launchURL(wowHeadUrl);
              },
            );
          default:
        }
      },
    );
  }

  DataRow _buildRow(Roster roster) {
    final characterName = roster.character.name;
    final characterIlvl = roster.items.itemLevelEquipped;
    final hoaIlvl = roster.items.items.neck.heartOfAzeroth.level;
    final essences = roster.items.items.neck.heartOfAzeroth.essences;
    final azeritePowersTier3 = [
      roster.items.items.shoulder.azeritePowers
          .where((i) => i.tier < 10)
          .toList(),
      roster.items.items.chest.azeritePowers.where((i) => i.tier < 10).toList(),
      roster.items.items.head.azeritePowers.where((i) => i.tier < 10).toList()
    ].expand((x) => x).toList();
    azeritePowersTier3.sort((a, b) => a.tier.compareTo(b.tier));
    azeritePowersTier3.sort(
        (a, b) => a.spell.name.toString().compareTo(b.spell.name.toString()));
    final trinkets = [roster.items.items.trinket1, roster.items.items.trinket2];

    return DataRow(cells: [
      DataCell(Text("role")),
      DataCell(Text("$characterName")),
      DataCell(Text("$characterIlvl")),
      DataCell(Text("$hoaIlvl")),
      DataCell(Row(
          children:
              essences.map<ActionChip>((e) => buildEssenceIcon(e)).toList())),
      DataCell(Row(
          children: azeritePowersTier3
              .map<ActionChip>((p) => buildAzeritePowerIcon(p))
              .toList())),
      DataCell(Row(
          children:
              trinkets.map<FutureBuilder>((e) => buildTrinketIcon(e)).toList())),
      DataCell(Text("Talents"))
    ]);
  }
}
