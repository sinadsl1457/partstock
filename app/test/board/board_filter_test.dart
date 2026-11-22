// 필터 규칙: 고른 값과 맞는 종목만, 안 고르면 전체, 저장본은 지금 정의에 맞춰 읽는다.
import 'package:flutter_test/flutter_test.dart';
import 'package:partstock/features/board/data/board_filter.dart';
import 'package:partstock/features/market/data/market_models.dart';

import '../helpers/fixtures.dart';

void main() {
  final gpu = boardFixture().items;
  final ram = boardFixture('board_ram').items;
  final cpu = boardFixture('board_cpu').items;
  final ssd = boardFixture('board_ssd').items;

  test('VGA는 처음에 전체, 시리즈를 고르면 그 시리즈만', () {
    final all = initialFilter(Category.gpu);
    expect(gpu.where((i) => matchesFilter(i, all)).length, gpu.length);
    final rtx40 = gpu
        .where(
          (i) => matchesFilter(i, {
            'series': {'RTX40'},
          }),
        )
        .map((i) => i.key);
    expect(rtx40, ['rtx-4090', 'rtx-4070']);
  });

  test('RAM은 처음에 1개짜리만, DDR5·2개 묶음으로 바꿀 수 있다', () {
    final first = ram.where((i) => matchesFilter(i, initialFilter(Category.ram))).map((i) => i.key);
    expect(first, everyElement(isNot(contains('2x'))));
    expect(first, hasLength(7));
    final kits = ram
        .where(
          (i) => matchesFilter(i, {
            'ddr': {'DDR5'},
            'pack': {'2'},
          }),
        )
        .map((i) => i.key);
    expect(kits, ['ddr5-2x16gb', 'ddr5-2x32gb', 'ddr5-2x48gb', 'ddr5-2x8gb']);
  });

  test('바꾼 묶음 수: 처음 값과 다른 것만 센다', () {
    expect(changedCount(Category.ram, initialFilter(Category.ram)), 0);
    expect(
      changedCount(Category.ram, {
        'ddr': {'DDR4'},
        'pack': {'2'},
      }),
      2,
    );
    expect(
      changedCount(Category.gpu, {
        'series': {'RTX50'},
      }),
      1,
    );
  });

  test('옛 저장본(분류 없음)은 거르지 않는다', () {
    final old = gpu.first.copyWith(facets: {});
    expect(
      matchesFilter(old, {
        'series': {'RTX40'},
      }),
      isTrue,
    );
  });

  test('저장본에 없어진 값·빈 single 묶음은 처음 값으로', () {
    final f = filterFromJson(Category.ram, {
      'ddr': ['DDR5', 'DDR3'],
      'pack': <String>[],
      'speed': ['6000'],
    });
    expect(f, {
      'ddr': {'DDR5'},
      'pack': {'1'},
    });
  });

  test('CPU는 브랜드·시리즈로: Intel 14세대만', () {
    expect(initialFilter(Category.cpu), {'brand': <String>{}, 'series': <String>{}});
    final picked = cpu
        .where(
          (i) => matchesFilter(i, {
            'brand': {'INTEL'},
            'series': {'CORE14'},
          }),
        )
        .map((i) => i.key);
    expect(picked, ['core-i9-14900k', 'core-i7-14700k', 'core-i7-14700kf', 'core-i5-14600k', 'core-i5-14400f']);
    expect(
      cpu.where(
        (i) => matchesFilter(i, {
          'brand': {'AMD'},
          'series': <String>{},
        }),
      ),
      hasLength(11),
    );
  });

  test('SSD는 용량·규격·브랜드로: 2TB NVMe Gen5', () {
    final picked = ssd.where(
      (i) => matchesFilter(i, {
        'capacity': {'2TB'},
        'iface': {'NVME5'},
        'brand': <String>{},
      }),
    );
    expect(picked.map((i) => i.name), ['Samsung 9100 PRO 2TB', 'WD Black SN8100 2TB', 'Crucial T705 2TB']);
  });
}
