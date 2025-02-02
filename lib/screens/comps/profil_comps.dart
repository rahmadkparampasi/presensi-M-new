import 'dart:async';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:presensi/constants/attribute_constant.dart';
import 'package:presensi/constants/color_constant.dart';
import 'package:presensi/constants/sp_icon.dart';
import 'package:presensi/constants/style_contant.dart';
import 'package:presensi/constants/var_constant.dart';
import 'package:presensi/models/ppk_model.dart';
import 'package:presensi/models/satker_model.dart';
import 'package:presensi/models/setpd_model.dart';
import 'package:presensi/models/sisp_model.dart';
import 'package:presensi/screens/home_screen.dart';
import 'package:presensi/screens/masuk_screen.dart';
import 'package:presensi/services/file_services.dart';
import 'package:presensi/services/ppk_services.dart';
import 'package:presensi/services/satker_services.dart';
import 'package:presensi/services/setpd_services.dart';
import 'package:presensi/services/sisp_services.dart';

class ProfilDetailSection extends StatefulWidget {
  final String nm;
  final String kntrk;
  final String tglkntrk;
  final String satker;
  final String ppk;
  final String tmptlhr;
  final String tgllhr;
  final String jk;
  final String pdNm;
  final String alt;
  final String telp;
  final String wa;
  final String wak;
  const ProfilDetailSection({
    super.key,
    required this.nm,
    required this.kntrk,
    required this.tglkntrk,
    required this.satker,
    required this.ppk,
    required this.tmptlhr,
    required this.tgllhr,
    required this.jk,
    required this.pdNm,
    required this.alt,
    required this.telp,
    required this.wa,
    required this.wak,
  });

  @override
  State<ProfilDetailSection> createState() => _ProfilDetailSectionState();
}

