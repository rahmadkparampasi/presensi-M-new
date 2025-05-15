import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:presensi/constants/color_constant.dart';
import 'package:presensi/constants/style_contant.dart';
import 'package:presensi/screens/comps/survei_comps.dart';
import 'package:presensi/screens/home_screen.dart';
import 'package:presensi/screens/masuk_screen.dart';
import 'package:presensi/services/file_services.dart';

class SurveiScreen extends StatefulWidget {
  const SurveiScreen({super.key});

  @override
  State<SurveiScreen> createState() => _SurveiScreenState();
}

class _SurveiScreenState extends State<SurveiScreen> {
  final bool _isLoading = false;

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                                          "SURVEI",
                                          style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SurveiSection(),
                                ],
                              ),
                            ),
                          ),
                  )))
                ],
              ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
