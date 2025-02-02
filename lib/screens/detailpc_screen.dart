import 'dart:async';

import 'package:presensi/constants/color_constant.dart';
import 'package:presensi/constants/style_contant.dart';
import 'package:presensi/models/ppk_model.dart';
import 'package:presensi/models/satker_model.dart';
import 'package:presensi/models/sisp_model.dart';
import 'package:presensi/screens/detailp_screen.dart';
import 'package:presensi/screens/home_screen.dart';
import 'package:presensi/screens/masuk_screen.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:presensi/services/ppk_services.dart';
import 'package:presensi/services/satker_services.dart';
import 'package:presensi/services/sisp_services.dart';

class DetailPCScreen extends StatefulWidget {
  const DetailPCScreen({
    super.key,
  });

  @override
  State<DetailPCScreen> createState() => _DetailPCScreenState();
}

class _DetailPCScreenState extends State<DetailPCScreen> {
  final TextEditingController _profUser = TextEditingController();
  final TextEditingController _profPass = TextEditingController();
  final TextEditingController _profPassCon = TextEditingController();

  final TextEditingController _profMail = TextEditingController();

  final TextEditingController _profNama = TextEditingController();
  final TextEditingController _profIdentitas = TextEditingController();
  final TextEditingController _profTelp = TextEditingController();
  final TextEditingController _profAlt = TextEditingController();

  String _profJnsKel = 'L';
  String? _profPpk;
  String? _profSatker;

  SatkerServices get serviceSatker => GetIt.I<SatkerServices>();
  PpkServices get servicePpk => GetIt.I<PpkServices>();
  SispServices get serviceSisp => GetIt.I<SispServices>();

  bool _isLoading = false;
  bool _isError = false;
  String errorMessage = 'Terjadi Masalah, Silahkan Muat Kembali';

