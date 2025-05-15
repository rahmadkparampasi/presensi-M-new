import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:presensi/constants/color_constant.dart';
import 'package:presensi/constants/style_contant.dart';
import 'package:presensi/models/absen_model.dart';
import 'package:presensi/screens/home_screen.dart';
import 'package:presensi/screens/masuk_screen.dart';
import 'package:presensi/services/absen_services.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:presensi/services/file_services.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';

class DetailScreen extends StatefulWidget {
  final String id;

  final int changeOptions;
  const DetailScreen({
    super.key,
    required this.id,
    required this.changeOptions,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
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

  late String id;

  AbsenService get serviceAbsen => GetIt.I<AbsenService>();

  bool _isLoading = false;
  bool _isError = false;

  String errorMessage = 'Terjadi Masalah, Silahkan Muat Kembali';

  AbsenDetail? absenDetail;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      id = widget.id;
      _isLoading = true;
    });
    serviceAbsen.getAbsenDetail(widget.id).then((value) async {
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
        absenDetail = value.data;
        if (value.error) {
          _isLoading = false;
          _isError = true;
          errorMessage = value.errorMessage!;
        } else {
          _isLoading = false;
        }
      });
      setState(() {
        absenDetail = value.data;
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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: mBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
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
                : absenDetail == null
                    ? ListView(
                        children: <Widget>[
                          Center(
                            child: Column(
                              children: <Widget>[
                                const Text('Tidak Ada Data'),
                                const SizedBox(
                                  height: 10,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailScreen(
                                          id: widget.id,
                                          changeOptions: widget.changeOptions,
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Muat Kembali',
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
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
                                    'DETAIL ABSENSI ${absenDetail!.absenTgl.toUpperCase()}',
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
                                SizedBox(
                                  height: size.height / 1.2,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: <Widget>[
                                        DetailItemWOIcon(
                                          title: 'Status',
                                          subtitle: absenDetail!.absenStatus,
                                          isLast: false,
                                          img: false,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        DetailItemWOIcon(
                                          title: 'Tanggal',
                                          subtitle: absenDetail!.absenTgl,
                                          isLast: false,
                                          img: false,
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          'MASUK',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                        Divider(),
                                        DetailItemWOIcon(
                                          title: 'Jam Masuk',
                                          subtitle: absenDetail!.absenMsk,
                                          isLast: false,
                                          img: false,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        DetailItemWOIcon(
                                          title: 'Cepat Datang',
                                          subtitle: absenDetail!.absenCd,
                                          isLast: false,
                                          img: false,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        DetailItemWOIcon(
                                          title: 'Lambat',
                                          subtitle: absenDetail!.absenLmbt,
                                          isLast: false,
                                          img: false,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        DetailItemWOIcon(
                                          title: 'Lokasi Masuk',
                                          subtitle: absenDetail!.absenMskLoc,
                                          isLast: false,
                                          img: false,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        DetailItemWOIcon(
                                          title: 'Foto Masuk',
                                          subtitle: absenDetail!.absenMskPic,
                                          isLast: false,
                                          img: true,
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          'PULANG',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                        Divider(),
                                        DetailItemWOIcon(
                                          title: 'Jam Pulang',
                                          subtitle: absenDetail!.absenKeluar,
                                          isLast: false,
                                          img: false,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        DetailItemWOIcon(
                                          title: 'Cepat Pulang',
                                          subtitle: absenDetail!.absenCp,
                                          isLast: false,
                                          img: false,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        DetailItemWOIcon(
                                          title: 'Lambat Pulang',
                                          subtitle: absenDetail!.absenLbh,
                                          isLast: false,
                                          img: false,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        DetailItemWOIcon(
                                          title: 'Lokasi Pulang',
                                          subtitle: absenDetail!.absenKeluarLoc,
                                          isLast: false,
                                          img: false,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        DetailItemWOIcon(
                                          title: 'Foto Pulang',
                                          subtitle: absenDetail!.absenPulangPic,
                                          isLast: false,
                                          img: true,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        DetailItemWOIcon(
                                          title: 'Jam Pulang Seharusnya',
                                          subtitle: absenDetail!.absenPsn,
                                          isLast: false,
                                          img: false,
                                        ),
                                        const SizedBox(
                                          height: 50,
                                        ),
                                        const Center(
                                          child: SizedBox(
                                            height: 200,
                                            child: Column(
                                              children: <Widget>[
                                                Text('KEMENTRIAN PUPR'),
                                                Text(
                                                    'Direktorat Jendral Sumber Daya Air'),
                                                Text(
                                                    'Balai Wilayah Sungai Sulawesi III'),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
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
