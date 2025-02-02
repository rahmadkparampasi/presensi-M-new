class SispDaftar {
  String email;
  String nama;
  String bag;
  String telp;
  String user;
  String pass;

  SispDaftar(
      {required this.email,
      required this.nama,
      required this.bag,
      required this.telp,
      required this.user,
      required this.pass});

  Map<String, dynamic> toJson() {
    return {
      "sisp_email": email,
      "sisp_nm": nama,
      "sisp_bag": bag,
      "sisp_telp": telp,
      "username": user,
      "password": pass,
    };
  }
}

class CekLogin {
  String user;
  String pass;
  String dev;

  CekLogin({required this.user, required this.pass, required this.dev});

  Map<String, dynamic> toJson() {
    return {"username": user, "password": pass, "device_name": dev};
  }
}

class FeedBackMasuk {
  String token;

  FeedBackMasuk({
    required this.token,
  });

  factory FeedBackMasuk.fromJson(Map<String, dynamic> item) {
    return FeedBackMasuk(
      token: item['token'],
    );
  }
}

class Sisp {
  String sispId;
  String sispKntrk;
  String sispTglKntrk;
  String sispTlgKntrkAltT;
  String sispTmptLhr;
  String sispTglLhr;
  String sispTglLhrAltT;
  String sispJK;
  String sispPd;
  String sispPdNm;
  String sispAlt;
  String sispTelp;
  String sispWa;
  String sispWak;
  String sispPic;
  String sispIdSp;
  String bagNm;
  String bagId;
  String satkerId;
  String satkerNm;
  String username;
  String sispNama;

  String sispAct;
  Sisp({
    required this.sispId,
    required this.sispKntrk,
    required this.sispTglKntrk,
    required this.sispTlgKntrkAltT,
    required this.sispTmptLhr,
    required this.sispTglLhr,
    required this.sispTglLhrAltT,
    required this.sispJK,
    required this.sispPd,
    required this.sispPdNm,
    required this.sispAlt,
    required this.sispTelp,
    required this.username,
    required this.sispNama,
    required this.sispAct,
    required this.sispPic,
    required this.sispIdSp,
    required this.bagNm,
    required this.bagId,
    required this.satkerId,
    required this.satkerNm,
    required this.sispWa,
    required this.sispWak,
  });
  factory Sisp.fromJson(Map<String, dynamic> item) {
    return Sisp(
      sispId: item['sisp_id'], //OK
      sispKntrk: item['sisp_kntrk'], //OK
      sispTglKntrk: item['sisp_tglkntrk'], //OK
      sispTlgKntrkAltT: item['sisp_tglkntrkAltT'], //OK
      sispTmptLhr: item['sisp_tmptlhr'], //OK
      sispTglLhr: item['sisp_tgllhr'], //OK
      sispTglLhrAltT: item['sisp_tgllhrAltT'], //OK
      sispJK: item['sisp_jk'], //OK
      sispPd: item['sisp_setpd'], //OK
      sispPdNm: item['setpd_nm'], //OK
      sispAlt: item['sisp_alt'], //OK
      sispTelp: item['sisp_telp'], //OK

      username: item['username'], //OK
      sispNama: item['sisp_nmAltT'], //OK
      sispWa: item['sisp_wa'], //OK
      sispWak: item['sisp_wak'], //OK
      sispAct: item['sisp_act'], //OK
      sispPic: item['sisp_pic'], //OK
      sispIdSp: item['sisp_idsp'], //OK
      bagNm: item['bag_nm'], //OK
      bagId: item['sisp_bag'], //OK
      satkerId: item['sisp_satker'], //OK
      satkerNm: item['sisp_satkernm'], //OK
    );
  }
}

class SispUpdate {
  String sispNama;
  String sispTmptLhr;
  String sispTglLhr;
  String sispBag;
  String sispJK;
  String sispALt;
  String sispKntrk;
  String sispTglKntrk;
  String sispWa;
  String sispWak;
  String sispPd;
  String sispTelp;
  SispUpdate({
    required this.sispNama,
    required this.sispTmptLhr,
    required this.sispTglLhr,
    required this.sispBag,
    required this.sispJK,
    required this.sispALt,
    required this.sispKntrk,
    required this.sispTglKntrk,
    required this.sispWa,
    required this.sispWak,
    required this.sispPd,
    required this.sispTelp,
  });

  Map<String, dynamic> toJson() {
    return {
      "sisp_nm": sispNama,
      "sisp_tmptlhr": sispTmptLhr,
      "sisp_tgllhr": sispTglLhr,
      "sisp_bag": sispBag,
      "sisp_jk": sispJK,
      "sisp_alt": sispALt,
      "sisp_kntrk": sispKntrk,
      "sisp_tglkntrk": sispTglKntrk,
      "sisp_wa": sispWa,
      "sisp_wak": sispWak,
      "sisp_setpd": sispPd,
      "sisp_telp": sispTelp,
    };
  }
}
