import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:presensi/constants/attribute_constant.dart';
import 'package:presensi/constants/color_constant.dart';
import 'package:presensi/constants/style_contant.dart';
import 'package:presensi/models/absen_model.dart';
import 'package:presensi/screens/comps/absen_comps.dart';
import 'package:presensi/screens/home_screen.dart';
import 'package:presensi/screens/masuk_screen.dart';
import 'package:presensi/services/absen_services.dart';
import 'package:presensi/services/file_services.dart';

class AbsenlistScreen extends StatefulWidget {
  final int absThn;
  final int absBln;
  final int changeOptions;
  const AbsenlistScreen({
    super.key,
    required this.absThn,
    required this.absBln,
    required this.changeOptions,
  });

  @override
  State<AbsenlistScreen> createState() => _AbsenlistScreenState();
}

class _AbsenlistScreenState extends State<AbsenlistScreen> {
  bool _isLoading = false;

  late int _absThn;
  late int _absBln;
  late int _changeOptions;
  String _month = 'JANUARI';

  AbsenService get serviceAbsen => GetIt.I<AbsenService>();
  AbsenRekap? absenRekap;

  AbsenHome? absenHome;

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

  List itemMenu = [
    {
      "title": "HADIR",
      "icon": "0",
      "color1": Colors.green,
    },
    {
      "title": "TIDAK HADIR",
      "icon": "0",
      "color1": Colors.red,
    },
    {
      "title": "IZIN",
      "icon": "0",
      "color1": Colors.blue,
    },
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.absBln.toString().length == 1) {
      setState(() {
        _month =
            AttributeConstant().getMonthName('0${widget.absBln.toString()}');
      });
    } else {
      setState(() {
        _month = AttributeConstant().getMonthName(widget.absBln.toString());
      });
    }
    setState(() {
      _absThn = widget.absThn;
      _absBln = widget.absBln;
      _changeOptions = widget.changeOptions;
    });
    serviceAbsen
        .getRekap(_absBln.toString(), _absThn.toString())
        .then((value) async {
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
        absenRekap = value.data;
        itemMenu[0]['icon'] = value.data!.h;
        itemMenu[2]['icon'] = value.data!.i;
        itemMenu[1]['icon'] = value.data!.th;
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: mBackgroundColor,
        title: Image.asset(
          'assets/images/sp_logo_header.png',
          height: 15,
        ),
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.remove_red_eye_outlined,
              color: mBluePu,
            ),
            onPressed: () => showBottomModal(
              context,
              AbsensiBottomSection(
                absBln: _absBln,
                absThn: _absThn,
                changeOptions: _changeOptions,
              ),
              420,
            ),
          ),
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
      backgroundColor: mBackgroundColor,
      bottomNavigationBar: BottomNavBar(),
      body: DoubleBackToCloseApp(
        snackBar: const SnackBar(
          content: Text('Tekan Tombol Kembali Sekali Lagi Untuk Keluar'),
        ),
        child: _isLoading
            ? const Center(
                child: Column(
                  children: <Widget>[
                    CircularProgressIndicator(
                      color: mBluePu,
                    )
                  ],
                ),
              )
            : Row(
                children: <Widget>[
                  Expanded(
                    child: SafeArea(
                      child: SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: _isLoading
                            ? const Center(
                                child: Column(
                                  children: <Widget>[
                                    CircularProgressIndicator(
                                      color: mBluePu,
                                    )
                                  ],
                                ),
                              )
                            : SizedBox(
                                width: size.width,
                                height: size.height,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: mBackgroundColor,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      topRight: Radius.circular(30),
                                    ),
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, right: 20),
                                        child: Column(
                                          children: <Widget>[
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              "ABSENSI ${_month.toUpperCase()} ${widget.absThn}",
                                              style: const TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            const Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.auto_graph,
                                                  color: mBluePu,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "REKAPAN",
                                                  style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            AbsensiRekapSection(
                                              //Edit: Ambil Data Dari Web
                                              itemMenu: itemMenu,
                                              size: size, date: false,
                                              dateName: "Bulan",
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.list,
                                                  color: mBluePu,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "DAFTAR ",
                                                  style: const TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      AbsensiSection(
                                        month: widget.absBln.toString(),
                                        year: widget.absThn.toString(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
