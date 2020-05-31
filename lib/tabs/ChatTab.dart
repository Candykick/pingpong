import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:pingpong/data/Aiming.dart';
import 'package:pingpong/data/AimingList.dart';
import 'package:pingpong/views/MultiSelectChip.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

const String _name = "이상욱";
const chatbot_init = ["안녕, 난 핑퐁이야!\n넌 이름이 뭐니?", "아, 몇살이야?", "그렇구나!\n너의 프로필 사진을 정해줘!", "기능에 대해서 알려줄까?",
  "그래 알겠어!\n나랑 같이 열심히 계획을 세워보자!"];
const List<String> dateList = ["월","화","수","목","금",];

AimingList aimingList = AimingList();

class ChatScreen extends StatefulWidget {
  ChatScreen({Key key}) : super(key: key);

  @override
  ChatScreenState createState() => ChatScreenState();
}

// 화면 구성용 상태 위젯. 애니메이션 효과를 위해 TickerProviderStateMixin를 가짐
class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  File mPhoto;
  String dropStr = "자습";

  final List<Widget> _message = <Widget>[]; // 메세지

  // 텍스트필드 제어용 컨트롤러
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _smallPlan = TextEditingController();
  final TextEditingController _startPage = TextEditingController();
  final TextEditingController _endPage = TextEditingController();
  final TextEditingController _startDate = TextEditingController();
  final TextEditingController _endDate = TextEditingController();
  final TextEditingController _startHour = TextEditingController();
  final TextEditingController _startMinute = TextEditingController();
  final TextEditingController _endHour = TextEditingController();
  final TextEditingController _endMinute = TextEditingController();

  // 텍스트필드에 입력된 데이터의 존재 여부
  bool _isComposing = false;
  int chatbot_index = 0;
  bool _isChatbotInit = false;
  bool _isFailMission = false;
  int failBigIndex = 0, failSmallIndex = 0;
  bool _isEndTime = false;

  getBoolValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool CheckValue = prefs.containsKey('isStart');
    if(CheckValue == false) {
      chatbotSays(chatbot_init[chatbot_index]);
      _isChatbotInit = true;
      addBoolToSF(true);
    } else {
      bool boolValue = prefs.getBool('isStart');
      if(boolValue == true) {
        chatbotSays("약속한 마감시간이 다 됬어! 다 했어?");
        _isEndTime = true;
      } else {
        chatbotSays(chatbot_init[chatbot_index]);
        _isChatbotInit = true;
        addBoolToSF(true);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getBoolValuesSF();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Container(
        child: Column(
          children: <Widget>[
            // 리스트뷰를 Flexible로 추가.
            Flexible(
              // 리스트뷰 추가
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                // 리스트뷰의 스크롤 방향을 반대로 변경. 최신 메시지가 하단에 추가됨
                reverse: true,
                itemCount: _message.length,
                itemBuilder: (_, index) => _message[index],
              ),
            ),
            // 구분선
            Divider(height: 1.0),
            // 메시지 입력을 받은 위젯(_buildTextCompose)추가
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
              ),
              child: _buildTextComposer(),
            )
          ],
        ),
        // iOS의 경우 데코레이션 효과 적용
        decoration: Theme.of(context).platform == TargetPlatform.iOS
            ? BoxDecoration(
            border: Border(top: BorderSide(color: Colors.grey[200])))
            : null,
      ),
    );
  }

  // 사용자로부터 메시지를 입력받는 위젯 선언
  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              // 플랫폼 종류에 따라 적당한 버튼 추가
              child: IconButton(
                // 아이콘 버튼에 전송 아이콘 추가
                      icon: Icon(Icons.add_a_photo),
                      // 입력된 텍스트가 존재할 경우에만 _handleSubmitted 호출
                      onPressed: () => {
                        showDialog(context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: new Text("선택"),
                              content: new Text("어떤 거로 사진 업로드를 수행하시겠습니까?"),
                              actions: <Widget>[
                                new FlatButton(
                                  child: new Text("카메라"),
                                  onPressed: () {_addProfile(ImageSource.camera);
                                  Navigator.pop(context);},
                                ),
                                new FlatButton(
                                  child: new Text("앨범"),
                                  onPressed: () {_addProfile(ImageSource.gallery);
                                  Navigator.pop(context);},
                                ),
                              ],
                            );
                          })
                      }
              ),
            ),
            // 텍스트 입력 필드
            Flexible(
              child: TextField(
                controller: _textController,
                // 입력된 텍스트에 변화가 있을 때 마다
                onChanged: (text) {
                  setState(() {
                    _isComposing = text.length > 0;
                  });
                },
                // 키보드상에서 확인을 누를 경우. 입력값이 있을 때에만 _handleSubmitted 호출
                onSubmitted: _isComposing ? _handleSubmitted : null,
                // 텍스트 필드에 힌트 텍스트 추가
                decoration:
                InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            // 전송 버튼
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              // 플랫폼 종류에 따라 적당한 버튼 추가
              child: Theme.of(context).platform == TargetPlatform.iOS
                  ? CupertinoButton(
                child: Text("send"),
                onPressed: _isComposing
                    ? () => _handleSubmitted(_textController.text)
                    : null,
              )
                  : IconButton(
                // 아이콘 버튼에 전송 아이콘 추가
                icon: Icon(Icons.send),
                // 입력된 텍스트가 존재할 경우에만 _handleSubmitted 호출
                onPressed: _isComposing
                    ? () => _handleSubmitted(_textController.text)
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 메시지 전송 버튼이 클릭될 때 호출
  void _handleSubmitted(String text) {
    // 텍스트 필드의 내용 삭제
    _textController.clear();
    // _isComposing을 false로 설정
    setState(() {
      _isComposing = false;
    });
    // 입력받은 텍스트를 이용해서 리스트에 추가할 메시지 생성
    ChatMessage message = ChatMessage(
      text: text,
      isBot: false,
      // animationController 항목에 애니메이션 효과 설정
      // ChatMessage은 UI를 가지는 위젯으로 새로운 message가 리스트뷰에 추가될 때
      // 발생할 애니메이션 효과를 위젯에 직접 부여함
      animationController: AnimationController(
        duration: Duration(milliseconds: 700),
        vsync: this,
      ),
    );
    // 리스트에 메시지 추가
    setState(() {
      _message.insert(0, message);
    });
    // 위젯의 애니메이션 효과 발생
    message.animationController.forward();

    //아래부턴 챗봇을 작동시키는 코드.
    if(_isChatbotInit) { //챗봇 튜토리얼이 작동중이면
      switch(chatbot_index) {
        case 0: //이름
          chatbot_index++;
          chatbotSays(text+chatbot_init[chatbot_index]);
          break;
        case 1: //나이
          chatbot_index++;
          chatbotSays(chatbot_init[chatbot_index]);
          break;
        case 2: //사진
          chatbot_index++;
          chatbotSays(chatbot_init[chatbot_index]);
          break;
        case 3: //기능
          chatbot_index++;
          chatbotSays(chatbot_init[chatbot_index]);
          _isChatbotInit = false;
          break;
      }
    } else if(text.compareTo("계획세우기") == 0 || text.compareTo("계획 세우기") == 0) {
      chatbotSays("어떤 계획 세울거야?");
      String selectedDate = "X";
      int dropPos=0;

      showDialog(context: context,
      builder: (BuildContext context) {
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
                      value: dropStr,
                      onChanged: (value) {
                        dropStr = value;
                        setState(() {
                          dropStr = value;
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
      });
    } else if(text.contains("다 했어!")) { //목표를 끝낸 경우.
      String subtitle = text.replaceAll(" 다 했어!", "");
      chatbotSays("잘했어!");
      chatbotSays(subtitle+" 결과는\n통계배너에서 확인할 수 있어!");
      for(int i=0;i<7;i++) {
        for(int j=0;j<aimingList.list[i].children.length;j++) {
          if(aimingList.list[i].children[j].title.contains(subtitle) == 0) {
            aimingList.list[i].children[j].currentPage = aimingList.list[i].children[j].aimingPage;
            aimingList.list[i].children[j].currentTime = aimingList.list[i].children[j].aimingTime;
            aimingList.list[i].children[j].percent = 1;
          }
        }
      }
    } else if(text.contains("그만할래")) { //목표를 취소하는 경우
      chatbotSays("조금 더 해보는 게 어때?");
      _isFailMission = true;
      String subtitle = text.replaceAll(" 그만할래", "");
      for(int i=0;i<7;i++) {
        for(int j=0;j<aimingList.list[i].children.length;j++) {
          if(aimingList.list[i].children[j].title.contains(subtitle)) {
            failBigIndex = i;
            failSmallIndex = j;
          }
        }
      }
    } else if(_isFailMission == true && (text.compareTo("응")==0 || text.compareTo("네")==0 || text.compareTo("예")==0 || text.compareTo("Yes")==0 || text.compareTo("yes")==0) || text.compareTo("YES")==0) {
      chatbotSays("그래! 힘내자. 얼마 안 남았어!");
      _isFailMission = false;
    } else if(_isFailMission == true && (text.compareTo("아니오")==0 || text.compareTo("No")==0 || text.compareTo("no")==0 || text.compareTo("NO")==0)) {
      chatbotSays("알았어. 오늘은 쉬자.\n[전체 "+aimingList.list[failBigIndex].children[failSmallIndex].aimingPage.toString()
          +"페이지 중 "+aimingList.list[failBigIndex].children[failSmallIndex].currentPage.toString()+"페이지까지 함]");
      aimingList.list[failBigIndex].children.removeAt(failSmallIndex);
      _isFailMission = false;
    } else if(_isEndTime == true && (text.compareTo("응")==0 || text.compareTo("네")==0 || text.compareTo("예")==0 || text.compareTo("Yes")==0 || text.compareTo("yes")==0) || text.compareTo("YES")==0) {
      chatbotSays("잘했어!");
      chatbotSays(aimingList.list[failBigIndex].children[failSmallIndex].title+" 결과는\n통계배너에서 확인할 수 있어!");
      _isEndTime = false;
      aimingList.list[failBigIndex].children[failSmallIndex].currentPage = aimingList.list[failBigIndex].children[failSmallIndex].aimingPage;
      aimingList.list[failBigIndex].children[failSmallIndex].currentTime = aimingList.list[failBigIndex].children[failSmallIndex].aimingTime;
      aimingList.list[failBigIndex].children[failSmallIndex].percent = 1;
    } else if(_isEndTime == true && (text.compareTo("아니오")==0 || text.compareTo("No")==0 || text.compareTo("no")==0 || text.compareTo("NO")==0)) {
      chatbotSays("수고했어!\n[전체 "+aimingList.list[failBigIndex].children[failSmallIndex].aimingPage.toString()
          +"페이지 중 "+aimingList.list[failBigIndex].children[failSmallIndex].currentPage.toString()+"페이지까지 함]");
      aimingList.list[failBigIndex].children.removeAt(failSmallIndex);
      _isEndTime = false;
    } else if(text.contains("힘들어") || text.contains("위로해줘")) {
      chatbotSays("괜찮아.\n도움이 될 만한 영상을 올려줄게.");
      addLink();
    }
  }

  void makePlan(Aiming aiming, int pos) {
    setState(() {
      _isComposing = false;
    });
    // 입력받은 텍스트를 이용해서 리스트에 추가할 메시지 생성
    PlanMaker planMaker = PlanMaker(animationController: AnimationController(
      duration: Duration(milliseconds: 700),
      vsync: this,
    ), aiming: aiming, pos: pos);
    // 리스트에 메시지 추가
    setState(() {
      _message.insert(0, planMaker);
    });
    // 위젯의 애니메이션 효과 발생
    planMaker.animationController.forward();
    
    chatbotSays("좋아! 열심히 하고 와!");
  }

  @override
  void dispose() {
    // 메시지가 생성될 때마다 animationController가 생성/부여 되었으므로 모든 메시지로부터 animationController 해제
    for (ChatMessage message in _message) {
      message.animationController.dispose();
    }
    super.dispose();
  }

  void _addProfile(ImageSource source) async {
    //await 키워드 때문에 setState 안에서 호출이 불가능하다.
    File f = await ImagePicker.pickImage(source: source);
    setState(() {
      mPhoto = f;
      _handleSubmitted('사진 추가됨');
    });
  }

  // 챗봇이 메세지를 전송하는 경우
  void chatbotSays(String text) {
    // 텍스트 필드의 내용 삭제
    _textController.clear();
    // _isComposing을 false로 설정
    setState(() {
      _isComposing = false;
    });
    // 입력받은 텍스트를 이용해서 리스트에 추가할 메시지 생성
    ChatMessage message = ChatMessage(
      text: text,
      isBot: true,
      // animationController 항목에 애니메이션 효과 설정
      // ChatMessage은 UI를 가지는 위젯으로 새로운 message가 리스트뷰에 추가될 때
      // 발생할 애니메이션 효과를 위젯에 직접 부여함
      animationController: AnimationController(
        duration: Duration(milliseconds: 700),
        vsync: this,
      ),
    );
    // 리스트에 메시지 추가
    setState(() {
      _message.insert(0, message);
    });
    // 위젯의 애니메이션 효과 발생
    message.animationController.forward();
  }

  void addLink() {
    // 텍스트 필드의 내용 삭제
    _textController.clear();
    // _isComposing을 false로 설정
    setState(() {
      _isComposing = false;
    });
    // 입력받은 텍스트를 이용해서 리스트에 추가할 메시지 생성
    LinkMessage linkMessage = LinkMessage(
        animationController: AnimationController(
          duration: Duration(milliseconds: 700),
          vsync: this,
        )
    );
    // 리스트에 메시지 추가
    setState(() {
      _message.insert(0, linkMessage);
    });
    // 위젯의 애니메이션 효과 발생
    linkMessage.animationController.forward();
  }
}

class PlanMaker extends StatelessWidget {
  final AnimationController animationController; // 리스트뷰에 등록될 때 보여질 효과
  final int pos;
  final Aiming aiming;
  PlanMaker({this.animationController, this.aiming, this.pos});

  @override
  Widget build(BuildContext context) {
    aimingList.appendList(pos, aiming);

    return SizeTransition(
      sizeFactor:
      CurvedAnimation(parent: animationController, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.black45)),
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [Text('대목표 : '+aimingList.bigName[pos])]),
              Row(children: [Text('소목표 : '+aiming.title)]),
              Row(children: [Text('분량 : '+aiming.aimingPage.toString())]),
              Row(children: [Text('일시 : '+aiming.date)]),
              Row(children: [Text('반복 : ')]),
            ],
          )
        )
      )
    );
  }
}

