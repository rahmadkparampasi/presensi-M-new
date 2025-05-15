import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:presensi/constants/color_constant.dart';
import 'package:presensi/constants/style_contant.dart';
import 'package:presensi/models/survei_model.dart';
import 'package:presensi/screens/masuk_screen.dart';
import 'package:presensi/screens/surveid_screen.dart';
import 'package:presensi/services/survei_services.dart';

class SurveiSection extends StatefulWidget {
  const SurveiSection({super.key});

  @override
  State<SurveiSection> createState() => _SurveiSectionState();
}

class _SurveiSectionState extends State<SurveiSection> {
  SurveiServices get serviceSurvei => GetIt.I<SurveiServices>();
  List<Survei>? survei;

  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _isLoading = true;
    });

    serviceSurvei.getSurvei().then((value) async {
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
        survei = value.data;
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
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Container(
        margin: const EdgeInsets.only(bottom: 50),
        width: double.infinity,
        height: (size.height / 100) * 70,
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        child: _isLoading
            ? const Column(
                children: <Widget>[
                  CircularProgressIndicator(
                    color: mBluePu,
                  ),
                ],
              )
            : survei!.isEmpty
                ? const Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Belum Ada Data Laporan',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  )
                : ListView(
                    children: List.generate(survei!.length, (index) {
                      return SurveiItem(
                        surveiThn: survei![index].surveiThn.toString(),
                        id: survei![index].surveiId,
                        nama: survei![index].surveiNama,
                      );
                    }),
                  ),
      ),
    );
  }
}

class SurveiItem extends StatelessWidget {
  const SurveiItem({
    super.key,
    required this.surveiThn,
    required this.id,
    required this.nama,
  });

  final String surveiThn;
  final String id;
  final String nama;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        Container(
          height: 140,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 5.0,
                  offset: const Offset(0.0, 1)),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          overflow: TextOverflow.clip,
                          'Survei Tahun',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      surveiThn,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Column(
                  children: <Widget>[
                    Divider(),
                    DefaultButton(
                      text: "DETAIL",
                      press: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SurveidScreen(
                            id: id,
                            nm: nama,
                            thn: surveiThn,
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
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
