import 'dart:async';

import 'package:presensi/constants/color_constant.dart';
import 'package:presensi/constants/var_constant.dart';
import 'package:presensi/models/absen_model.dart';
import 'package:presensi/screens/home_screen.dart';
import 'package:presensi/screens/masuk_screen.dart';
import 'package:presensi/services/absen_services.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher.dart';
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
    return Scaffold(
      backgroundColor: mBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(
                changeOptions: widget.changeOptions,
              ),
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
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
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
                                  'Absen ${absenDetail!.sispNama}, ${absenDetail!.absenTgl}',
                                  style: const TextStyle(
                                    fontFamily: 'RobotoCondensed',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Card(
                            elevation: 3,
                            child: ListTile(
                              contentPadding: const EdgeInsets.only(
                                  top: 10, right: 5, left: 5),
                              title: const Text(
                                'Absen Masuk',
                                style: TextStyle(
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
                                    title: const Text('Jam Masuk'),
                                    trailing: Text(absenDetail!.absenMsk),
                                  ),
                                  ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 0.1,
                                      horizontal: 10,
                                    ),
                                    title: const Text('Lokasi Absen'),
                                    trailing: Text(absenDetail!.absenMskLoc),
                                  ),
                                  ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 0.1,
                                      horizontal: 10,
                                    ),
                                    title: const Text('Peta Lokasi'),
                                    trailing: ElevatedButton(
                                      style: const ButtonStyle(
                                          backgroundColor:
                                              WidgetStatePropertyAll<Color>(
                                                  mBluePu)),
                                      onPressed: () async {
                                        String url =
                                            'www.google.com/maps/search/?api=1&query=${absenDetail!.absenMskLat},${absenDetail!.absenMskLong}';
                                        final Uri launcUri =
                                            Uri(scheme: 'https', path: url);
                                        if (await canLaunchUrl(launcUri)) {
                                          await launchUrl(
                                            launcUri,
                                            mode:
                                                LaunchMode.externalApplication,
                                          );
                                        } else {
                                          throw "Could not launch $url";
                                        }
                                      },
                                      child: const Text(
                                        'MAPS',
                                      ),
                                    ),
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
                                    trailing: Text(absenDetail!.absenTipe),
                                  ),
                                  ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 0.1,
                                      horizontal: 10,
                                    ),
                                    title: const Text('Foto'),
                                    subtitle: SizedBox(
                                      height: 200,
                                      child: Image.network(
                                        '$apiServerF/storage/uploads/${absenDetail!.absenMskPic}',
                                        scale: 0.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            elevation: 3,
                            child: ListTile(
                              contentPadding: const EdgeInsets.only(
                                  top: 10, right: 5, left: 5),
                              title: const Text(
                                'Absen Keluar',
                                style: TextStyle(
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
                                    title: const Text('Jam Pulang'),
                                    trailing: Text(absenDetail!.absenKeluar),
                                  ),
                                  ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 0.1,
                                      horizontal: 10,
                                    ),
                                    title: const Text('Lokasi Absen'),
                                    trailing: Text(absenDetail!.absenKeluarLoc),
                                  ),
                                  ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 0.1,
                                      horizontal: 10,
                                    ),
                                    title: const Text('Peta Lokasi'),
                                    trailing: ElevatedButton(
                                      style: const ButtonStyle(
                                          backgroundColor:
                                              WidgetStatePropertyAll<Color>(
                                                  mBluePu)),
                                      onPressed: () async {
                                        String url =
                                            'www.google.com/maps/search/?api=1&query=${absenDetail!.absenPulangLat},${absenDetail!.absenPulangLong}';
                                        final Uri launcUri =
                                            Uri(scheme: 'https', path: url);
                                        if (await canLaunchUrl(launcUri)) {
                                          await launchUrl(
                                            launcUri,
                                            mode:
                                                LaunchMode.externalApplication,
                                          );
                                        } else {
                                          throw "Could not launch $url";
                                        }
                                      },
                                      child: const Text(
                                        'MAPS',
                                      ),
                                    ),
                                  ),
                                  ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 0.1,
                                      horizontal: 10,
                                    ),
                                    title: const Text('Foto'),
                                    subtitle: SizedBox(
                                      height: 200,
                                      child: Image.network(
                                        '$apiServerF/storage/uploads/${absenDetail!.absenPulangPic}',
                                        scale: 0.5,
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
    );
  }
}
