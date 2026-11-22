// 시세 목록 필터: 분류(VGA·RAM)마다 어떤 칸(facet)으로 거르는지. 필터를 늘리면 filterGroups에 한 줄 추가.
// 서버가 종목마다 facets(series, ddr, pack)를 주고, 여기서 고른 값과 맞는 종목만 보여 준다.
import '../../market/data/market_models.dart';

/// 필터 한 묶음. single이면 하나만 고른다(RAM 구성: 1개 / 2개 묶음). 아니면 여러 개, 아무것도 안 고르면 전체.
class FilterGroup {
  const FilterGroup(this.facet, this.values, {this.single = false, this.initial = const {}});

  final String facet;
  final List<String> values;
  final bool single;

  /// 처음 값. single은 반드시 하나
  final Set<String> initial;
}

const filterGroups = <Category, List<FilterGroup>>{
  Category.gpu: [
    FilterGroup('series', ['RTX50', 'RTX40', 'RX9000', 'RX7000']),
  ],
  Category.ram: [
    FilterGroup('ddr', ['DDR5', 'DDR4']),
    // 한국은 1개 단위 판매가 기본이라 1개가 처음 값(11/22 사용자 결정)
    FilterGroup('pack', ['1', '2'], single: true, initial: {'1'}),
  ],
  Category.cpu: [
    FilterGroup('brand', ['AMD', 'INTEL']),
    FilterGroup('series', ['RYZEN9000', 'RYZEN7000', 'ULTRA200', 'CORE14', 'CORE13']),
  ],
  Category.ssd: [
    FilterGroup('capacity', ['1TB', '2TB', '4TB']),
    FilterGroup('iface', ['NVME5', 'NVME4', 'SATA']),
    FilterGroup('brand', ['SAMSUNG', 'WD', 'CRUCIAL', 'KINGSTON', 'SKHYNIX']),
  ],
};

/// facet → 고른 값들
typedef BoardFilter = Map<String, Set<String>>;

BoardFilter initialFilter(Category c) => {for (final g in filterGroups[c]!) g.facet: g.initial};

/// 처음 값과 다른 묶음 수(필터 버튼에 표시)
int changedCount(Category c, BoardFilter f) =>
    filterGroups[c]!.where((g) => !_sameSet(f[g.facet] ?? g.initial, g.initial)).length;

bool _sameSet(Set<String> a, Set<String> b) => a.length == b.length && a.containsAll(b);

/// 고른 값이 없으면 그 묶음은 통과. 종목에 그 칸이 없으면(옛 저장본) 거르지 않는다.
bool matchesFilter(BoardItem item, BoardFilter f) => f.entries.every((e) {
  final v = item.facets[e.key];
  return e.value.isEmpty || v == null || e.value.contains(v);
});

Map<String, List<String>> filterToJson(BoardFilter f) => {for (final e in f.entries) e.key: e.value.toList()};

/// 저장본을 읽을 때 지금 정의에 없는 칸·값은 버리고, single 묶음이 비면 처음 값으로
BoardFilter filterFromJson(Category c, Map<String, dynamic> json) => {
  for (final g in filterGroups[c]!)
    g.facet: () {
      final saved = (json[g.facet] as List?)?.cast<String>().where(g.values.contains).toSet();
      if (saved == null || (g.single && saved.length != 1)) return g.initial;
      return saved;
    }(),
};
