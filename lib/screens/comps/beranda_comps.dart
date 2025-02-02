import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:presensi/constants/color_constant.dart';
import 'package:presensi/constants/var_constant.dart';
import 'package:presensi/screens/absenlist_screen.dart';
import 'package:presensi/screens/detail_screen.dart';
import 'package:presensi/screens/lap_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class AbsensiItem extends StatelessWidget {
  const AbsensiItem({
    super.key,
    required this.tanggalMasuk,
    required this.status,
    required this.jamMasuk,
    required this.jamKeluar,
    required this.totalJam,
    required this.lmbtcpt,
    required this.id,
  });

  final String tanggalMasuk;
  final String status;
  final String jamMasuk;
  final String jamKeluar;
  final String totalJam;
  final String lmbtcpt;
  final String id;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailScreen(
                id: id,
                changeOptions: 1,
              ),
            ),
          ),
          child: Container(
            height: status != 'H'
                ? 70
                : lmbtcpt != ''
                    ? 190
                    : 140,
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
              padding: status == 'H'
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
                            tanggalMasuk,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            status == 'H' ? totalJam : '',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black.withOpacity(0.5),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        status == 'H'
                            ? 'HADIR'
                            : status == 'I'
                                ? 'IZIN'
                                : 'TIDAK HADIR',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: status == 'H'
                              ? Colors.green
                              : status == 'I'
                                  ? Colors.blue
                                  : Colors.red,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: status == 'H' ? 15 : 0,
                  ),
                  status == 'H'
                      ? Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.green,
                                      ),
                                      child: Center(
                                        child: SvgPicture.asset(
                                          "assets/icons/sign_in.svg",
                                          width: 25,
                                          height: 25,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          overflow: TextOverflow.clip,
                                          "MASUK",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          status == 'H'
                                              ? jamMasuk
                                              : 'TIDAK ABSEN',
                                          style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.red,
                                      ),
                                      child: Center(
                                        child: SvgPicture.asset(
                                          "assets/icons/sign_out.svg",
                                          width: 25,
                                          height: 25,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          overflow: TextOverflow.clip,
                                          "KELUAR",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          status == 'H'
                                              ? jamKeluar
                                              : 'TIDAK ADA',
                                          style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                            lmbtcpt != ''
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Divider(
                                        thickness: 0.1,
                                        color: Colors.black.withOpacity(0.5),
                                      ),
                                      const Text(
                                        'KETERANGAN:',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        lmbtcpt,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  )
                                : Container()
                          ],
                        )
                      : Container(
                          height: 0,
                        ),
                ],
              ),
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

class MenuSection extends StatefulWidget {
  final String month;
  final String year;
  final int changeOptions;
  const MenuSection(
      {super.key,
      required this.changeOptions,
      required this.month,
      required this.year});

  @override
  State<MenuSection> createState() => _MenuSectionState();
}

class _MenuSectionState extends State<MenuSection> {
  late int _changeOptions;

  @override
  void initState() {
    super.initState();
    setState(() {
      _changeOptions = widget.changeOptions;
    });
  }

  @override
  Widget build(BuildContext context) {
    List itemMenu = [
      {
        "title": "ABSENSI",
        "icon": Icons.timer_outlined,
        "onTap": () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => AbsenlistScreen(
                  absBln: int.parse(widget.month),
                  absThn: int.parse(widget.year),
                  changeOptions: widget.changeOptions,
                ),
              ),
            ),
      },
      {
        "title": "LAPORAN",
        "icon": Icons.calendar_month,
        "onTap": () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LapScreen(),
              ),
            ),
      },
      {
        "title": "WEB",
        "icon": Icons.link,
        "onTap": () async {
          String type = apiServer.substring(0, apiServer.indexOf(':'));
          String result = apiServer.substring(0, apiServer.indexOf('//'));
          String nResult = '$result//';
          String resultN =
              apiServer.substring(nResult.length, apiServer.length);

          final Uri launcUri = Uri(scheme: type, path: resultN);
          if (await canLaunchUrl(launcUri)) {
            await launchUrl(
              launcUri,
              mode: LaunchMode.externalApplication,
            );
          } else {
            throw "Could not launch $apiServer";
          }
        },
      },
    ];
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Wrap(
            spacing: 10,
            children: List.generate(
              itemMenu.length,
              (index) {
                return Container(
                  width: (size.width / 4) - 20,
                  height: 100,
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: itemMenu[index]['onTap'],
                        child: Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            gradient: const LinearGradient(
                              colors: [
                                mBluePu,
                                mBluePu,
                              ],
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              itemMenu[index]['icon'],
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        itemMenu[index]['title'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black.withOpacity(0.5),
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
