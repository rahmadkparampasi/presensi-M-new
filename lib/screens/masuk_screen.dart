import 'package:fluttertoast/fluttertoast.dart';
import 'package:presensi/constants/attribute_constant.dart';
import 'package:presensi/models/sisp_model.dart';
import 'package:presensi/screens/daftar_screen.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:presensi/constants/color_constant.dart';
import 'package:presensi/constants/style_contant.dart';
import 'package:presensi/screens/home_screen.dart';
import 'package:presensi/services/file_services.dart';
import 'package:presensi/services/sisp_services.dart';

class MasukScreen extends StatefulWidget {
  const MasukScreen({super.key});

  @override
  State<MasukScreen> createState() => _MasukScreenState();
}

class _MasukScreenState extends State<MasukScreen> {
  final TextEditingController _user = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  String _dev = 'No Device';

  SispServices get serviceSisp => GetIt.I<SispServices>();

  bool _isLoading = false;

  bool _isChecked = false;

  @override
  void initState() {
    super.initState();
    nameDevice();
  }

  _rememberMe(String text) async {
    FileUtilsUser.saveToFile(text).then((value) {});
  }

  nameDevice() async {
    String dev = await AttributeConstant().getDeviceInfo(context);
    setState(() {
      _dev = dev;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mBackgroundColor,
      body: DoubleBackToCloseApp(
        snackBar: const SnackBar(
          content: Text('Tekan Tombol Kembali Sekali Lagi Untuk Keluar'),
        ),
        child: Container(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: mBluePu,
                  ),
                )
              : ListView(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        const SizedBox(
                          height: 30,
                        ),
                        Image.asset(
                          "assets/images/sp_logo_splash.png",
                          height: 200.0,
                          width: 200.0,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFieldContainer(
                          child: TextField(
                            controller: _user,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                Icons.people_alt_outlined,
                                size: 20,
                              ),
                              hintText: 'Isikan Nama Pengguna Terdaftar',
                              labelText: 'Nama Pengguna',
                              labelStyle: TextStyle(
                                fontSize: 15,
                                color: Colors.blue,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                        TextFieldContainer(
                          child: TextField(
                            controller: _pass,
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                Icons.key_outlined,
                                size: 20,
                              ),
                              hintText: 'Isikan Kata Sandi',
                              labelText: 'Kata Sandi',
                              labelStyle: TextStyle(
                                fontSize: 15,
                                color: Colors.blue,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                height: 24.0,
                                width: 24.0,
                                child: Theme(
                                  data: ThemeData(
                                      unselectedWidgetColor: mYellowPu),
                                  child: Checkbox(
                                    value: _isChecked,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        _isChecked = value!;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                'Ingat Saya',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          child: ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                _isLoading = true;
                              });
                              if (_user.text == '' || _pass.text == '') {
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.error,
                                  animType: AnimType.topSlide,
                                  title: 'Maaf',
                                  desc: 'Lengkapi Data Terlebih Dahulu',
                                  btnOkOnPress: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const MasukScreen(),
                                      ),
                                    );
                                  },
                                ).show();
                              } else {
                                final cekLogin = CekLogin(
                                    user: _user.text,
                                    pass: _pass.text,
                                    dev: _dev);
                                final result =
                                    await serviceSisp.masuk(cekLogin);
                                setState(() {
                                  _isLoading = false;
                                });
                                final text = result.errorMessage;
                                if (result.error) {
                                  setState(() {
                                    _isLoading = false;
                                  });
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
                                  if (_isChecked == true) {
                                    _rememberMe('${result.data!.token};L');
                                  } else {
                                    _rememberMe('${result.data!.token};S');
                                  }
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const HomeScreen(
                                        changeOptions: 0,
                                      ),
                                    ),
                                    (Route<dynamic> route) => false,
                                  );
                                }
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
                              'MASUK',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          child: ElevatedButton(
                            onPressed: () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const DaftarScreen(),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              fixedSize: const Size(350, 50),
                              backgroundColor: mBackgroundColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Belum Terdaftar? Daftar Disini',
                              style: TextStyle(
                                color: mBluePu,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
      bottomNavigationBar: const SizedBox(
        height: 80,
        child: Column(
          children: <Widget>[
            Text('KEMENTRIAN PUPR'),
            Text('Direktorat Jendral Sumber Daya Air'),
            Text('Balai Wilayah Sungai Sulawesi III'),
          ],
        ),
      ),
    );
  }

  void _handleRememberme(bool value) {
    _isChecked = value;
  }
}
