import 'dart:async';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:presensi/constants/color_constant.dart';
import 'package:presensi/constants/prepdf_items.dart';
import 'package:presensi/constants/style_contant.dart';
import 'package:presensi/models/lap_model.dart';
import 'package:presensi/screens/lap_screen.dart';
import 'package:presensi/screens/masuk_screen.dart';
import 'package:presensi/services/lap_services.dart';

class LapSection extends StatefulWidget {
  const LapSection({
    super.key,
  });

  @override
  State<LapSection> createState() => _LapSectionState();
}

class _LapSectionState extends State<LapSection> {
  LapServices get serviceLap => GetIt.I<LapServices>();
  List<Laporan>? laporan;

  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _isLoading = true;
    });
    serviceLap.getLaporan().then((value) async {
      if (value.status != 200) {
        Timer(
          const Duration(seconds: 3),
          () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const MasukScreen(),
            ),
          ),
        );
      }
      setState(() {
        laporan = value.data;
        _isLoading = false;
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

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Container(
        margin: const EdgeInsets.only(bottom: 50),
        width: double.infinity,
        height: (size.height / 100) * 70,
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        child: _isLoading
            ? const Column(
                children: <Widget>[
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color.fromRGBO(255, 66, 66, 1),
                    ),
                  ),
                ],
              )
            : laporan!.isEmpty
                ? const Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Belum Ada Data Laporan',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  )
                : ListView(
                    children: List.generate(
                      laporan!.length,
                      (index) {
                        return LapItem(
                          id: laporan![index].lapId,
                          lapBln: laporan![index].lapBln,
                          lapKet: laporan![index].lapKet,
                          lapNl: laporan![index].lapNl,
                          lapThn: laporan![index].lapThn.toString(),
                          lapFl: laporan![index].lapFl,
                        );
                      },
                    ),
                  ),
      ),
    );
  }
}

class LapItem extends StatelessWidget {
  const LapItem({
    super.key,
    required this.lapBln,
    required this.lapThn,
    required this.lapFl,
    required this.lapNl,
    required this.lapKet,
    required this.id,
  });

  final String lapBln;
  final String lapThn;
  final String lapFl;
  final int lapNl;

  final String lapKet;
  final String id;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: lapNl == 0 ? 140 : 190,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 5.0,
                  offset: const Offset(0.0, 1)),
            ],
          ),
          child: Padding(
            padding: lapNl != 0
                ? const EdgeInsets.only(left: 20, right: 20, top: 20)
                : const EdgeInsets.only(
                    left: 20, right: 20, top: 20, bottom: 0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          overflow: TextOverflow.clip,
                          '$lapBln $lapThn',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    lapNl == 0
                        ? Text(
                            'Belum Dinilai',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          )
                        : RatingBar.builder(
                            initialRating: lapNl.toDouble(),
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemCount: 5,
                            itemSize: 20,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {},
                          ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Column(
                  children: <Widget>[
                    DefaultButton(
                      text: "LAPORAN",
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PrePdf(
                              name:
                                  'Berkas Laporan Bulan $lapBln Tahun $lapThn',
                              pdf: lapFl,
                            ),
                          ),
                        );
                      },
                    ),
                    lapKet != ''
                        ? Column(
                            children: <Widget>[
                              Divider(),
                              DefaultButton(
                                text: "KETERANGAN",
                                press: () => showBottomModal(
                                  context,
                                  LapBottomSection(
                                    ket: lapKet,
                                  ),
                                  420,
                                ),
                              ),
                            ],
                          )
                        : Container()
                  ],
                )
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}

class LapBottomSection extends StatefulWidget {
  final String ket;

  const LapBottomSection({
    super.key,
    required this.ket,
  });

  @override
  State<LapBottomSection> createState() => _LapBottomSectionState();
}

class _LapBottomSectionState extends State<LapBottomSection> {
  late String _ket;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _ket = widget.ket;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
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
                    'LIHAT KETERANGAN PENILAIAN',
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
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: HtmlWidget(_ket),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class LapBottomUploadSection extends StatefulWidget {
  const LapBottomUploadSection({super.key});

  @override
  State<LapBottomUploadSection> createState() => _LapBottomUploadSectionState();
}

class _LapBottomUploadSectionState extends State<LapBottomUploadSection> {
  String? lapThn;
  String? lapBln;

