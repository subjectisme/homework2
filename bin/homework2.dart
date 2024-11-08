import 'dart:math';
import 'dart:io';

/// 게임 클래스
class Game {
  late Character character; // Character 타입 선언
  late Monster monster; // Monster 타입 선언
  List<Monster> monstersList = []; // 몬스터 리스트
  int get leftMonsters => // 남은 몬스터 수 확인 변수
      monstersList.length; // getter 를 사용하여 리스트 길이가 변할때 직접 참조 가능

  // 게임 시작
  void startGame() {
    getRandomMonster(); // 랜덤으로 몬스터 불러오기
    print("새로운 몬스터가 나타났습니다!"); // 몬스터 등장 메시지
    monster.showStatus(); // 불러온 몬스터의 상태 노출
    battle(); // 전투 진행
  }

  // 전투 진행
  void battle() {
    //루프시작
    while (true) {
      print('${character.name}의 턴'); // 사용자 턴 메세지
      stdout.write('행동을 선택하세요(1: 공격 2: 방어): ');
      String? inputNumber = stdin.readLineSync(); // 사용자 입력 받기
      // 스위치 구문 시작
      switch (inputNumber) {
        // 사용자가 1번을 선택하였다면 (공격)
        case '1':
          print(
              '${character.name}이(가) ${monster.name}에게  ${character.attack}의 데미지를 입혔습니다.'); // 캐릭터의 공격 메세지
          character.attackMonster(monster, character); // 캐릭터의 공격
          if (monster.health <= 0) {
            // 만약 몬스터의 체력이 0 이하로 떨어진다면
            print('${monster.name}을 물리쳤습니다!'); // 몬스터 사망 메세지
            monstersList.remove(monster); //해당 몬스터 리스트에서 제거
            return; // 루프탈출
          } else if (monster.health > 0) {
            // 만약 몬스터가 아직 살아있다면
            print('${monster.name}의 턴'); // 몬스터 턴
            print(
                '${monster.name}이(가) ${character.name}에게  ${monster.attack}의 데미지를 입혔습니다.'); // 몬스터의 공격 메세지
            monster.attackCharacter(monster, character); // 몬스터의 공격
            if (character.health > 0) {
              // 캐릭터의 체력이 0 초과한다면
              character.showStatus(); // 생성된 캐릭터 상태 노출
              monster.showStatus(); // 생성된 몬스터 상태 노출
              break;
            } else if (character.health <= 0) {
              // 캐릭터의 체력이 0 이하라면
              print('${character.name}의 체력이 0이 되어 게임에서 패배하셨습니다.'); // 패배 메세지 노출
              saveLoseResult(character); // 패배 결과 기록 여부 요청
              return; // 루프 종료
            }
          }
        // 사용자가 2번을 선택하였다면 (방어)
        case '2':
          print(
              '${character.name}이(가) 방어 태세를 취하여 ${monster.attack}만큼 체력을 얻었습니다.'); // 캐릭터 방어 메세지
          character.defend(monster, character); // 캐릭터의 방어

          print('${monster.name}의 턴'); // 몬스터 턴
          monster.attackCharacter(monster, character); // 몬스터의 공격
          print(
              '${monster.name}이(가) ${character.name}에게  ${monster.attack}의 데미지를 입혔습니다.'); // 몬스터 공격 메세지
          if (character.health > 0 && monster.health > 0) {
            // 캐릭터와 몬스터 둘다 살아있다면
            character.showStatus(); // 생성된 캐릭터 상태 노출
            monster.showStatus(); // 생성된 몬스터 상태 노출
            break;
          } else {
            // 캐릭터의 체력이 0이하라면 (몬스터의 체력이 변동될 일은 없기 때문에)
            print('${character.name}의 체력이 0이 되어 게임에서 패배하셨습니다.'); // 캐릭터 사망 메세지
            saveLoseResult(character); //패배 결과 기록 여부 요청
            return; // 루프 종료
          }

        default: // 1 또는 2를 제외한 입력이라면 루프 재시작
          print('1 또는 2 중에 선택하여 입력해주세요'); // 오류 메세지
      }
    }
  }

  // 랜덤으로 몬스터 불러옴
  void getRandomMonster() {
    Random random = Random(); // 랜덤 클래스 선언
    monster = monstersList[
        random.nextInt(monstersList.length)]; // 몬스터 리스트에서 랜덤으로 몬스터 데려오기
  }

  // 캐릭터 데이터 불러옴
  void loadCharacterStats() {
    try {
      //예외처리
      final file = File('characters.txt'); // File 객체 생성 후 텍스트 파일 접근
      final contents = file.readAsStringSync(); // 파일 내용 문자열로 읽어옴
      final stats = contents.split(','); // 파일 내용 , 로 구분하여 분리 및 stas 에 저장
      if (stats.length != 3) {
        throw FormatException(
            'Invalid character data'); // 리스트 길이가 3이 아니라면 예외 발생
      }
      // stats 리스트 내 요소 정수로 변환 및 변수에 저장
      int health = int.parse(stats[0]);
      int attack = int.parse(stats[1]);
      int defense = int.parse(stats[2]);
      // getCharacterName 함수 호출 및 name 에 저장
      String name = getCharacterName();
      // 입력받은 요소들로 Character 객체 생성 및 character 변수에 저장
      character = Character(name, health, attack, defense);
      print("게임을 시작합니다!"); // 게임 시작 알림 메시지
      character.showStatus(); // 생성된 캐릭터 상태 노출
      // 오류 발생 시 메세지 출력
    } catch (e) {
      print('캐릭터 데이터를 불러오는 데 실패했습니다: $e');
      exit(1);
    }
  }

