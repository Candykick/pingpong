// 소목표.
class Aiming { //공부시간, 달성률, 계획시간, 공부분량, 계획분량, 달성률, 메모
  String title;
  int currentPage;
  int aimingPage;
  int currentTime; //분 단위.
  int aimingTime; //없을수도 있음.
  String date;
  double percent;
  String memo;
  String repeat;

  Aiming({this.title, this.currentPage, this.aimingPage, this.currentTime,
      this.aimingTime, this.date, this.percent, this.memo, this.repeat});
}