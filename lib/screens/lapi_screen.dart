import 'dart:async';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:presensi/constants/color_constant.dart';
import 'package:presensi/constants/style_contant.dart';
import 'package:presensi/models/lap_model.dart';
import 'package:presensi/screens/home_screen.dart';
import 'package:presensi/screens/lap_screen.dart';
import 'package:presensi/screens/masuk_screen.dart';
import 'package:presensi/services/file_services.dart';
import 'package:presensi/services/lap_services.dart';

class LapiScreen extends StatefulWidget {
  const LapiScreen({super.key});

  @override
  State<LapiScreen> createState() => _LapiScreenState();
}

class _LapiScreenState extends State<LapiScreen> {
  void _onItemTapped(int index) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(
          changeOptions: index,
        ),
      ),
    );
  }

  bool _isLoading = false;
  bool _isError = true;
  String errorMessage = 'Terjadi Masalah, Silahkan Muat Kembali';

  String? lapThn;
  String? lapBln;

  final TextEditingController namaFl = TextEditingController();
  File? lapFl;

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
            _isError = false;
          });
        }).catchError((e) {
          setState(() {
            _isError = true;
            errorMessage = e.toString();
          });
        });
      });
    }).catchError((e) {
      setState(() {
        _isError = true;
        errorMessage = e.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: mBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LapScreen(),
            ),
          ),
          icon: const Icon(
            Icons.arrow_back_sharp,
            color: Colors.blue,
          ),
        ),
        backgroundColor: mBackgroundColor,
        title: Image.asset(
          'assets/images/sp_logo_header.png',
          height: 15,
        ),
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.power_settings_new,
              color: mBluePu,
            ),
            onPressed: () {
              AwesomeDialog(
                context: context,
                title: 'Menyetujui',
                desc: 'Ingin Keluar Dari Aplikasi',
                dialogType: DialogType.question,
                btnCancelOnPress: () {},
                btnOkOnPress: () {
                  FileUtilsUser.saveToFile("").then((value) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MasukScreen(),
                      ),
                    );
                  });
                },
              ).show();
            },
          ),
        ],
      ),
      body: DoubleBackToCloseApp(
        snackBar: const SnackBar(
          content: Text('Tekan Tombol Kembali Sekali Lagi Untuk Keluar'),
        ),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: mBluePu,
                ),
              )
            : _isError
                ? Center(
                    child: Text(errorMessage),
                  )
                : ListView(
                    physics: const ClampingScrollPhysics(),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Column(
                          children: <Widget>[
                            const SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: Text(
                                'TAMBAH LAPORAN',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
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
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
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
                                          lapFl =
                                              File(result.files.single.path!);
                                          namaFl.text =
                                              result.files.single.name;
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
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
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
                                        final result =
                                            await serviceLap.createLap(
                                                lapBln!, lapThn!, lapFl!.path);
                                        setState(() {
                                          _isLoading = false;
                                        });
                                        final title = result.error
                                            ? 'Maaf'
                                            : 'Terima Kasih';
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
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    LapScreen(),
                                              ),
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
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => LapScreen(),
                                        ),
                                      );
                                    },
                                    width: size.width / 3,
                                    color: Colors.grey,
                                    splashColor: Colors.grey.shade600,
                                    colorText: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 80,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
