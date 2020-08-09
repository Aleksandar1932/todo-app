import 'package:flutter/material.dart';

class Stats extends StatefulWidget {
  @override
  _StatsState createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  @override
  Widget build(BuildContext context) {
    return Padding(
//      padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.width / 2, 0, MediaQuery.of(context).size.width / 2),
    padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
           "Statistics",
            style: Theme.of(context).textTheme.headline1,
          ),
          Divider(),
          Card(
            child: ListTile(
              title: Text("Done tasks", style: Theme.of(context).textTheme.headline2),
              leading: Icon(
                Icons.done,
                color: Colors.green,
              ),
              trailing: Text(
                "52",
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
          ),
          Card(
            child: ListTile(
              title: Text("ToDo tasks", style: Theme.of(context).textTheme.headline2),
              leading: Icon(
                Icons.assignment,
                color: Colors.purple,
              ),
              trailing: Text(
                "24",
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
          ),
          Card(
            child: ListTile(
              title: Text("Overdue tasks", style: Theme.of(context).textTheme.headline2),
              leading: Icon(
                Icons.hourglass_empty,
                color: Colors.red,
              ),
              trailing: Text(
                "4",
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
