import 'package:fluttertoast/fluttertoast.dart';
import 'package:presensi/constants/color_constant.dart';
import 'package:presensi/constants/style_contant.dart';
import 'package:presensi/models/ppk_model.dart';
import 'package:presensi/models/satker_model.dart';
import 'package:presensi/models/sisp_model.dart';
import 'package:presensi/screens/masuk_screen.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:presensi/services/ppk_services.dart';
import 'package:presensi/services/satker_services.dart';
import 'package:presensi/services/sisp_services.dart';

class DaftarScreen extends StatefulWidget {
  const DaftarScreen({super.key});

  @override
  State<DaftarScreen> createState() => _DaftarScreenState();
}

class _DaftarScreenState extends State<DaftarScreen> {
  final TextEditingController _regNm = TextEditingController();
  final TextEditingController _regMail = TextEditingController();
  final TextEditingController _regWa = TextEditingController();
  final TextEditingController _regUser = TextEditingController();
  final TextEditingController _regPass = TextEditingController();

  String? _regPpk;
  String? _regSatker;

  List<Satker>? satker;
  List<Ppk>? ppk;

  SatkerServices get serviceSatker => GetIt.I<SatkerServices>();
  PpkServices get servicePpk => GetIt.I<PpkServices>();
  SispServices get serviceSisp => GetIt.I<SispServices>();

  bool _isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _isLoading = true;

    serviceSatker.getSatker().then((value) async {
      setState(() {
        satker = value.data;
        _isLoading = false;
      });
    });
  }

  _fetchPpk(String satker) async {
    setState(() {
      _isLoading = true;
    });
    servicePpk.getPpk(satker).then((value) async {
      setState(() {
        ppk = value.data;
        _isLoading = false;
      });
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
              builder: (context) => const MasukScreen(),
            ),
          ),
          icon: const Icon(
            Icons.arrow_back_sharp,
            color: Colors.blue,
          ),
        ),
        backgroundColor: mBackgroundColor,
        elevation: 0,
      ),
      body: DoubleBackToCloseApp(
        snackBar: const SnackBar(
          content: Text('Tekan Tombol Kembali Sekali Lagi Untuk Keluar'),
        ),
        child: Container(
          margin: const EdgeInsets.all(10),
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: mBluePu,
                  ),
                )
              : satker == null
                  ? Center(
                      child: Column(
                        children: <Widget>[
                          const Text('Terdapat Masalah Pada Koneksi'),
                          SizedBox(
                            child: ElevatedButton(
                              onPressed: () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const DaftarScreen(),
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                fixedSize: const Size(200, 50),
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 3,
                              ),
                              child: const Text(
                                'MUAT KEMBALI',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      margin: const EdgeInsets.only(left: 5, right: 5),
                      child: ListView(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              const Text(
                                'REGISTRASI',
                                style: TextStyle(
                                    fontFamily: 'RobotoCondensed',
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Image.asset(
                                "assets/images/sp_logo_splash.png",
                                width: 100.0,
                                height: 100.0,
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
                                      Icons.account_tree_outlined,
                                      size: 20,
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
                                  value: _regSatker,
                                  onChanged: (value) {
                                    _fetchPpk(value.toString());
                                    setState(() {
                                      _regSatker = value;
                                    });
                                  },
                                ),
                              ),
                              TextFieldContainer(
                                child: DropdownButtonFormField(
                                  isExpanded: true,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    prefixIcon: Icon(
                                      Icons.account_tree_outlined,
                                      size: 20,
                                    ),
                                    labelText: 'PPK',
                                    labelStyle: TextStyle(
                                      fontSize: 15,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  items: ppk == null
                                      ? []
                                      : ppk!.map((item) {
                                          return DropdownMenuItem(
                                            value: item.id,
                                            child: Text(item.nama),
                                          );
                                        }).toList(),
                                  hint: const Text(
                                    "Jenis PPK",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  value: _regPpk,
                                  onChanged: (value) {
                                    setState(() {
                                      _regPpk = value as String?;
                                    });
                                  },
                                ),
                              ),
                              TextFieldContainer(
                                child: TextField(
                                  controller: _regNm,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    prefixIcon: Icon(
                                      Icons.groups_outlined,
                                      size: 20,
                                    ),
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
                                height: 2,
                              ),
                              TextFieldContainer(
                                child: TextField(
                                  controller: _regMail,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    prefixIcon: Icon(
                                      Icons.mail_outline,
                                      size: 20,
                                    ),
                                    labelText: 'Email',
                                    labelStyle: TextStyle(
                                      fontSize: 15,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              TextFieldContainer(
                                child: TextField(
                                  controller: _regWa,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    prefixIcon: Icon(
                                      Icons.chat,
                                      size: 20,
                                    ),
                                    labelText: 'Nomor WhatsApp',
                                    labelStyle: TextStyle(
                                      fontSize: 15,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              TextFieldContainer(
                                child: TextField(
                                  controller: _regUser,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    prefixIcon: Icon(
                                      Icons.person_pin_outlined,
                                      size: 20,
                                    ),
                                    labelText: 'Username',
                                    labelStyle: TextStyle(
                                      fontSize: 15,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              TextFieldContainer(
                                child: TextField(
                                  controller: _regPass,
                                  obscureText: true,
                                  enableSuggestions: false,
                                  autocorrect: false,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    prefixIcon: Icon(
                                      Icons.key_outlined,
                                      size: 20,
                                    ),
                                    labelText: 'Password',
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
                              SizedBox(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    if (_regNm.text == '' ||
                                        _regMail.text == '' ||
                                        _regWa.text == '' ||
                                        _regUser.text == '' ||
                                        _regPass.text == '' ||
                                        _regPpk == '' ||
                                        _regPpk == null) {
                                      AwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.error,
                                        animType: AnimType.topSlide,
                                        title: 'Maaf',
                                        desc: 'Lengkapi Data Terlebih Dahulu',
                                        btnOkOnPress: () {},
                                      ).show();
                                      setState(() {
                                        _isLoading = false;
                                      });
                                    } else {
                                      final sispDaftar = SispDaftar(
                                          email: _regMail.text,
                                          nama: _regNm.text,
                                          bag: _regPpk!,
                                          telp: _regWa.text,
                                          user: _regUser.text,
                                          pass: _regPass.text);
                                      final result =
                                          await serviceSisp.daftar(sispDaftar);
                                      setState(() {
                                        _isLoading = false;
                                      });
                                      final title = result.error
                                          ? 'Maaf'
                                          : 'Terima Kasih';
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
                                                    const MasukScreen(),
                                              ),
                                              (Route<dynamic> route) => false,
                                            );
                                          },
                                        ).show();
                                      }
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    fixedSize: const Size(200, 50),
                                    backgroundColor: mBluePu,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 3,
                                  ),
                                  child: const Text(
                                    'DAFTAR',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
        ),
      ),
    );
  }
}
