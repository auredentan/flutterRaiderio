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
