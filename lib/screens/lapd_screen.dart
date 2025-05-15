import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:presensi/constants/color_constant.dart';
import 'package:presensi/constants/style_contant.dart';
import 'package:presensi/screens/home_screen.dart';
import 'package:presensi/screens/lap_screen.dart';
import 'package:presensi/screens/masuk_screen.dart';
import 'package:presensi/services/file_services.dart';

class LapdScreen extends StatefulWidget {
  final String ket;
  final String bln;
  final String thn;
  const LapdScreen(
      {super.key, required this.ket, required this.bln, required this.thn});

  @override
  State<LapdScreen> createState() => _LapdScreenState();
}

class _LapdScreenState extends State<LapdScreen> {
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

  String? ket;
  String? bln;
  String? thn;

  bool _isLoading = true;
  bool _isError = true;
  String errorMessage = 'Terjadi Masalah, Silahkan Muat Kembali';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      ket = widget.ket;
      bln = widget.bln;
      thn = widget.thn;
      if (ket != null && bln != null && thn != null) {
        _isError = false;
      }
      _isLoading = false;
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
                                  'LIHAT KETERANGAN PENILAIAN LAPORAN BULAN ${bln!.toUpperCase()} $thn',
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
                              Container(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: HtmlWidget(ket!),
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
                                      Text('Balai Wilayah Sungai Sulawesi III'),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    )),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
