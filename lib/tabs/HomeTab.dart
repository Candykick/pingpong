import 'package:flutter/material.dart';
import 'package:pingpong/data/Aiming.dart';
import 'package:pingpong/data/AimingList.dart';

class HomeTab extends StatefulWidget {
  HomeTab({Key key}) : super(key: key);

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {

  AimingList aimingList = AimingList();

  List<Color> colorList = [Colors.yellowAccent, Colors.deepOrange, Colors.cyanAccent, Colors.tealAccent,
    Colors.indigoAccent, Colors.lightGreen];

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
    return ListTile(title: Text(aiming.title));
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(entry);
  }
}

class AimingTile extends StatelessWidget {
  String aimingStr;
  Color backColor;
  AimingTile(this.aimingStr, this.backColor);

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.all(3),
      child: Container(
        height: 50,
        child: Center(child: Text(aimingStr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0,),)),
        color: backColor,
      ),
    );

    /*return new Container(
      height: 60,
      child: Text(aimingStr),
      color: backColor,
    );*/
  }
}