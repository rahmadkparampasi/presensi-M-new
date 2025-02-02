class AbsenHome {
  String absenId;
  String absenTgl;
  String absenMsk;
  String absenPlg;
  String absenKet;
  String absenStatus;
  String absenLok;

  AbsenHome({
    required this.absenId,
    required this.absenTgl,
    required this.absenMsk,
    required this.absenPlg,
    required this.absenKet,
    required this.absenStatus,
    required this.absenLok,
  });
  factory AbsenHome.fromJson(Map<String, dynamic> item) {
    return AbsenHome(
      absenId: item['absen_id'],
      absenTgl: item['absen_tglAltT'],
      absenMsk: item['absen_masuk'],
      absenPlg: item['absen_keluar'],
      absenKet: item['absen_ket'],
      absenStatus: item['absen_sts'],
      absenLok: item['absen_lokAlT'],
    );
  }
}

class AbsenDetail {
  String absenId;
  String sispNama;
  String absenTgl;
  String absenMsk;
  String absenMskk;
  String absenMskLoc;

  String absenMskLat;
  String absenMskLong;
  String absenKet;
  String absenTipe;
  String absenMskPic;
  String absenKeluar;
  String absenKeluark;
  String absenKeluarLoc;
  String absenPulangLat;
  String absenPulangLong;
  String absenPulangPic;
  String absenStatus;

  String absenLmbt;
  String absenLbh;
  String absenCp;
  String absenCd;

  String absenPsn;
  AbsenDetail({
    required this.absenId,
    required this.sispNama,
    required this.absenTgl,
    required this.absenMsk,
    required this.absenMskk,
    required this.absenMskLoc,
    required this.absenMskLat,
    required this.absenMskLong,
    required this.absenKet,
    required this.absenTipe,
    required this.absenMskPic,
    required this.absenKeluar,
    required this.absenKeluark,
    required this.absenKeluarLoc,
    required this.absenPulangLat,
    required this.absenPulangLong,
    required this.absenPulangPic,
    required this.absenStatus,
    required this.absenLmbt,
    required this.absenLbh,
    required this.absenCp,
    required this.absenCd,
    required this.absenPsn,
  });
  factory AbsenDetail.fromJson(Map<String, dynamic> item) {
    return AbsenDetail(
      absenId: item['absen_id'], //OK
      sispNama: item['sisp_nmAltT'], //OK
      absenTgl: item['absen_tglAltT'], //OK
      absenMsk: item['absen_masuk'], //OK
      absenMskk: item['absen_masukk'],
      absenMskLoc: item['absen_masuklokAltT'], //OK
      absenMskLat: item['absen_masuklong'], //OK
      absenMskLong: item['absen_masuklat'], //OK
      absenKet: item['absen_psn'], //OK
      absenTipe: item['absen_tipeAltT'], //OK
      absenMskPic: item['absen_masukpic'], //OK
      absenKeluar: item['absen_keluar'], //OK
      absenKeluark: item['absen_keluark'], //OK
      absenKeluarLoc: item['absen_keluarlokAltT'], //OK
      absenPulangLat: item['absen_keluarlat'], //OK
      absenPulangLong: item['absen_keluarlong'], //OK
      absenPulangPic: item['absen_keluarpic'], //OK
      absenStatus: item['absen_stsAltT'], //OK

      absenLmbt: item['absen_lmbt'], //OK
      absenLbh: item['absen_lbh'], //OK
      absenCp: item['absen_cp'], //OK
      absenCd: item['absen_cd'], //OK

      absenPsn: item['absen_psn'], //OK
    );
  }
}

class AbsenRekap {
  int h;
  int i;
  int th;
  AbsenRekap({
    required this.h,
    required this.i,
    required this.th,
  });
  factory AbsenRekap.fromJson(Map<String, dynamic> item) {
    return AbsenRekap(
      h: item['H'],
      i: item['I'],
      th: item['TH'],
    );
  }
}

class AbsenGetYear {
  int year;
  AbsenGetYear({
    required this.year,
  });
  factory AbsenGetYear.fromJson(Map<String, dynamic> item) {
    return AbsenGetYear(year: item['year']);
  }
}

class AbsenGetMonth {
  String val;
  String text;
  AbsenGetMonth({
    required this.val,
    required this.text,
  });
  factory AbsenGetMonth.fromJson(Map<String, dynamic> item) {
    return AbsenGetMonth(
      val: item['optValue'],
      text: item['optText'],
    );
  }
}

class Adm {
  String admId;
  String admUser;
  String admNm;
  String admMail;
  String admHP;
  String admAct;
  String admFoto;
  String admJK;
  String admJnsId;
  String admIdentitas;
  String admAlt;
  String admAbout;
  String admFb;
  String admPpkNm;
  String admPpkId;
  Adm({
    required this.admId,
    required this.admUser,
    required this.admNm,
    required this.admMail,
    required this.admHP,
    required this.admAct,
    required this.admFoto,
    required this.admJK,
    required this.admJnsId,
    required this.admIdentitas,
    required this.admAlt,
    required this.admAbout,
    required this.admFb,
    required this.admPpkNm,
    required this.admPpkId,
  });
  factory Adm.fromJson(Map<String, dynamic> item) {
    return Adm(
      admId: item['id'],
      admUser: item['username'],
      admNm: item['nama'],
      admMail: item['email'],
      admHP: item['nomor_telp'],
      admAct: item['active'],
      admFoto: item['foto'],
      admJK: item['jenis_kelamin'],
      admJnsId: item['jenis_identitas'],
      admIdentitas: item['no_identitas'],
      admAlt: item['alamat'],
      admAbout: item['about'],
      admFb: item['facebook'],
      admPpkNm: item['nama_ppk'],
      admPpkId: item['id_ppk'],
    );
  }
}

// class Ppk {
//   String ppkId;
//   String ppkNama;
//   String ppkTahun;
//   String ppkDesc;
//   Ppk({
//     required this.ppkId,
//     required this.ppkNama,
//     required this.ppkTahun,
//     required this.ppkDesc,
//   });
//   factory Ppk.fromJson(Map<String, dynamic> item) {
//     return Ppk(
//       ppkId: item['id_ppk'],
//       ppkNama: item['nama_ppk'],
//       ppkTahun: item['tahun_ppk'],
//       ppkDesc: item['des_ppk'],
//     );
//   }
// }