  Sisp? sisp;
  List<Satker>? satker;
  List<Ppk>? ppk;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    serviceSisp.getSisp().then((value) async {
      setState(() {
        sisp = value.data;

        _profUser.text = value.data!.username;
        _profMail.text = value.data!.sispWa;
        _profNama.text = value.data!.sispNama;

        _profIdentitas.text = value.data!.sispIdSp;
        _profJnsKel = value.data!.sispJK;
        _profTelp.text = value.data!.sispTelp;
        _profAlt.text = value.data!.sispAlt;

        _profPpk = value.data!.bagId;
        _profSatker = value.data!.satkerId;

        if (value.error) {
          _isLoading = false;
          _isError = true;
          errorMessage = value.errorMessage!;
        } else {
          _isLoading = false;
        }
      });
      servicePpk.getPpk(value.data!.satkerId).then((value) async {
        setState(() {
          ppk = value.data;
          _isLoading = false;
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
    serviceSatker.getSatker().then((value) async {
      setState(() {
        satker = value.data;
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
              builder: (context) => HomeScreen(changeOptions: 2),
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
                    child: CircularProgressIndicator(),
                  )
                : _isError
                    ? Center(
                        child: Text(errorMessage),
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
                                        builder: (context) => DetailPScreen(),
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
                                      'KEMBALI',
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
                                      'EDIT PROFIL',
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
                                        value: _profPpk,
                                        onChanged: (value) {
                                          setState(() {
                                            _profSatker = value;
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
                                        value: _profPpk,
                                        onChanged: (value) {
                                          setState(() {
                                            _profPpk = value;
                                          });
                                        },
                                      ),
                                    ),
                                    TextFieldContainer(
                                      child: TextField(
                                        controller: _profUser,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          prefixIcon: Icon(
                                            Icons.groups_outlined,
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
                                        controller: _profMail,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          prefixIcon: Icon(
                                            Icons.groups_outlined,
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
                                        controller: _profPass,
                                        obscureText: true,
                                        enableSuggestions: false,
                                        autocorrect: false,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          prefixIcon: Icon(
                                            Icons.groups_outlined,
                                            size: 20,
                                          ),
                                          labelText: 'Passowrd',
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
                                        controller: _profPassCon,
                                        obscureText: true,
                                        enableSuggestions: false,
                                        autocorrect: false,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          prefixIcon: Icon(
                                            Icons.groups_outlined,
                                            size: 20,
                                          ),
                                          labelText: 'Ulangi Passowrd',
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
                                        controller: _profNama,
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
                                        controller: _profIdentitas,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          prefixIcon: Icon(
                                            Icons.groups_outlined,
                                            size: 20,
                                          ),
                                          labelText: 'Nomor Identitas',
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
                                      child: DropdownButtonFormField(
                                        decoration: const InputDecoration(
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                          ),
                                          prefixIcon: Icon(
                                            Icons.sync,
                                            size: 20,
                                          ),
                                        ),
                                        items: sisp!.sispJK == ""
                                            ? const [
                                                DropdownMenuItem(
                                                  value: '',
                                                  enabled: false,
                                                  child: Text(
                                                      'Pilih Jenis Kelamin Terlebih Dahulu'),
                                                ),
                                                DropdownMenuItem(
                                                  value: 'L',
                                                  child: Text('Laki-Laki'),
                                                ),
                                                DropdownMenuItem(
                                                  value: 'P',
                                                  child: Text('Perempuan'),
                                                ),
                                              ]
                                            : const [
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
                                        value: _profJnsKel,
                                        onChanged: (value) {
                                          setState(() {
                                            _profJnsKel = value!;
                                          });
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 2,
                                    ),
                                    TextFieldContainer(
                                      child: TextField(
                                        controller: _profTelp,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          prefixIcon: Icon(
                                            Icons.phone_outlined,
                                            size: 20,
                                          ),
                                          labelText: 'Nomor Telepon',
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
                                        maxLines: 3,
                                        controller: _profAlt,
                                        decoration: const InputDecoration(
                                          alignLabelWithHint: true,
                                          border: InputBorder.none,
                                          prefixIcon: Icon(
                                            Icons.map_outlined,
                                            size: 20,
                                          ),
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
                                      height: 2,
                                    ),
                                    SizedBox(
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          setState(() {
                                            _isLoading = true;
                                          });
                                          if (_profUser.text == '' ||
                                              _profMail.text == '' ||
                                              _profNama.text == '' ||
                                              _profIdentitas.text == '' ||
                                              _profJnsKel == '' ||
                                              _profTelp.text == '' ||
                                              _profAlt.text == '' ||
                                              _profPpk == '' ||
                                              _profPpk == null) {
                                            AwesomeDialog(
                                              context: context,
                                              dialogType: DialogType.error,
                                              animType: AnimType.topSlide,
                                              title: 'Maaf',
                                              desc:
                                                  'Lengkapi Data Terlebih Dahulu',
                                              btnOkOnPress: () {},
                                            ).show();
                                            setState(() {
                                              _isLoading = false;
                                            });
                                          } else {
                                            // final updateSisp = SispUpdate(
                                            //   sispNama: _profNama.text,
                                            //   sispEmail: _profMail.text,
                                            //   sispJK: _profJnsKel,
                                            //   sispALt: _profAlt.text,
                                            //   sispTelp: _profTelp.text,
                                            //   sispBag: _profPpk!,
                                            //   sispIdSp: _profIdentitas.text, sispTmptLhr: '',
                                            // );
                                            // final result = await serviceSisp
                                            //     .changeSisp(updateSisp);
                                            // setState(() {
                                            //   _isLoading = false;
                                            // });
                                            // final title = result.error
                                            //     ? 'Maaf'
                                            //     : 'Terima Kasih';
                                            // final text = result.error
                                            //     ? result.errorMessage
                                            //     : 'Absen Masuk Berhasil Disimpan';
                                            // final dialog = result.error
                                            //     ? DialogType.error
                                            //     : DialogType.success;
                                            // if (result.error) {
                                            //   AwesomeDialog(
                                            //     context: context,
                                            //     dialogType: dialog,
                                            //     animType: AnimType.topSlide,
                                            //     title: title,
                                            //     desc: text!,
                                            //     btnOkOnPress: () {},
                                            //   ).show();
                                            // } else {
                                            //   AwesomeDialog(
                                            //     context: context,
                                            //     dialogType: dialog,
                                            //     animType: AnimType.topSlide,
                                            //     title: title,
                                            //     desc: text!,
                                            //     btnOkOnPress: () {
                                            //       Navigator.pushAndRemoveUntil(
                                            //         context,
                                            //         MaterialPageRoute(
                                            //           builder: (context) =>
                                            //               HomeScreen(
                                            //             changeOptions: 2,
                                            //           ),
                                            //         ),
                                            //         (Route<dynamic> route) =>
                                            //             false,
                                            //       );
                                            //     },
                                            //   ).show();
                                            // }
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          fixedSize: const Size(200, 50),
                                          backgroundColor: mBluePu,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          elevation: 3,
                                        ),
                                        child: const Text(
                                          'SIMPAN',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 40,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )),
      ),
    );
  }
}
