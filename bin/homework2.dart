import 'dart:math';
import 'dart:io';

class Game {
  late Object character; // 캐릭터 객체 선언 => 왜 필요한지 아직 잘 모르겠음
  List<Monster> monstersList = []; // 몬스터 리스트
  int get leftMonsters => // 남은 몬스터 수 확인 변수
      monstersList.length; // getter 를 사용하여 리스트 길이가 변할때 직접 참조 가능.

  // 게임 시작 함수
  void startGame() {
    // 캐릭터와 몬스터의 스탯을 파일에서 읽어옴
  }

  // 전투 진행 함수
  void battle() {}

  // 랜덤으로 몬스터 불러옴
  void getRandomMonster() {}
}

// 몬스터 클래스
class Monster {
  String name;
  int health;
  int attack = 0;
  int defense;

  Monster(this.name, this.health, this.attack, this.defense);

  // 캐릭터에게 공격
  attackCharacter(Character character()) {}

  // 몬스터의 현재 체력, 공격력을 턴마다 출력하기 위한 함수
  void showStatus() {}
}

// 캐릭터 클래스
class Character {
  String name;
  int health;
  int attack;
  int defense;

  //캐릭터 생성자
  Character(this.name, this.health, this.attack, this.defense);

  // 몬스터 공격 행동
  attackMonster(Monster monster) {}
  // 방어 시 특정 행동 (몬스터가 입힌 데미지만큼 캐릭터 체력 상승)
  void defend() {}
  // 캐릭터의 현재 체력, 공격력, 방어력을 턴마다 출력하기 위한 함수
  void showStatus() {}
}

void main() {
  Game game = Game();
  Random random = Random(); // dart math 의 랜덤 생성 클래스 선언

  // 캐릭터 이름 입력
  while (true) {
    print('게임을 시작하기 위해 아이디를 설정해 주세요');
    String? getCharacterName = stdin.readLineSync(); // 사용자 캐릭터 이름 입력 받기
    final regExp = RegExp(r'^[a-zA-Z가-힣]+$'); // 특수문자 및 숫자 제외한 영한 대소문자만 입력 가능
    try {
      if (regExp.hasMatch(getCharacterName!)) {
        //올바르게 입력 한다면
        game.startGame(); // 게임 실행
        break; // 루프 탈출
      }
    } catch (e) {
      print('유효하지 않은 아이디 입니다. 특수문자 및 숫자를 제외한 한영 대소문자만 입력해주세요');
    }
  }
}
