import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:raiderio_flutter/Tables/MythicPlusRankingsTable.dart';

void main() => initializeDateFormatting("fr_FR", null)
    .then((_) => runApp(MythicPlusRankings()));
