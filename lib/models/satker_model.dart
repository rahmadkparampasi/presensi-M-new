class Satker {
  String id;
  String nama;
  Satker({
    required this.id,
    required this.nama,
  });
  factory Satker.fromJson(Map<String, dynamic> item) {
    return Satker(
      id: item['bag_id'],
      nama: item['bag_nm'],
    );
  }
}
