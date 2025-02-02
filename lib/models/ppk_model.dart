class Ppk {
  String id;
  String nama;
  Ppk({
    required this.id,
    required this.nama,
  });
  factory Ppk.fromJson(Map<String, dynamic> item) {
    return Ppk(
      id: item['bag_id'],
      nama: item['bag_nm'],
    );
  }
}
