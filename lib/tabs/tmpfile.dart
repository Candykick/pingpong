import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class HomePage extends StatelessWidget {
  HomePage({Key key}) : super(key: key);

  final List<SubscriberSeries> data = [
    SubscriberSeries(
      year: "success",
      subscribers: 96,
      barColor: charts.ColorUtil.fromDartColor(Colors.blue),
    ),
    SubscriberSeries(
      year: "fail",
      subscribers: 4,
      barColor: charts.ColorUtil.fromDartColor(Colors.red),
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SubscriberChart(
        data: data,
      ));
  }
}

class SubscriberSeries {
  final String year;
  final int subscribers;
  final charts.Color barColor;

  SubscriberSeries(
      {@required this.year,
        @required this.subscribers,
        @required this.barColor});
}

class SubscriberChart extends StatelessWidget {
  final List<SubscriberSeries> data;

  SubscriberChart({@required this.data});

  @override
  Widget build(BuildContext context) {
    List<charts.Series<SubscriberSeries, String>> series = [
      charts.Series(
        labelAccessorFn: (SubscriberSeries row, _) => '${row.year}',
        id: "Subscribers",
        data: data,
        domainFn: (SubscriberSeries series, _) => series.year,
        measureFn: (SubscriberSeries series, _) => series.subscribers,
        colorFn: (SubscriberSeries series, _) => series.barColor,
      ),
    ];

    return Container(
      height: 400,
      padding: EdgeInsets.all(20),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Text(
                "World of Warcraft Subscribers by Year",
                style: Theme.of(context).textTheme.body2,
              ),
              Expanded(
                //child: charts.BarChart(series, animate: true),
                child: charts.PieChart(series, animate: false,
                  behaviors: [
                    new charts.DatumLegend(
                      outsideJustification: charts.OutsideJustification.endDrawArea,
                      horizontalFirst: false,
                      desiredMaxRows: 2,
                      cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
                      entryTextStyle: charts.TextStyleSpec(
                          color: charts.MaterialPalette.purple.shadeDefault,
                          fontFamily: 'Georgia',
                          fontSize: 11),
                    )
                  ],
                  defaultRenderer: new charts.ArcRendererConfig(
                      arcWidth: 100,
                      arcRendererDecorators: [
                        new charts.ArcLabelDecorator(
                            labelPosition: charts.ArcLabelPosition.inside)
                      ])
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}