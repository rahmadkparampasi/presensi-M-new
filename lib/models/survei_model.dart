class Survei {
  String surveiId;
  String surveisId;
  String surveiNama;
  int surveiThn;

  Survei({
    required this.surveiId,
    required this.surveisId,
    required this.surveiNama,
    required this.surveiThn,
  });
  factory Survei.fromJson(Map<String, dynamic> item) {
    return Survei(
      surveiId: item['survei_id'],
      surveisId: item['surveis_id'],
      surveiNama: item['sisp_nm'],
      surveiThn: item['survei_thn'],
    );
  }
}

class SurveiD {
  String lbl;
  String a;
  SurveiD({
    required this.lbl,
    required this.a,
  });
  factory SurveiD.fromJson(Map<String, dynamic> item) {
    return SurveiD(
      lbl: item['surveiq_lbl'], //OK
      a: item['na'], //OK
    );
  }
}
