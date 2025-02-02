import 'dart:async';
import 'dart:io';

import 'package:presensi/constants/color_constant.dart';
import 'package:presensi/constants/style_contant.dart';
import 'package:presensi/constants/var_constant.dart';
import 'package:presensi/models/sisp_model.dart';
import 'package:presensi/screens/comps/profil_comps.dart';
import 'package:presensi/screens/detailpc_screen.dart';
import 'package:presensi/screens/home_screen.dart';
import 'package:presensi/screens/masuk_screen.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:presensi/services/sisp_services.dart';

class DetailPScreen extends StatefulWidget {
  const DetailPScreen({super.key});

  @override
  State<DetailPScreen> createState() => _DetailPScreenState();
}

class _DetailPScreenState extends State<DetailPScreen> {
  File? _image;

  final ImagePicker _picker = ImagePicker();

  SispServices get serviceSisp => GetIt.I<SispServices>();

  bool _isLoading = false;
  bool _isError = false;

  String errorMessage = 'Terjadi Masalah, Silahkan Muat Kembali';

  String server = '';

  Sisp? sisp;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _isLoading = true;
    });
    serviceSisp.getSisp().then((value) async {
      setState(() {
        sisp = value.data;
        if (value.error) {
          _isLoading = false;
          _isError = true;
          errorMessage = value.errorMessage!;
        } else {
          _isLoading = false;
        }
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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _isError
              ? Center(
                  child: Text(errorMessage),
                )
              : sisp == null
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
                                      builder: (context) => HomeScreen(
                                        changeOptions: 2,
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
                      children: <Widget>[
                        Center(
                          child: Column(
                            children: <Widget>[
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
                              Text(
                                textAlign: TextAlign.center,
                                'Profil ${sisp!.sispNama}',
                                style: const TextStyle(
                                  fontFamily: 'RobotoCondensed',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Center(
                          child: Container(
                            child: ElevatedButton(
                              onPressed: () => showBottomModal(
                                context,
                                ProfilBottomChange(),
                                420,
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: mBluePu,
                                fixedSize: const Size(200, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 3,
                              ),
                              child: const Text(
                                'UBAH PROFIL',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Card(
                          elevation: 3,
                          child: ListTile(
                            contentPadding: const EdgeInsets.only(
                                top: 10, right: 5, left: 5),
                            subtitle: Column(
                              children: <Widget>[
                                ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0.1,
                                    horizontal: 10,
                                  ),
                                  title: const Text(
                                    'Username',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    textAlign: TextAlign.right,
                                    sisp!.username,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                                ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0.1,
                                    horizontal: 10,
                                  ),
                                  title: const Text(
                                    'Nama',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    textAlign: TextAlign.right,
                                    sisp!.sispNama,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                                ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0.1,
                                    horizontal: 10,
                                  ),
                                  title: const Text(
                                    'Email',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    textAlign: TextAlign.right,
                                    sisp!.sispWa,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                                ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0.1,
                                    horizontal: 10,
                                  ),
                                  title: const Text(
                                    'Nomor HP',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    textAlign: TextAlign.right,
                                    sisp!.sispTelp,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                                ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0.1,
                                    horizontal: 10,
                                  ),
                                  title: const Text(
                                    'Status',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    textAlign: TextAlign.right,
                                    sisp!.sispAct == "1" ? 'Aktif' : 'Tidak',
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                                ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0.1,
                                    horizontal: 10,
                                  ),
                                  title: const Text(
                                    'SATKER',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    textAlign: TextAlign.right,
                                    sisp!.satkerNm,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                                ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0.1,
                                    horizontal: 10,
                                  ),
                                  title: const Text(
                                    'PPK',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    textAlign: TextAlign.right,
                                    sisp!.bagNm,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                                ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0.1,
                                    horizontal: 10,
                                  ),
                                  title: const Text(
                                    'Foto',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Container(
                                    margin: const EdgeInsets.only(top: 10),
                                    alignment: Alignment.center,
                                    child: Column(
                                      children: <Widget>[
                                        Stack(
                                          children: <Widget>[
                                            _image == null
                                                ? SizedBox(
                                                    height: 200,
                                                    width: 250,
                                                    child: sisp!.sispPic == ''
                                                        ? Image.asset(
                                                            'assets/images/avatar.png',
                                                            scale: 0.5,
                                                          )
                                                        : Image.network(
                                                            '$apiServerF/storage/uploads/${sisp!.sispPic}',
                                                            scale: 0.5,
                                                          ),
                                                  )
                                                : Image(
                                                    width: 150,
                                                    height: 180,
                                                    image: FileImage(_image!)
                                                        as ImageProvider,
                                                    fit: BoxFit.cover,
                                                  ),
                                            InkWell(
                                              onTap: (() async {
                                                final XFile? image =
                                                    await _picker.pickImage(
                                                  source: ImageSource.gallery,
                                                  imageQuality: 30,
                                                );
                                                if (image != null) {
                                                  setState(() {
                                                    _image = File(image.path);
                                                  });
                                                }
                                              }),
                                              child: Container(
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              40.0),
                                                      color: Colors.black),
                                                  margin: _image != null
                                                      ? const EdgeInsets.only(
                                                          left: 115,
                                                          top: 140,
                                                        )
                                                      : const EdgeInsets.only(
                                                          left: 210, top: 160),
                                                  child: const Icon(
                                                    Icons.photo_camera,
                                                    size: 25,
                                                    color: Colors.white,
                                                  )),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        const Text(
                                          'Ketuk Ikon Kamera Untuk Menggambil Gambar',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
                                          textAlign: TextAlign.center,
                                        ),
                                        _image != null
                                            ? SizedBox(
                                                height: 0,
                                                width: 0,
                                                child: Image.file(_image!),
                                              )
                                            : Container(),
                                        _image != null
                                            ? Column(
                                                children: <Widget>[
                                                  Container(
                                                    child: ElevatedButton(
                                                      onPressed: () async {
                                                        setState(() {
                                                          _isLoading = true;
                                                        });

                                                        final result =
                                                            await serviceSisp
                                                                .changePic(
                                                          _image!.path,
                                                        );
                                                        setState(() {
                                                          _isLoading = false;
                                                        });

                                                        final title = result
                                                                .error
                                                            ? 'Maaf'
                                                            : 'Terima Kasih';
                                                        final text = result
                                                                .error
                                                            ? result
                                                                .errorMessage
                                                            : 'Absen Masuk Berhasil Disimpan';
                                                        final dialog = result
                                                                .error
                                                            ? DialogType.error
                                                            : DialogType
                                                                .success;
                                                        AwesomeDialog(
                                                          context: context,
                                                          dialogType: dialog,
                                                          animType:
                                                              AnimType.topSlide,
                                                          title: title,
                                                          desc: text!,
                                                          btnOkOnPress: () {
                                                            Navigator
                                                                .pushAndRemoveUntil(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        HomeScreen(
                                                                  changeOptions:
                                                                      2,
                                                                ),
                                                              ),
                                                              (Route<dynamic>
                                                                      route) =>
                                                                  false,
                                                            );
                                                          },
                                                        ).show();
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            mBluePu,
                                                        fixedSize:
                                                            const Size(200, 50),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        elevation: 3,
                                                      ),
                                                      child: const Text(
                                                        'SIMPAN FOTO',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Container(
                                                    child: ElevatedButton(
                                                      onPressed: () async {
                                                        setState(() {
                                                          _image = null;
                                                        });
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            mBluePu,
                                                        fixedSize:
                                                            const Size(200, 50),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        elevation: 3,
                                                      ),
                                                      child: const Text(
                                                        'BATAL',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Container(),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 40,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
    );
  }
}
