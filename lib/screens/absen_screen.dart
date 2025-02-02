import 'dart:async';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:presensi/screens/absend_screen.dart';
import 'package:presensi/screens/detail_screen.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:presensi/constants/color_constant.dart';
import 'dart:io';
import 'package:presensi/constants/style_contant.dart';
import 'package:presensi/models/absen_model.dart';
import 'package:presensi/screens/home_screen.dart';
import 'package:presensi/screens/masuk_screen.dart';
import 'package:presensi/services/absen_services.dart';
import 'package:device_info_plus/device_info_plus.dart';

class AbsenScreen extends StatefulWidget {
  const AbsenScreen({super.key});

  @override
  State<AbsenScreen> createState() => _AbsenScreenState();
}

class _AbsenScreenState extends State<AbsenScreen> {
  File? _image;

  bool _isLoading = false;
  bool _isError = false;

  String? _valMsk;

  AbsenDetail? absenDetail;

  final ImagePicker _picker = ImagePicker();

  Position? _position;

  String errorMessage = 'Terjadi Masalah, Silahkan Muat Kembali';

  AbsenService get serviceAbsen => GetIt.I<AbsenService>();

  void _getCurrentLocation() async {
    Position position = await _determinePosition();
    setState(() {
      _position = position;
    });
  }

  Future<Position> _determinePosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location Permision are Denied');
      }
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<String?> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return '${androidDeviceInfo.id}-${androidDeviceInfo.device}-${androidDeviceInfo.product}'; // unique ID on Android
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });
    serviceAbsen.getAbsenDetailDate().then((value) async {
      setState(() {
        if (value.data != null) {
          absenDetail = value.data;
        }
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
    return Scaffold(
      backgroundColor: mBackgroundColor,
      body: Container(
        margin: const EdgeInsets.all(10),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : absenDetail == null
                ? Container(
                    margin: const EdgeInsets.only(left: 5, right: 5),
                    child: ListView(
                      children: <Widget>[
                        const Center(
                          child: Text(
                            'ABSENSI',
                            style: TextStyle(
                              color: Color(0xFF11249F),
                              fontStyle: FontStyle.normal,
                              fontSize: 18.0,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          alignment: Alignment.center,
                          child: Column(
                            children: <Widget>[
                              Stack(
                                children: <Widget>[
                                  Image(
                                    width: 150,
                                    height: 180,
                                    image: _image == null
                                        ? const AssetImage(
                                            'assets/images/user.png')
                                        : FileImage(_image!) as ImageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                  InkWell(
                                    onTap: (() async {
                                      final XFile? image =
                                          await _picker.pickImage(
                                        source: ImageSource.camera,
                                        imageQuality: 40,
                                      );
                                      if (image != null) {
                                        setState(() {
                                          _image = File(image.path);
                                        });
                                      }
                                    }),
                                    child: Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(40.0),
                                            color: Colors.black),
                                        margin: const EdgeInsets.only(
                                          left: 115,
                                          top: 140,
                                        ),
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
                                    fontWeight: FontWeight.bold, fontSize: 12),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        _image != null
                            ? SizedBox(
                                height: 0,
                                width: 0,
                                child: Image.file(_image!),
                              )
                            : Container(),
                        const SizedBox(
                          height: 20,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFieldContainer(
                          child: DropdownButtonFormField(
                            decoration: const InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              prefixIcon: Icon(
                                Icons.sync,
                                size: 20,
                              ),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'WFO',
                                child: Text('WFO'),
                              ),
                              DropdownMenuItem(
                                value: 'WFH',
                                child: Text('WFH'),
                              ),
                              DropdownMenuItem(
                                value: 'D',
                                child: Text('DINAS'),
                              ),
                              DropdownMenuItem(
                                value: 'O',
                                child: Text('ON-SITE'),
                              ),
                            ],
                            hint: const Text(
                              "PILIH SALAH SATU JENIS ABSEN",
                              style: TextStyle(fontSize: 15),
                            ),
                            value: _valMsk,
                            onChanged: (value) {
                              setState(() {
                                _valMsk = value;
                              });
                            },
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
                              if (_valMsk == null ||
                                  _valMsk! == '' ||
                                  _image == null) {
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
                                Position position = await _determinePosition();
                                setState(() {
                                  _position = position;
                                });

                                String? deviceId = await _getId();
                                final result = await serviceAbsen.createAbsen(
                                  _position!.longitude.toString(),
                                  _position!.latitude.toString(),
                                  _valMsk!,
                                  _image!.path,
                                );
                                setState(() {
                                  _isLoading = false;
                                });
                                final title =
                                    result.error ? 'Maaf' : 'Terima Kasih';
                                final text = result.error
                                    ? result.errorMessage
                                    : 'Absen Masuk Berhasil Disimpan';
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
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => HomeScreen(
                                          changeOptions: 1,
                                        ),
                                      ),
                                      (Route<dynamic> route) => false,
                                    );
                                  },
                                ).show();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: mBluePu,
                              fixedSize: const Size(10, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
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
                      ],
                    ),
                  )
                : Container(
                    margin: const EdgeInsets.only(left: 5, right: 5),
                    child: ListView(
                      children: <Widget>[
                        const Center(
                          child: Text(
                            'ABSENSI',
                            style: TextStyle(
                              color: Color(0xFF11249F),
                              fontStyle: FontStyle.normal,
                              fontSize: 18.0,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Card(
                          elevation: 3,
                          child: ListTile(
                            contentPadding: const EdgeInsets.only(
                                top: 10, right: 5, left: 5),
                            title: Text(
                              'Absen ${absenDetail!.absenTgl}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              children: <Widget>[
                                ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0.1,
                                    horizontal: 10,
                                  ),
                                  title: const Text('Masuk'),
                                  trailing: Text(absenDetail!.absenMsk),
                                ),
                                ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0.1,
                                    horizontal: 10,
                                  ),
                                  title: const Text('Pulang'),
                                  trailing: Text(absenDetail!.absenKeluar),
                                ),
                                ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0.1,
                                    horizontal: 10,
                                  ),
                                  title: const Text('Keterangan'),
                                  trailing: Text(absenDetail!.absenKet),
                                ),
                                ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0.1,
                                    horizontal: 10,
                                  ),
                                  title: const Text('Status Absen'),
                                  trailing: Text(absenDetail!.absenStatus),
                                ),
                                ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0.1,
                                    horizontal: 10,
                                  ),
                                  title: const Text('Aksi'),
                                  trailing: ElevatedButton(
                                    style: const ButtonStyle(
                                        backgroundColor:
                                            WidgetStatePropertyAll<Color>(
                                                mBluePu)),
                                    onPressed: absenDetail!.absenKeluark != "1"
                                        ? () => Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AbsenDScreen(
                                                  idBerita:
                                                      absenDetail!.absenId,
                                                  changeOptions: 1,
                                                  tgl: absenDetail!.absenTgl,
                                                ),
                                              ),
                                            )
                                        : () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailScreen(
                                                  id: absenDetail!.absenId,
                                                  changeOptions: 1,
                                                ),
                                              ),
                                            ),
                                    child: absenDetail!.absenKeluark != "1"
                                        ? const Text(
                                            'Absen Pulang',
                                            style:
                                                TextStyle(color: Colors.white),
                                          )
                                        : const Text(
                                            'Detail',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