// 리스브뷰에 추가될 메시지 위젯
class ChatMessage extends StatelessWidget {
  final String text; // 출력할 메시지
  final AnimationController animationController; // 리스트뷰에 등록될 때 보여질 효과
  final bool isBot;

  ChatMessage({this.text, this.animationController, this.isBot});

  @override
  Widget build(BuildContext context) {
    // 위젯에 애니메이션을 발생하기 위해 SizeTransition을 추가
    return SizeTransition(
      // 사용할 애니메이션 효과 설정
      sizeFactor:
      CurvedAnimation(parent: animationController, curve: Curves.easeOut),
      axisAlignment: 0.0,
      // 리스트뷰에 추가될 컨테이너 위젯
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: isBot ? <Widget>[
            Expanded(
              // 컬럼 추가
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  // 사용자명을 subhead 테마로 출력
                  Text("핑퐁이", style: Theme.of(context).textTheme.subhead),
                  // 입력받은 메시지 출력
                  Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: Text(text),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 16.0),
              // 사용자명의 첫번째 글자를 서클 아바타로 표시
              child: CircleAvatar(child: Text('핑'), backgroundColor: Colors.pink,),
            )
          ] : <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 16.0),
              // 사용자명의 첫번째 글자를 서클 아바타로 표시
              child: CircleAvatar(child: Text(_name[0])),
            ),
            Expanded(
              // 컬럼 추가
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // 사용자명을 subhead 테마로 출력
                  Text(_name, style: Theme.of(context).textTheme.subhead),
                  // 입력받은 메시지 출력
                  Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: Text(text),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class LinkMessage extends StatelessWidget {
  final AnimationController animationController; // 리스트뷰에 등록될 때 보여질 효과

  LinkMessage({this.animationController});

  @override
  Widget build(BuildContext context) {
    // 위젯에 애니메이션을 발생하기 위해 SizeTransition을 추가
    return SizeTransition(
      // 사용할 애니메이션 효과 설정
      sizeFactor:
      CurvedAnimation(parent: animationController, curve: Curves.easeOut),
      axisAlignment: 0.0,
      // 리스트뷰에 추가될 컨테이너 위젯
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              // 컬럼 추가
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  // 사용자명을 subhead 테마로 출력
                  Text("핑퐁이", style: Theme.of(context).textTheme.subhead),
                  // 입력받은 메시지 출력
                  Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: Linkify(onOpen: _onOpen, text: "공부 포기하고 싶다면 꼭 보세요\nhttps://www.youtube.com/watch?v=v5JzHnjCKj0"),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 16.0),
              // 사용자명의 첫번째 글자를 서클 아바타로 표시
              child: CircleAvatar(child: Text('핑'), backgroundColor: Colors.pink,),
            )
          ],
        ),
      ),
    );
  }
}

class ChatData {
  String text;
  bool isMyMessage;

  ChatData({this.text, this.isMyMessage});
}

addBoolToSF(bool booler) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('isStart', booler);
}

Future<void> _onOpen(LinkableElement link) async {
  //if (await canLaunch(Uri.encodeFull(link.url))) {
    await launch(Uri.encodeFull(link.url));
  //} else {
    //throw 'Could not launch $link';
  //}
}