class _ProfilDetailSectionState extends State<ProfilDetailSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Container(
            margin: const EdgeInsets.only(bottom: 50),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            child: Column(
              children: <Widget>[
                const Row(
                  children: <Widget>[
                    Icon(
                      Icons.people_outline,
                      color: Colors.amber,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Biodata",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                DetailItem(
                  icon: "id-card.png",
                  title: 'Nama Lengkap',
                  subtitle: widget.nm,
                  isLast: false,
                ),
                const SizedBox(
                  height: 10,
                ),
                DetailItem(
                  icon: "contract.png",
                  title: 'Nomor Kontrak',
                  subtitle: widget.kntrk,
                  isLast: false,
                ),
                const SizedBox(
                  height: 10,
                ),
                DetailItem(
                  icon: "calendar.png",
                  title: 'Tanggal Kontrak',
                  subtitle: widget.tglkntrk,
                  isLast: false,
                ),
                const SizedBox(
                  height: 10,
                ),
                DetailItem(
                  icon: "sitemap.png",
                  title: 'SATKER',
                  subtitle: widget.satker,
                  isLast: false,
                ),
                const SizedBox(
                  height: 10,
                ),
                DetailItem(
                  icon: "sitemap.png",
                  title: 'PPK',
                  subtitle: widget.ppk,
                  isLast: false,
                ),
                const SizedBox(
                  height: 10,
                ),
                DetailItem(
                  icon: "globe.png",
                  title: 'Tempat Lahir',
                  subtitle: widget.tmptlhr,
                  isLast: false,
                ),
                const SizedBox(
                  height: 10,
                ),
                DetailItem(
                  icon: "calendar.png",
                  title: 'Tanggal Lahir',
                  subtitle: widget.tgllhr,
                  isLast: false,
                ),
                const SizedBox(
                  height: 10,
                ),
                DetailItem(
                  icon: "wc.png",
                  title: 'Jenis Kelamin',
                  subtitle: widget.jk == 'L' ? 'Laki-Laki' : 'Perempuan',
                  isLast: false,
                ),
                const SizedBox(
                  height: 10,
                ),
                DetailItem(
                  icon: "grad.png",
                  title: 'Pendidikan',
                  subtitle: widget.pdNm,
                  isLast: false,
                ),
                const SizedBox(
                  height: 10,
                ),
                DetailItem(
                  icon: "location.png",
                  title: 'Alamat',
                  subtitle: widget.alt,
                  isLast: false,
                ),
                const SizedBox(
                  height: 10,
                ),
                DetailItem(
                  icon: "phone.png",
                  title: 'Telepon',
                  subtitle: widget.telp,
                  isLast: false,
                ),
                const SizedBox(
                  height: 10,
                ),
                DetailItem(
                  icon: "conversation.png",
                  title: 'Whatsapp',
                  subtitle: widget.wa,
                  isLast: false,
                ),
                const SizedBox(
                  height: 10,
                ),
                DetailItem(
                  icon: "conversation.png",
                  title: 'Whatsapp Keluarga',
                  subtitle: widget.wak,
                  isLast: false,
                ),
                const SizedBox(
                  height: 10,
                ),
                DefaultButton(
                  text: "KELUAR",
                  press: () {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.question,
                      title: 'Maaf',
                      desc: 'Apakah Ingin Keluar Dari Aplikasi',
                      btnOkOnPress: () {
                        FileUtilsUser.saveToFile("").then((value) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MasukScreen(),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        });
                      },
                      btnCancelOnPress: () {},
                    ).show();
                  },
                ),
                const SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ProfilPicSection extends StatefulWidget {
  final String pic;
  final String nama;
  const ProfilPicSection({super.key, required this.pic, required this.nama});

  @override
  State<ProfilPicSection> createState() => _ProfilPicSectionState();
}

class _ProfilPicSectionState extends State<ProfilPicSection> {
  File? _image;

  final ImagePicker _picker = ImagePicker();

  SispServices get serviceSisp => GetIt.I<SispServices>();

  bool _isLoading = false;
  bool _isError = false;

  String errorMessage = 'Terjadi Masalah, Silahkan Muat Kembali';
  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Center(
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 10,
                ),
                Stack(
                  children: <Widget>[
                    _image == null
                        ? SizedBox(
                            height: 200,
                            width: 250,
                            child: widget.pic == ''
                                ? Image.asset(
                                    'assets/images/user.png',
                                    scale: 0.5,
                                  )
                                : Image.network(
                                    '$apiServerF/storage/uploads/${widget.pic}',
                                    scale: 0.5,
                                  ),
                          )
                        : Image(
                            width: 150,
                            height: 180,
                            image: FileImage(_image!) as ImageProvider,
                            fit: BoxFit.cover,
                          ),
                    InkWell(
                      onTap: (() async {
                        final XFile? image = await _picker.pickImage(
                          source: ImageSource.gallery,
                          imageQuality: 30,
                        );
                        if (image != null) {
                          setState(() {
                            _image = File(image.path);
                          });
                        }
                      }),
                      child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40.0),
                              color: Colors.black),
                          margin: _image != null
                              ? const EdgeInsets.only(
                                  left: 115,
                                  top: 140,
                                )
                              : const EdgeInsets.only(left: 210, top: 160),
                          child: const Icon(
                            Icons.photo_camera,
                            size: 25,
                            color: Colors.white,
                          )),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  'Ketuk Ikon Kamera Untuk Menggambil Gambar',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 10,
                ),
                _image != null
                    ? SizedBox(
                        height: 0,
                        width: 0,
                        child: Image.file(_image!),
                      )
                    : Container(),
                _image != null
                    ? Column(
                        children: <Widget>[
                          Container(
                            child: ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  _isLoading = true;
                                });

                                final result = await serviceSisp.changePic(
                                  _image!.path,
                                );

                                final title =
                                    result.error ? 'Maaf' : 'Terima Kasih';
                                final text = result.error
                                    ? result.errorMessage
                                    : 'Foto Pegawai Berhasil Diubah';
                                final dialog = result.error
                                    ? DialogType.error
                                    : DialogType.success;
                                setState(() {
                                  _isLoading = false;
                                });
                                if (result.error) {
                                  Fluttertoast.showToast(
                                    msg: text!,
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.TOP,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 14.0,
                                  );
                                } else {
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: dialog,
                                    animType: AnimType.topSlide,
                                    title: title,
                                    desc: text!,
                                    btnOkOnPress: () {
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => HomeScreen(
                                            changeOptions: 2,
                                          ),
                                        ),
                                        (Route<dynamic> route) => false,
                                      );
                                    },
                                  ).show();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: mBluePu,
                                fixedSize: const Size(200, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 3,
                              ),
                              child: const Text(
                                'SIMPAN FOTO',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            child: ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  _image = null;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: mBluePu,
                                fixedSize: const Size(200, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 3,
                              ),
                              child: const Text(
                                'BATAL',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      )
                    : Container(),
                Text(
                  textAlign: TextAlign.center,
                  'Profil ${widget.nama}',
                  style: const TextStyle(
                    fontFamily: 'RobotoCondensed',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
  }
}

class ProfilBottomChange extends StatefulWidget {
  const ProfilBottomChange({super.key});

  @override
  State<ProfilBottomChange> createState() => _ProfilBottomChangeState();
}

class _ProfilBottomChangeState extends State<ProfilBottomChange> {
  bool _isLoading = false;
  bool _isError = false;

  String errorMessage = 'Terjadi Masalah, Silahkan Muat Kembali';

  Sisp? sisp;

  TextEditingController sispKntrk = TextEditingController();
  TextEditingController sispTglKntrk = TextEditingController();
  TextEditingController sispNm = TextEditingController();
  TextEditingController sispTmptLhr = TextEditingController();
  TextEditingController sispTglLhr = TextEditingController();
  TextEditingController sispAlt = TextEditingController();
  TextEditingController sispTelp = TextEditingController();
  TextEditingController sispWa = TextEditingController();
  TextEditingController sispWak = TextEditingController();
  String? sispPpk;
  String? sispSatker;
  String? sispJk;
  String? sispPd;

  List<Satker>? satker;
  List<Ppk>? ppk;
  List<Setpd>? pendidikan;

  SatkerServices get serviceSatker => GetIt.I<SatkerServices>();
  PpkServices get servicePpk => GetIt.I<PpkServices>();
  SispServices get serviceSisp => GetIt.I<SispServices>();
  SetpdServices get serviceSetpd => GetIt.I<SetpdServices>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _isLoading = true;
    });
    serviceSisp.getSisp().then((value) async {
      setState(() {
        sisp = value.data;
        sispKntrk.text = sisp!.sispKntrk;
        sispTglKntrk.text = sisp!.sispTglKntrk;
        sispNm.text = sisp!.sispNama;
        sispSatker = sisp!.satkerId;
        sispPpk = sisp!.bagId;
        sispTmptLhr.text = sisp!.sispTmptLhr;
        sispTglLhr.text = sisp!.sispTglLhr;
        sispJk = sisp!.sispJK;
        sispPd = sisp!.sispPd;
        sispAlt.text = sisp!.sispAlt;
        sispTelp.text = sisp!.sispTelp;
        sispWa.text = sisp!.sispWa;
        sispWak.text = sisp!.sispWak;
      });
      serviceSatker.getSatker().then((value) async {
        setState(() {
          satker = value.data;
          if (value.error) {
            _isLoading = false;
            _isError = true;
            errorMessage = value.errorMessage!;
          }
        });
        if (!value.error) {
          _fetchPpk(sisp!.satkerId);
        }
      });
    }).catchError((_) {
      Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MasukScreen(),
          ),
        ),
      );
    });
  }

  _fetchPpk(String satker) async {
    setState(() {
      _isLoading = true;
    });
    servicePpk.getPpk(satker).then((value) async {
      setState(() {
        ppk = value.data;
      });
      _fetchPd();
    });
  }

  _fetchPd() async {
    setState(() {
      _isLoading = true;
    });
    serviceSetpd.getPd().then((value) async {
      setState(() {
        pendidikan = value.data;
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return _isLoading
        ? SizedBox(
            width: MediaQuery.of(context).size.width,
            child: const Column(
              children: <Widget>[
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color.fromRGBO(255, 66, 66, 1),
                  ),
                ),
              ],
            ),
          )
        : _isError
            ? SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Text(errorMessage),
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: ListView(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        const SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: TextButton.icon(
                            style: TextButton.styleFrom(
                              iconColor: Colors.black,
                              foregroundColor: Colors.transparent,
                              backgroundColor: Colors.transparent,
                              overlayColor: Colors.transparent,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            label: const Text(
                              'UBAH DATA PEGAWAI',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            icon: const Icon(
                              Icons.arrow_back,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFieldContainer(
                          child: TextField(
                            controller: sispKntrk,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              prefixIcon:
                                  SPIcon(assetName: 'contract.png', height: 20),
                              labelText: 'Nomor Kontrak',
                              labelStyle: TextStyle(
                                fontSize: 15,
                                color: Colors.blue,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFieldContainer(
                          child: TextField(
                            readOnly: true,
                            onTap: () {
                              AttributeConstant()
                                  .selectDate(context)
                                  .then((value) {
                                setState(() {
                                  sispTglKntrk.text = value;
                                });
                              });
                            },
                            controller: sispTglKntrk,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              prefixIcon:
                                  SPIcon(assetName: 'calendar.png', height: 20),
                              labelText: 'Tanggal Kontrak',
                              labelStyle: TextStyle(
                                fontSize: 15,
                                color: Colors.blue,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFieldContainer(
                          child: TextField(
                            controller: sispNm,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              prefixIcon:
                                  SPIcon(assetName: 'id-card.png', height: 20),
                              labelText: 'Nama Lengkap',
                              labelStyle: TextStyle(
                                fontSize: 15,
                                color: Colors.blue,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFieldContainer(
                          child: DropdownButtonFormField(
                            isExpanded: true,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: SPIcon(
                                assetName: 'sitemap.png',
                                height: 20,
                              ),
                              labelText: 'SATKER',
                              labelStyle: TextStyle(
                                fontSize: 15,
                                color: Colors.blue,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            items: satker!.map((item) {
                              return DropdownMenuItem(
                                value: item.id,
                                child: Text(item.nama),
                              );
                            }).toList(),
                            hint: const Text(
                              "SATKER",
                              style: TextStyle(fontSize: 15),
                            ),
                            value: sisp!.satkerId,
                            onChanged: (value) {
                              setState(() {
                                sispSatker = value;
                              });
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFieldContainer(
                          child: DropdownButtonFormField(
                            isExpanded: true,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: SPIcon(
                                assetName: 'sitemap.png',
                                height: 20,
                              ),
                              labelText: 'PPK',
                              labelStyle: TextStyle(
                                fontSize: 15,
                                color: Colors.blue,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            items: ppk!.map((item) {
                              return DropdownMenuItem(
                                value: item.id,
                                child: Text(item.nama),
                              );
                            }).toList(),
                            hint: const Text(
                              "PPK",
                              style: TextStyle(fontSize: 15),
                            ),
                            value: sisp!.bagId,
                            onChanged: (value) {
                              setState(() {
                                sispPpk = value;
                              });
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFieldContainer(
                          child: TextField(
                            controller: sispTmptLhr,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              prefixIcon:
                                  SPIcon(assetName: 'globe.png', height: 20),
                              labelText: 'Tempat Lahir',
                              labelStyle: TextStyle(
                                fontSize: 15,
                                color: Colors.blue,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFieldContainer(
                          child: TextField(
                            readOnly: true,
                            onTap: () {
                              AttributeConstant()
                                  .selectDate(context)
                                  .then((value) {
                                setState(() {
                                  sispTglLhr.text = value;
                                });
                              });
                            },
                            controller: sispTglLhr,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              prefixIcon:
                                  SPIcon(assetName: 'calendar.png', height: 20),
                              labelText: 'Tanggal Lahir',
                              labelStyle: TextStyle(
                                fontSize: 15,
                                color: Colors.blue,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFieldContainer(
                          child: DropdownButtonFormField(
                            isExpanded: true,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: SPIcon(
                                assetName: 'wc.png',
                                height: 20,
                              ),
                              labelText: 'Jenis Kelamin',
                              labelStyle: TextStyle(
                                fontSize: 15,
                                color: Colors.blue,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'L',
                                child: Text('Laki-Laki'),
                              ),
                              DropdownMenuItem(
                                value: 'P',
                                child: Text('Perempuan'),
                              ),
                            ],
                            hint: const Text(
                              "Jenis Kelamin",
                              style: TextStyle(fontSize: 15),
                            ),
                            value: sisp!.sispJK,
                            onChanged: (value) {
                              setState(() {
                                sispJk = value;
                              });
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFieldContainer(
                          child: DropdownButtonFormField(
                            isExpanded: true,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: SPIcon(
                                assetName: 'grad.png',
                                height: 20,
                              ),
                              labelText: 'Pendidikan',
                              labelStyle: TextStyle(
                                fontSize: 15,
                                color: Colors.blue,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            items: pendidikan!.map((item) {
                              return DropdownMenuItem(
                                value: item.id,
                                child: Text(item.nama),
                              );
                            }).toList(),
                            hint: const Text(
                              "Pendidikan",
                              style: TextStyle(fontSize: 15),
                            ),
                            value: sisp!.sispPd != ''
                                ? sisp!.sispPd
                                : '9fe510ce-5c80-11ef-8f97-d92739a79c17',
                            onChanged: (value) {
                              setState(() {
                                sispPd = value;
                              });
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFieldContainer(
                          child: TextField(
                            controller: sispAlt,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              prefixIcon:
                                  SPIcon(assetName: 'location.png', height: 20),
                              labelText: 'Alamat',
                              labelStyle: TextStyle(
                                fontSize: 15,
                                color: Colors.blue,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFieldContainer(
                          child: TextField(
                            controller: sispTelp,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              prefixIcon:
                                  SPIcon(assetName: 'phone.png', height: 20),
                              labelText: 'Alamat',
                              labelStyle: TextStyle(
                                fontSize: 15,
                                color: Colors.blue,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFieldContainer(
                          child: TextField(
                            controller: sispWa,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: SPIcon(
                                  assetName: 'conversation.png', height: 20),
                              labelText: 'Whatsapp',
                              labelStyle: TextStyle(
                                fontSize: 15,
                                color: Colors.blue,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFieldContainer(
                          child: TextField(
                            controller: sispWak,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: SPIcon(
                                  assetName: 'conversation.png', height: 20),
                              labelText: 'Whatsapp Keluarga',
                              labelStyle: TextStyle(
                                fontSize: 15,
                                color: Colors.blue,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              DefaultCostumWidthButton(
                                text: 'SIMPAN',
                                press: () async {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  if (sispKntrk.text == '' ||
                                      sispTglKntrk.text == '' ||
                                      sispNm.text == '' ||
                                      sispTmptLhr.text == '' ||
                                      sispTglLhr.text == '' ||
                                      sispAlt.text == '' ||
                                      sispTelp.text == '' ||
                                      sispWa.text == '' ||
                                      sispWak.text == '' ||
                                      sispPpk == null ||
                                      sispPpk! == '' ||
                                      sispSatker == null ||
                                      sispSatker! == '' ||
                                      sispJk == null ||
                                      sispJk! == '' ||
                                      sispPd == null ||
                                      sispPd! == '') {
                                    Fluttertoast.showToast(
                                      msg: 'Lengkapi Data Terlebih Dahulu',
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.TOP,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 14.0,
                                    );
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  } else {
                                    final sispUpdate = SispUpdate(
                                      sispNama: sispNm.text,
                                      sispTmptLhr: sispTmptLhr.text,
                                      sispTglLhr: sispTglLhr.text,
                                      sispBag: sispPpk!,
                                      sispJK: sispJk!,
                                      sispALt: sispAlt.text,
                                      sispKntrk: sispKntrk.text,
                                      sispTglKntrk: sispTglKntrk.text,
                                      sispWa: sispWa.text,
                                      sispWak: sispWak.text,
                                      sispPd: sispPd!,
                                      sispTelp: sispTelp.text,
                                    );

                                    final result = await serviceSisp
                                        .changeSisp(sispUpdate);
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    final title =
                                        result.error ? 'Maaf' : 'Terima Kasih';
                                    final text = result.error
                                        ? result.errorMessage
                                        : result.errorMessage;

                                    if (result.error) {
                                      Fluttertoast.showToast(
                                        msg: text!,
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.TOP,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 14.0,
                                      );
                                    } else {
                                      AwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.success,
                                        animType: AnimType.topSlide,
                                        title: title,
                                        desc: text!,
                                        btnOkOnPress: () {
                                          Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const HomeScreen(
                                                changeOptions: 2,
                                              ),
                                            ),
                                            (Route<dynamic> route) => false,
                                          );
                                        },
                                      ).show();
                                    }
                                  }
                                },
                                width: size.width / 3,
                                color: mBluePu,
                                splashColor: mBluePu,
                                colorText: Colors.white,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              DefaultCostumWidthButton(
                                text: 'BATAL',
                                press: () {
                                  Navigator.pop(context);
                                },
                                width: size.width / 3,
                                color: Colors.grey,
                                splashColor: Colors.grey.shade600,
                                colorText: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
  }
}
