import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:get_it/get_it.dart';
import 'package:presensi/constants/color_constant.dart';
import 'package:presensi/constants/prepdf_items.dart';
import 'package:presensi/constants/style_contant.dart';
import 'package:presensi/models/lap_model.dart';
import 'package:presensi/screens/lapd_screen.dart';
import 'package:presensi/screens/lapu_screen.dart';
import 'package:presensi/screens/masuk_screen.dart';
import 'package:presensi/services/lap_services.dart';

class LapSection extends StatefulWidget {
  const LapSection({
    super.key,
  });

  @override
  State<LapSection> createState() => _LapSectionState();
}

class _LapSectionState extends State<LapSection> {
  LapServices get serviceLap => GetIt.I<LapServices>();
  List<Laporan>? laporan;

  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _isLoading = true;
    });
    serviceLap.getLaporan().then((value) async {
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
        laporan = value.data;
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
            : laporan!.isEmpty
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
                    children: List.generate(
                      laporan!.length,
                      (index) {
                        return LapItem(
                          id: laporan![index].lapId,
                          lapBln: laporan![index].lapBln,
                          lapKet: laporan![index].lapKet,
                          lapNl: laporan![index].lapNl,
                          lapThn: laporan![index].lapThn.toString(),
                          lapFl: laporan![index].lapFl,
                        );
                      },
                    ),
                  ),
      ),
    );
  }
}

class LapItem extends StatelessWidget {
  const LapItem({
    super.key,
    required this.lapBln,
    required this.lapThn,
    required this.lapFl,
    required this.lapNl,
    required this.lapKet,
    required this.id,
  });

  final String lapBln;
  final String lapThn;
  final String lapFl;
  final int lapNl;

  final String lapKet;
  final String id;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        Container(
          height: lapNl == 0 ? 140 : 190,
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
            padding: lapNl != 0
                ? const EdgeInsets.only(left: 20, right: 20, top: 20)
                : const EdgeInsets.only(
                    left: 20, right: 20, top: 20, bottom: 0),
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
                          '$lapBln $lapThn',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    lapNl == 0
                        ? Text(
                            'Belum Dinilai',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          )
                        : RatingBar.builder(
                            initialRating: lapNl.toDouble(),
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemCount: 5,
                            itemSize: 20,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {},
                          ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 10,
                      children: <Widget>[
                        Container(
                          width: (size.width / 2.5) - 20,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.015),
                                spreadRadius: 10,
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PrePdf(
                                    name:
                                        'Berkas Laporan Bulan $lapBln Tahun $lapThn',
                                    pdf: lapFl,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                gradient: const LinearGradient(
                                  colors: [
                                    mBluePu,
                                    mBluePu,
                                  ],
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'LAPORAN',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: (size.width / 2.5) - 20,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.015),
                                spreadRadius: 10,
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LapuScreen(
                                    bln: lapBln,
                                    thn: lapThn,
                                    id: id,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                gradient: const LinearGradient(
                                  colors: [
                                    mYellowPu,
                                    mYellowPu,
                                  ],
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'UBAH',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    lapKet != ''
                        ? Column(
                            children: <Widget>[
                              Divider(),
                              DefaultButton(
                                text: "KETERANGAN",
                                press: () => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LapdScreen(
                                      ket: lapKet,
                                      bln: lapBln,
                                      thn: lapThn,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Container()
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