  // 몬스터의 데이터 불러옴 + 생성된 몬스터를 몬스터 리스트 내 추가
  void loadMonsterStats() {
    try {
      final file = File('monsters.txt'); // File 객체 생성 후 텍스트 파일 접근
      final contents = file.readAsLinesSync(); // 파일 내용 리스트 형태로 읽어옴
      for (var contents2 in contents) {
        // contents 에 있는 줄 수 만큼 반복
        final stats = contents2.split(','); //파일 내용 , 로 구분하여 분리 및 contents2 에 저장
        if (stats.length != 3) {
          throw FormatException(
              'Invalid character data'); // 리스트 길이가 3이 아니라면 예외 발생
        }
        // contents2 리스트 내 문자열 요소 변수에 저장
        String name = (stats[0]);
        // contents2 리스트 내 요소 정수로 변환 및 변수에 저장
        int health = int.parse(stats[1]);
        int attack = int.parse(stats[2]);
        int defense = 0; // 파일에 방어력 데이터가 없고, 현재 방어는 0이라 가정 설정

        // 입력받은 요소들로 Monster 객체 생성 및 monsterList 리스트에 저장
        monstersList.add(Monster(name, health, attack, defense));
      }
    } catch (e) {
      // 오류 발생 시 메세지 출력
      print('몬스터 데이터를 불러오는 데 실패했습니다: $e');
      exit(1);
    }
  }

  // 캐릭터 이름 입력 요청
  String getCharacterName() {
    while (true) {
      // 루프 시작
      stdout.write('게임을 시작하기 위해 아이디를 설정해 주세요: ');
      String? characterName = stdin.readLineSync(); // 사용자 입력 받기
      final regExp = RegExp(r'^[a-zA-Z가-힣]+$'); // 예외처리 정규표현식
      if (regExp.hasMatch(characterName!)) {
        return characterName; // 올바른 형식의 입력값이라면 해당 입력값 리턴 후 루프 탈출
      } else {
        // 그 외 아래의 오류 메세지 출력 후 재입력 요청
        print('유효하지 않은 아이디 입니다. 특수문자 및 숫자를 제외한 한영문만 입력해주세요');
      }
    }
  }

  // 게임 승리 결과 저장
  void saveVictoryResult(character) {
    while (true) {
      // 루프 시작
      stdout.write('결과를 저장하시겠습니까? (y/n): '); // 사용자 입력 받기
      String? inputValue = stdin.readLineSync();
      switch (inputValue) {
        // y 선택 시
        case 'y':
          final file = File('result.txt'); // File 객체 생성 후 텍스트 파일 접근
          String result =
              '${character.name},${character.health},Vicotry'; // (캐릭터 이름, 캐릭터 체력, 승리)
          file.writeAsStringSync(result); // 기록
          return; // 루프 종료
        // n 선택 시
        case 'n':
          return; // 루프 종료
        // 오류 메세지 노출
        default:
          print('y 또는 n 중에 선택하여 입력해주세요');
      }
      // 사용자 입력 받기
    }
  }

  // 게임 실패 결과 저장
  void saveLoseResult(character) {
    // 루프 시작
    while (true) {
      stdout.write('결과를 저장하시겠습니까? (y/n): '); // 사용자 입력 받기
      String? inputValue = stdin.readLineSync();
      switch (inputValue) {
        // y 선택 시
        case 'y':
          final file = File('result.txt'); // File 객체 생성 후 텍스트 파일 접근
          String result =
              '${character.name},${character.health},Lose'; // (캐릭터 이름, 캐릭터 체력, 패배)
          file.writeAsStringSync(result); //기록
          return;
        // n 선택 시
        case 'n':
          return; // 루프 종료
        // 오류 메세지 노출
        default:
          print('y 또는 n 중에 선택하여 입력해주세요');
      }
      // 사용자 입력 받기
    }
  }
}

// 몬스터 클래스
class Monster {
  String name;
  int health;
  int attack;
  int defense;

  Monster(this.name, this.health, this.attack, this.defense);

  // 캐릭터에게 공격
  attackCharacter(Monster monster, Character character) {
    int number = character.defense - monster.attack;
    character.health = character.health - number.abs();
  }

  // 몬스터의 현재 체력, 공격력을 턴마다 출력하기 위한 함수
  void showStatus() {
    print("$name - 체력: $health, 공격력: $attack");
  }
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
  void attackMonster(Monster monster, Character character) {
    monster.health = monster.health - character.attack;
  }

  // 방어 시 특정 행동 (몬스터 데미지만큼 캐릭터 체력 상승)
  void defend(Monster monster, Character character) {
    character.health = character.health + monster.attack;
  }

  // 캐릭터의 현재 체력, 공격력, 방어력을 턴마다 출력하기 위한 함수
  void showStatus() {
    print("$name - 체력: $health, 공격력: $attack, 방어력: $defense");
  }
}

void main() {
  // 게임 객체 생성
  Game game = Game();
  // 1.캐릭터 생성하기
  game.loadCharacterStats();
  // 2.몬스터 생성 후 리스트 내 추가
  game.loadMonsterStats();
  // 3.게임 시작 (리스트 안 몬스터가 0이 될때까지)
  while (game.monstersList.isNotEmpty) {
    game.startGame();
  }
  print('축하합니다! 모든 몬스터를 물리쳤습니다.');
  // 승리 기록 여부 요청
  game.saveVictoryResult(game.character);
}
