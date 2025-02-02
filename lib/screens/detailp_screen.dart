import 'dart:async';
import 'dart:io';

import 'package:presensi/constants/color_constant.dart';
import 'package:presensi/constants/style_contant.dart';
import 'package:presensi/models/sisp_model.dart';
import 'package:presensi/screens/comps/profil_comps.dart';
import 'package:presensi/screens/detailpc_screen.dart';
import 'package:presensi/screens/home_screen.dart';
import 'package:presensi/screens/masuk_screen.dart';
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
  SispServices get serviceSisp => GetIt.I<SispServices>();

  bool _isLoading = false;
  bool _isError = false;

  String errorMessage = 'Terjadi Masalah, Silahkan Muat Kembali';

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
    return Scaffold(
      backgroundColor: mBackgroundColor,
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
                        ProfilPicSection(
                          pic: sisp!.sispPic,
                          nama: sisp!.sispNama,
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
                                700,
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
                        ProfilDetailSection(
                          nm: sisp!.sispNama,
                          kntrk: sisp!.sispKntrk,
                          tglkntrk: sisp!.sispTglKntrk,
                          satker: sisp!.satkerNm,
                          ppk: sisp!.bagNm,
                          tmptlhr: sisp!.sispTmptLhr,
                          tgllhr: sisp!.sispTglLhrAltT,
                          pdNm: sisp!.sispPdNm,
                          alt: sisp!.sispAlt,
                          jk: sisp!.sispJK,
                          telp: sisp!.sispTelp,
                          wa: sisp!.sispWa,
                          wak: sisp!.sispWak,
                        ),
                      ],
                    ),
    );
  }
}
