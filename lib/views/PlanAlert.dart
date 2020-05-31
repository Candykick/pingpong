/*import 'package:flutter/material.dart';

class PlanDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PlanDialoggState();
  }
}

class PlanDialoggState extends State<PlanDialog> {
  String _selected = "";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: new Text("계획 세우기"),
      content: Container(
          height: 200,
          width: 600,
          child: SingleChildScrollView(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(children: [Text('대목표 : '), DropdownButton<String>(
                    hint: Text("대목표 선택"),
                    value: _selected,
                    onChanged: (value) {
                      _selected = value;
                      setState(() {
                        _selected = value;
                        for(int i=0;i<7;i++) {
                          if(value.compareTo(aimingList.bigName[i]) == 0) {
                            dropPos = i;
                          }
                        }
                      });
                    },
                    items: aimingList.bigName.map((value) {
                      return DropdownMenuItem(
                        child: Text(value),
                        value: value,
                      );
                    }).toList(),
                  )]),
                  Row(children: [Text('소목표 : '), new Expanded(child: TextField(controller: _smallPlan,))]),
                  Row(children: [Text('분량 : '), new Expanded(child: TextField(controller: _startPage, keyboardType: TextInputType.number,)), Text(' ~ '), new Expanded(child: TextField(controller: _endPage,keyboardType: TextInputType.number))],),
                  Row(children: [Text('일시 : '), new Expanded(child: TextField(controller: _startDate,keyboardType: TextInputType.number)), Text('월 '), new Expanded(child: TextField(controller: _endDate,keyboardType: TextInputType.number)),Text('일')],),
                  Row(children: [new Expanded(child: TextField(controller: _startHour,keyboardType: TextInputType.number)), Text(' : '),new Expanded(child: TextField(controller: _startMinute,keyboardType: TextInputType.number)), Text(' ~ '),new Expanded(child: TextField(controller: _endHour,keyboardType: TextInputType.number)), Text(' : '),new Expanded(child: TextField(controller: _endMinute,keyboardType: TextInputType.number))]),
                  Text('반복 : '),
                  Row(children: [MultiSelectChip(dateList, onSelectionChanged: (selectedList) {setState(() {selectedDate = selectedList;});})])
                ]
            ),
          )
      ),
      actions: <Widget>[
        new FlatButton(
          child: new Text("추가"),
          onPressed: () {
            Aiming aiming = Aiming(title: _smallPlan.text,
                aimingPage: ((int.parse(_endPage.text)) - (int.parse(_startPage.text))),
                currentPage: 0,
                aimingTime: (int.parse(_startHour.text)*60+int.parse(_startMinute.text))-(int.parse(_endHour.text)*60+int.parse(_endMinute.text)),
                currentTime: 0,
                date: _startDate.text+"월 "+_endDate.text+"일", memo: "",
                percent: 0,
                repeat: selectedDate);
            makePlan(aiming, dropPos);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

void _PlanDialog(String documentID) {
  showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return PlanDialog();
      }
  );
}
*/