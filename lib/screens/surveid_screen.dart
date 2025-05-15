import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:presensi/constants/color_constant.dart';
import 'package:presensi/constants/style_contant.dart';
import 'package:presensi/models/survei_model.dart';
import 'package:presensi/screens/home_screen.dart';
import 'package:presensi/screens/masuk_screen.dart';
import 'package:presensi/screens/survei_screen.dart';
import 'package:presensi/services/file_services.dart';
import 'package:presensi/services/survei_services.dart';

class SurveidScreen extends StatefulWidget {
  final String id;
  final String thn;
  final String nm;
  const SurveidScreen(
      {super.key, required this.id, required this.thn, required this.nm});

  @override
  State<SurveidScreen> createState() => _SurveidScreenState();
}

class _SurveidScreenState extends State<SurveidScreen> {
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

  SurveiServices get serviceSurvei => GetIt.I<SurveiServices>();

  List<SurveiD>? surveiD;

  bool _isLoading = true;
  bool _isError = true;
  String errorMessage = 'Terjadi Masalah, Silahkan Muat Kembali';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _isLoading = true;
    });
    serviceSurvei.getDetail(widget.id).then((value) async {
      print('disini');
      print('id ${widget.id}');
      print(value.data);
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
        surveiD = value.data;
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
    return Scaffold(
      backgroundColor: mBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SurveiScreen(),
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
            : surveiD!.isEmpty
                ? const Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Belum Ada Data Survei',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  )
                : ListView(
                    children: List.generate(surveiD!.length, (index) {
                      return SurveiDItem(
                        surveiQ: surveiD![index].lbl,
                        surveiA: surveiD![index].a,
                      );
                    }),
                  ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}

class SurveiDItem extends StatelessWidget {
  const SurveiDItem({super.key, required this.surveiQ, required this.surveiA});
  final String surveiQ;
  final String surveiA;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 200,
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
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Column(
              children: <Widget>[
                Text(
                  'Pertanyaan:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                  textAlign: TextAlign.left,
                ),
                Text(
                  surveiQ,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  height: 15,
                ),
                Column(
                  children: <Widget>[
                    Divider(),
                    Text(
                      'Jawaban:',
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      surveiA,
                      textAlign: TextAlign.left,
                    ),
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
