import 'package:flutter/material.dart';

class Character {
  final int id;
  final int level;
  final String faction;
  final String name;
  final String role;
  final Class classe;
  final Race race;
  final Realm realm;
  final Region region;
  final Spec spec;

  Character.fromJson(Map<String, dynamic> jsonMap)
      : id = jsonMap['id'],
        level = jsonMap['level'],
        faction = jsonMap['faction'],
        name = jsonMap['name'].toString().split("-").toList()[0],
        role = jsonMap['role'],
        classe = Class.fromJson(jsonMap['class']),
        race = Race.fromJson(jsonMap['race']),
        realm = Realm.fromJson(jsonMap['realm']),
        region = Region.fromJson(jsonMap['region']),
        spec = Spec.fromJson(jsonMap['spec']);
}

class Class {
  final int id;
  final String name;
  final String slug;

  Class.fromJson(Map<String, dynamic> jsonMap)
      : id = jsonMap['id'],
        name = jsonMap['name'],
        slug = jsonMap['slug'];
}

class Race {
  final int id;
  final String name;
  final String slug;
  final String faction;

  Race.fromJson(Map<String, dynamic> jsonMap)
      : id = jsonMap['id'],
        name = jsonMap['name'],
        slug = jsonMap['slug'],
        faction = jsonMap['faction'];
}

class Realm {
  final int id;
  final String name;
  final String slug;
  final String locale;

  Realm.fromJson(Map<String, dynamic> jsonMap)
      : id = jsonMap['id'],
        name = jsonMap['name'],
        slug = jsonMap['slug'],
        locale = jsonMap['locale'];
}

class Region {
  final String name;
  final String slug;
  final String shortName;

  Region.fromJson(Map<String, dynamic> jsonMap)
      : name = jsonMap['name'],
        slug = jsonMap['slug'],
        shortName = jsonMap['short_name'];

  DataRow toDataRow2() => DataRow(cells: [
        DataCell(Text(this.name)),
        DataCell(Text(this.slug)),
        DataCell(Text(this.shortName))
      ]);
}

class Spec {
  final int id;
  final String name;
  final String slug;

  Spec.fromJson(Map<String, dynamic> jsonMap)
      : name = jsonMap['name'],
        slug = jsonMap['slug'],
        id = jsonMap['id'];
}

class CharacterItems {
  final int artifactTraits;
  final int itemLevelEquipped;
  final int itemLevelTotal;
  final GearItems items;

  CharacterItems.fromJson(Map<String, dynamic> jsonMap)
      : artifactTraits = jsonMap['artifact_traits'],
        itemLevelEquipped = jsonMap['item_level_equipped'],
        itemLevelTotal = jsonMap["item_level_total"],
        items = GearItems.fromJson(jsonMap["items"]);
}

class GearItems {
  final GearItem back;
  final GearItem chest;
  final GearItem feet;
  final GearItem finger1;
  final GearItem finger2;
  final GearItem hands;
  final GearItem head;
  final GearItem legs;
  final GearItem mainhand;
  final GearItem neck;
  final GearItem offhand;
  final GearItem shoulder;
  final GearItem trinket1;
  final GearItem trinket2;
  final GearItem waist;
  final GearItem wrist;

  GearItems.fromJson(Map<String, dynamic> jsonMap)
      : back = GearItem.fromJson(jsonMap["back"]),
        chest = GearItem.fromJson(jsonMap["chest"]),
        feet = GearItem.fromJson(jsonMap["feet"]),
        finger1 = GearItem.fromJson(jsonMap["finger1"]),
        finger2 = GearItem.fromJson(jsonMap["finger2"]),
        hands = GearItem.fromJson(jsonMap["hands"]),
        head = GearItem.fromJson(jsonMap["head"]),
        legs = GearItem.fromJson(jsonMap["legs"]),
        mainhand = GearItem.fromJson(jsonMap["mainhand"]),
        neck = GearItem.fromJson(jsonMap["neck"]),
        offhand = jsonMap["offhand"] != null
            ? GearItem.fromJson(jsonMap["offhand"])
            : null,
        shoulder = GearItem.fromJson(jsonMap["shoulder"]),
        trinket1 = GearItem.fromJson(jsonMap["trinket1"]),
        trinket2 = GearItem.fromJson(jsonMap["trinket2"]),
        waist = GearItem.fromJson(jsonMap["waist"]),
        wrist = GearItem.fromJson(jsonMap["wrist"]);
}

class GearItem {
  final bool isAzeriteArmor;
  final bool isLegionLegendary;
  final int itemId;
  final int itemLevel;
  final int itemQuality;
  final List<dynamic> bonuses;
  final List<AzeritePower> azeritePowers;
  // final List<int> gems;
  final HeartOfAzeroth heartOfAzeroth;

