import 'package:haniwa/models/badge.dart';

final questCreateBadge = Badge(
  id: 'questCreate',
  name: 'クエスト作成',
  targets: {0: 10, 1: 20, 2: 50},
  texts: {
    0: 'クエストを10回作成する',
    1: 'クエストを20回作成する',
    2: 'クエストを50回作成する',
  },
);

final questClearBadge = Badge(
  id: 'questClear',
  name: 'クエストクリア',
  targets: {0: 10, 1: 20, 2: 50},
  texts: {
    0: 'クエストを10回クリアする',
    1: 'クエストを20回クリアする',
    2: 'クエストを50回クリアする',
  },
);

// TODO: 継続判定をバックエンドに移行したいので保留
final questHabitBadge = Badge(
  id: 'questHabit',
  name: 'クエスト継続クリア',
  targets: {0: 10, 1: 20, 2: 30},
  texts: {
    0: 'クエストを連続で10回クリアする',
    1: 'クエストを連続で20回クリアする',
    2: 'クエストを連続で30回クリアする',
  },
);

final timesMedalBadge = Badge(
  id: 'timesMedal',
  name: 'ブルーリボンメダル',
  targets: {0: 3, 1: 5, 2: 10},
  texts: {
    0: '銅のブルーリボンメダルを3枚ゲットする',
    1: '銀のブルーリボンメダルを5枚ゲットする',
    2: '金のブルーリボンメダルを10枚ゲットする',
  },
);

final habitMedalBadge = Badge(
  id: 'habitMedal',
  name: 'レッドリボンメダル',
  targets: {0: 3, 1: 5, 2: 10},
  texts: {
    0: '銅のレッドリボンメダルを3枚ゲットする',
    1: '銀のレッドリボンメダルを5枚ゲットする',
    2: '金のレッドリボンメダルを10枚ゲットする',
  },
);

final timesHaniwaBadge = Badge(
  id: 'timesHaniwa',
  name: 'ブルーリボンハニワ',
  targets: {0: 2, 1: 2, 2: 5},
  texts: {
    0: '銀のブルーリボンハニワを2枚ゲットする',
    1: '金のブルーリボンハニワを2枚ゲットする',
    2: '金のブルーリボンハニワを5枚ゲットする',
  },
);

final habitHaniwaBagde = Badge(
  id: 'habitHaniwa',
  name: 'レッドリボンハニワ',
  targets: {0: 2, 1: 2, 2: 5},
  texts: {
    0: '銀のレッドリボンハニワを2枚ゲットする',
    1: '金のレッドリボンハニワを2枚ゲットする',
    2: '金のレッドリボンハニワを5枚ゲットする',
  },
);
