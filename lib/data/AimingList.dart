import 'package:pingpong/data/Aiming.dart';

//공유 가능한 싱글톤 객체로 생성해야 함.
class AimingList {
  List<Entry> list;
  List<String> bigName = ["수학의 정석", "능률 VOCA", "수능특강", "모의고사", "쎈", "학교숙제", "자습"];

  static final AimingList _instance = AimingList._internal();

  factory AimingList() {
    return _instance;
  }

  AimingList._internal() { //초기화 함수
    list = [
      Entry(bigName[0], [Aiming(title: "수학의 정석 1단원", currentPage: 10, aimingPage: 40, currentTime: 30, aimingTime: 100, date: "", percent: 0.25, memo: "")]),
      Entry(bigName[1], [Aiming(title: "능률 VOCA DAY 1", currentPage: 15, aimingPage: 15, currentTime: 30, aimingTime: 30, date: "", percent: 1, memo: "")]),
      Entry(bigName[2], [Aiming(title: "수능 특강 물리 11단원", currentPage: 1, aimingPage: 35, currentTime: 5, aimingTime: 120, date: "월수", percent: 0.02, memo: "수요일에 끝내기"),
        Aiming(title: "수능 특강 화학 11단원", currentPage: 25, aimingPage: 31, currentTime: 63, aimingTime: 70, date: "화", percent: 0.8, memo: ""),
        Aiming(title: "수능 특강 국어 1단원", currentPage: 14, aimingPage: 20, currentTime: 42, aimingTime: 50, date: "", percent: 0.7, memo: ""), ]),
      Entry(bigName[3], [Aiming(title: "모의고사 1회 풀기", currentPage: 4, aimingPage: 4, currentTime: 90, aimingTime: 90, date: "금토일", percent: 1, memo: ""),
    Aiming(title: "모의고사 오답노트", currentPage: 10, aimingPage: 15, currentTime: 20, aimingTime: 30, date: "일", percent: 0.66, memo: ""), ]),
      Entry(bigName[4], [Aiming(title: "쎈 1단원", currentPage: 27, aimingPage: 272, currentTime: 90, aimingTime: 90, date: "", percent: 1, memo: ""), ]),
      Entry(bigName[5], [Aiming(title: "적분과 통계 숙제", currentPage: 0, aimingPage: 5, currentTime: 0, aimingTime: 30, date: "", percent: 0, memo: "내일까지"), ]),
      Entry(bigName[6], [Aiming(title: "자습 3시간", currentPage: 5, aimingPage: 40, currentTime: 20, aimingTime: 180, date: "월수금", percent: 0.13, memo: "화이팅!"), ]),
    ];
  }

  void appendList(int pos, Aiming aiming) {
    list[pos].children.add(aiming);
  }
}

class Entry {
  Entry(this.title, [this.children = const <Aiming>[]]);

  final String title;
  final List<Aiming> children;
}