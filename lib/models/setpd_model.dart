class Setpd {
  String id;
  String nama;
  Setpd({
    required this.id,
    required this.nama,
  });
  factory Setpd.fromJson(Map<String, dynamic> item) {
    return Setpd(
      id: item['setpd_id'],
      nama: item['setpd_nm'],
    );
  }
}
