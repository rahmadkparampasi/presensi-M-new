class Laporan {
  String lapId;
  int lapThn;
  String lapBln;
  int lapNl;
  String lapKet;
  String lapFl;

  Laporan({
    required this.lapId,
    required this.lapThn,
    required this.lapBln,
    required this.lapNl,
    required this.lapKet,
    required this.lapFl,
  });
  factory Laporan.fromJson(Map<String, dynamic> item) {
    return Laporan(
      lapId: item['lap_id'],
      lapThn: item['lap_thn'],
      lapBln: item['lap_bln'],
      lapNl: item['lap_nl'],
      lapKet: item['lap_ket'],
      lapFl: item['lap_fl'],
    );
  }
}

class Year {
  int year;
  Year({required this.year});
  factory Year.fromJson(Map<String, dynamic> item) {
    return Year(year: item['year']);
  }
}

class Month {
  String name;
  String val;
  Month({required this.name, required this.val});
  factory Month.fromJson(Map<String, dynamic> item) {
    return Month(name: item['name'], val: item['val']);
  }
}
