import 'package:flutter/material.dart';
import 'package:pingpong/data/Aiming.dart';
import 'package:pingpong/data/AimingList.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class StatisticsTab extends StatefulWidget {
  StatisticsTab({Key key}) : super(key: key);

  @override
  _StatisticsTabState createState() => _StatisticsTabState();
}

class _StatisticsTabState extends State<StatisticsTab> {

  AimingList aimingList = AimingList();

  @override
  Widget build(BuildContext context) {


    return new ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: aimingList.list.length,
        itemBuilder: (BuildContext context, int index) => EntryItem(aimingList.list[index])
    );
  }
}

// Displays one Entry. If the entry has children then it's displayed
// with an ExpansionTile.
class EntryItem extends StatelessWidget {
  const EntryItem(this.entry);
  final Entry entry;

  Widget _buildTiles(Entry root) {
    return ExpansionTile(
      key: PageStorageKey<Entry>(root),
      title: Text(root.title),
      children: root.children.map(_buildChildTiles).toList(),
    );
  }

  Widget _buildChildTiles(Aiming aiming) {
    List<charts.Series<PercentSeries, String>> seriesList = [
      charts.Series(
        labelAccessorFn: (PercentSeries row, _) => '${row.title}',
        id: "Subscribers",
        data: [
          PercentSeries(
            title: "success",
            subscribers: (aiming.percent*100).round(),
            barColor: charts.ColorUtil.fromDartColor(Colors.blue),
          ),
          PercentSeries(
            title: "fail",
            subscribers: 100-(aiming.percent*100).round(),
            barColor: charts.ColorUtil.fromDartColor(Colors.red),
          )
        ],
        domainFn: (PercentSeries series, _) => series.title,
        measureFn: (PercentSeries series, _) => series.subscribers,
        colorFn: (PercentSeries series, _) => series.barColor,
      ),
    ];

    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.black26)),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    child: Expanded(
                        child: charts.PieChart(seriesList, animate: false)
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Center(child: Text(aiming.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))),
                      Text("학습시간 : "+aiming.currentTime.toString() + "분 / " +  aiming.aimingTime.toString() + "분"),
                      Text("분량 : "+aiming.currentPage.toString() + "p / " + aiming.aimingPage.toString() + "p"),
                      Text("달성률 : "+(aiming.percent*100).toString()+"%"),
                    ],
                  )
                ]
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Memo'), //border: OutlineInputBorder(),
              textInputAction: TextInputAction.newline,
              style: TextStyle(color: Colors.black),
              keyboardType: TextInputType.text,
              key: PageStorageKey("notes_field_key"),
            )
          ]
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(entry);
  }
}

class AimingResultTile extends StatelessWidget {
  Aiming aiming;
  AimingResultTile(this.aiming);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          child: null
          //child: charts.PieChart(seriesList, animate: false,),
        ),
        Column(
          children: [
            Center(child: Text(aiming.title)),
            Text("공부시간 : "+aiming.currentTime.toString()+"분 ("+aiming.aimingTime.toString()+"분 중)"),
            Text("공부분량 : "+aiming.currentPage.toString()+"페이지 ("+aiming.aimingPage.toString()+"페이지 중)"),
            Text("달성률 : "+aiming.percent.toString()+"%"),
            Text("메모 : "+aiming.memo)
          ],
        )
      ],
    );
  }
}

class PercentSeries {
  final String title;
  final int subscribers;
  final charts.Color barColor;

  PercentSeries(
      {@required this.title,
        @required this.subscribers,
        @required this.barColor});
}