  final TextEditingController namaFl = TextEditingController();
  File? lapFl;

  bool _isLoading = false;

  LapServices get serviceLap => GetIt.I<LapServices>();

  List<Year>? year;
  List<Month>? month;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _isLoading = true;
    });
    serviceLap.getYear().then((value) async {
      if (value.status != 200) {
        Timer(
          const Duration(seconds: 3),
          () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const MasukScreen(),
            ),
          ),
        );
      }

      setState(() {
        year = value.data;
        serviceLap.getMonth().then((value) async {
          if (value.status != 200) {
            Timer(
              const Duration(seconds: 3),
              () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const MasukScreen(),
                ),
              ),
            );
          }

          setState(() {
            month = value.data;
            _isLoading = false;
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
                          'TAMBAH LAPORAN',
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
                      child: DropdownButtonFormField(
                        isExpanded: true,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.calendar_month,
                            size: 20,
                          ),
                          labelText: 'BULAN',
                          labelStyle: TextStyle(
                            fontSize: 15,
                            color: Colors.blue,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        items: month!.map((item) {
                          return DropdownMenuItem(
                            value: item.val,
                            child: Text(item.name),
                          );
                        }).toList(),
                        hint: const Text(
                          "BULAN",
                          style: TextStyle(fontSize: 15),
                        ),
                        value: lapBln,
                        onChanged: (value) {
                          setState(() {
                            lapBln = value;
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
                          prefixIcon: Icon(
                            Icons.calendar_today_rounded,
                            size: 20,
                          ),
                          labelText: 'TAHUN',
                          labelStyle: TextStyle(
                            fontSize: 15,
                            color: Colors.blue,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        items: year!.map((item) {
                          return DropdownMenuItem(
                            value: item.year.toString(),
                            child: Text(item.year.toString()),
                          );
                        }).toList(),
                        hint: const Text(
                          "TAHUN",
                          style: TextStyle(fontSize: 15),
                        ),
                        value: lapThn,
                        onChanged: (value) {
                          setState(() {
                            lapThn = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            width: size.width / 2,
                            child: TextFieldContainer(
                              child: TextField(
                                readOnly: true,
                                controller: namaFl,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  prefixIcon: Icon(
                                    Icons.file_present_outlined,
                                    size: 20,
                                  ),
                                  labelText: 'Nama Berkas',
                                  labelStyle: TextStyle(
                                    fontSize: 15,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          DefaultCostumWidthButton(
                            text: 'PILIH',
                            press: (() async {
                              FilePickerResult? result =
                                  await FilePicker.platform.pickFiles();

                              if (result != null) {
                                setState(() {
                                  lapFl = File(result.files.single.path!);
                                  namaFl.text = result.files.single.name;
                                });
                              }
                            }),
                            width: size.width / 3,
                            color: mYellowPu,
                            splashColor: mYellowPu,
                            colorText: Colors.black,
                          ),
                        ],
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
                              if (lapBln == null ||
                                  lapBln! == '' ||
                                  lapThn == null ||
                                  lapThn! == '' ||
                                  lapFl == null) {
                                Fluttertoast.showToast(
                                  msg: 'Lengkapi Data Terlebih Dahulu',
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.TOP,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 14.0,
                                );
                              } else {
                                final result = await serviceLap.createLap(
                                    lapBln!, lapThn!, lapFl!.path);
                                setState(() {
                                  _isLoading = false;
                                });
                                final title =
                                    result.error ? 'Maaf' : 'Terima Kasih';
                                final text = result.error
                                    ? result.errorMessage
                                    : 'Laporan Berhasil Disimpan';
                                final dialog = result.error
                                    ? DialogType.error
                                    : DialogType.success;
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
                                        builder: (context) => LapScreen(),
                                      ),
                                      (Route<dynamic> route) => false,
                                    );
                                  },
                                ).show();
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
                ),
              ],
            ),
          );
  }
}
