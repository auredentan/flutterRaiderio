import 'package:flutter/material.dart';
import 'dart:developer' as developer;

import 'package:raiderio_flutter/Models/dungeonModels.dart';
import 'package:raiderio_flutter/Api/raiderio.dart';
import 'package:raiderio_flutter/Tables/MythicPlusRunDetailsTable.dart';


class MythicPlusRunDetails extends StatefulWidget {
  final String runIdentifier;
  MythicPlusRunDetails(this.runIdentifier);
  @override
  MythicPlusRunDetailsState createState() => MythicPlusRunDetailsState(runIdentifier);
}

class MythicPlusRunDetailsState extends State<MythicPlusRunDetails>{
  Future<KeystoneRun> run;
  String runIdentifier;
  MythicPlusRunDetailsState(this.runIdentifier);

  @override
  void initState() {
    super.initState();
    run = getRunDetails(runIdentifier);
  }

  @override
  Widget build(BuildContext context) {
    developer.log("$context");
    return Scaffold(
      appBar: AppBar(
        title: Text("Run details"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            // Navigate back to first route when tapped. getRunDetails
            Navigator.pop(context);
          },
          child: FutureBuilder<KeystoneRun>(
            future: run,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                case ConnectionState.done:
                  return MythicPlusRunDetailsTable(snapshot.data);
                default:
              }

              // By default, show a loading spinner.
              return Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}

class MythicPlusRunDetailsWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}