  GearItem.fromJson(Map<String, dynamic> jsonMap)
      : isAzeriteArmor = jsonMap['is_azerite_armor'],
        isLegionLegendary = jsonMap['is_legion_legendary'],
        itemId = jsonMap['item_id'],
        itemLevel = jsonMap['item_level'],
        itemQuality = jsonMap['item_quality'],
        bonuses = jsonMap['bonuses'].toList(),
        azeritePowers = jsonMap["azerite_powers"]
            .map<AzeritePower>((power) => AzeritePower.fromJson(power))
            .toList(),
        // gems = jsonMap["gems"],
        heartOfAzeroth = jsonMap.containsKey("heart_of_azeroth")
            ? HeartOfAzeroth.fromJson(jsonMap["heart_of_azeroth"])
            : null;
}

class AzeritePower {
  final int id;
  final int tier;
  final Spell spell;

  AzeritePower.fromJson(Map<String, dynamic> jsonMap)
      : id = jsonMap['id'],
        tier = jsonMap['tier'],
        spell = Spell.fromJson(jsonMap["spell"]);
}

class Spell {
  final int id;
  final String icon;
  final String name;
  final int school;

  Spell.fromJson(Map<String, dynamic> jsonMap)
      : id = jsonMap['id'],
        icon = jsonMap['icon'],
        name = jsonMap['name'],
        school = jsonMap['school'];
}

class HeartOfAzeroth {
  final int level;
  final int progress;
  final int totalForLevel;
  final List<HeartOfAzerothEssence> essences;

  HeartOfAzeroth.fromJson(Map<String, dynamic> jsonMap)
      : level = jsonMap["level"],
        progress = jsonMap["progress"].round(),
        totalForLevel = jsonMap["totalForLevel"],
        essences = jsonMap["essences"]
            .map<HeartOfAzerothEssence>(
                (essence) => HeartOfAzerothEssence.fromJson(essence))
            .toList();
}

class HeartOfAzerothEssence {
  final int id;
  final int rank;
  final int slot;
  final HeartOfAzerothEssencePower power;

  HeartOfAzerothEssence.fromJson(Map<String, dynamic> jsonMap)
      : id = jsonMap["id"],
        rank = jsonMap["rank"],
        slot = jsonMap["slot"],
        power = HeartOfAzerothEssencePower.fromJson(jsonMap["power"]);
}

class HeartOfAzerothEssencePower {
  final int id;
  final int tierId;
  final HeartOfAzerothEssencePowerEssence essence;
  final HeartOfAzerothEssencePowerSpell majorPowerSpell;
  final HeartOfAzerothEssencePowerSpell minorPowerSpell;

  HeartOfAzerothEssencePower.fromJson(Map<String, dynamic> jsonMap)
      : id = jsonMap["id"],
        tierId = jsonMap["tierId"],
        essence =
            HeartOfAzerothEssencePowerEssence.fromJson(jsonMap["essence"]),
        majorPowerSpell = jsonMap["majorPowerSpell"] != null
            ? HeartOfAzerothEssencePowerSpell.fromJson(
                jsonMap["majorPowerSpell"])
            : null,
        minorPowerSpell = jsonMap["minorPowerSpell"] != null
            ? HeartOfAzerothEssencePowerSpell.fromJson(
                jsonMap["minorPowerSpell"])
            : null;
}

class HeartOfAzerothEssencePowerEssence {
  final int id;
  final String description;
  final String name;
  final String shortName;

  HeartOfAzerothEssencePowerEssence.fromJson(Map<String, dynamic> jsonMap)
      : id = jsonMap["id"],
        description = jsonMap["description"],
        name = jsonMap["name"],
        shortName = jsonMap["shortName"];
}

class HeartOfAzerothEssencePowerSpell {
  final int id;
  final String icon;
  final String name;
  final String rank;
  final int school;

  HeartOfAzerothEssencePowerSpell.fromJson(Map<String, dynamic> jsonMap)
      : id = jsonMap["id"],
        icon = jsonMap["icon"],
        name = jsonMap["name"],
        rank = jsonMap["rank"] != null ? jsonMap["rank"] : null,
        school = jsonMap["school"];
}

class WowheadTooltip {
  final String icon;
  final String name;
  final int quality;
  final String tooltip;

  WowheadTooltip.fromJson(Map<String, dynamic> jsonMap)
      : icon = jsonMap["icon"],
        name = jsonMap["name"],
        quality = jsonMap["quality"],
        tooltip = jsonMap["tooltip"];
}
