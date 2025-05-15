import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:presensi/constants/color_constant.dart';
import 'package:presensi/constants/logic_constant.dart';
import 'package:presensi/constants/style_contant.dart';
import 'package:presensi/models/absen_model.dart';
import 'package:presensi/screens/absenlist_screen.dart';
import 'package:presensi/screens/comps/beranda_comps.dart';
import 'package:presensi/screens/masuk_screen.dart';
import 'package:presensi/services/absen_services.dart';

class AbsensiBottomDetailSection extends StatefulWidget {
  final String id;

  const AbsensiBottomDetailSection({
    super.key,
    required this.id,
  });

  @override
  State<AbsensiBottomDetailSection> createState() =>
      _AbsensiBottomKalDetailSectionState();
}

class _AbsensiBottomKalDetailSectionState
    extends State<AbsensiBottomDetailSection> {
  bool _isLoading = false;

  AbsenService get serviceAbsen => GetIt.I<AbsenService>();

  AbsenDetail? absenDetail;

  @override
  void initState() {
    //Edit : Ambil Data Dari Web
    // TODO: implement initState
    super.initState();
    setState(() {
      _isLoading = true;
    });
    serviceAbsen.getAbsenDetail(widget.id).then((value) async {
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
    return _isLoading
        ? SizedBox(
            width: MediaQuery.of(context).size.width,
            child: const Column(
              children: <Widget>[
                CircularProgressIndicator(
                  color: mBluePu,
                ),
              ],
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      iconColor: Colors.black,
                      foregroundColor: Colors.transparent,
                      backgroundColor: Colors.transparent,
                      overlayColor: Colors.transparent,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    label: Text(
                      'DETAIL ABSENSI ${absenDetail!.absenTgl.toUpperCase()}',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    icon: const Icon(
                      Icons.arrow_back,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 600,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        DetailItemWOIcon(
                          title: 'Status',
                          subtitle: absenDetail!.absenStatus,
                          isLast: false,
                          img: false,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        DetailItemWOIcon(
                          title: 'Tanggal',
                          subtitle: absenDetail!.absenTgl,
                          isLast: false,
                          img: false,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'MASUK',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Divider(),
                        DetailItemWOIcon(
                          title: 'Jam Masuk',
                          subtitle: absenDetail!.absenMsk,
                          isLast: false,
                          img: false,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        DetailItemWOIcon(
                          title: 'Cepat Datang',
                          subtitle: absenDetail!.absenCd,
                          isLast: false,
                          img: false,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        DetailItemWOIcon(
                          title: 'Lambat',
                          subtitle: absenDetail!.absenLmbt,
                          isLast: false,
                          img: false,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        DetailItemWOIcon(
                          title: 'Lokasi Masuk',
                          subtitle: absenDetail!.absenMskLoc,
                          isLast: false,
                          img: false,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        DetailItemWOIcon(
                          title: 'Foto Masuk',
                          subtitle: absenDetail!.absenMskPic,
                          isLast: false,
                          img: true,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'PULANG',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Divider(),
                        DetailItemWOIcon(
                          title: 'Jam Pulang',
                          subtitle: absenDetail!.absenKeluar,
                          isLast: false,
                          img: false,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        DetailItemWOIcon(
                          title: 'Cepat Pulang',
                          subtitle: absenDetail!.absenCp,
                          isLast: false,
                          img: false,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        DetailItemWOIcon(
                          title: 'Lambat Pulang',
                          subtitle: absenDetail!.absenLbh,
                          isLast: false,
                          img: false,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        DetailItemWOIcon(
                          title: 'Lokasi Pulang',
                          subtitle: absenDetail!.absenKeluarLoc,
                          isLast: false,
                          img: false,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        DetailItemWOIcon(
                          title: 'Foto Pulang',
                          subtitle: absenDetail!.absenPulangPic,
                          isLast: false,
                          img: true,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        DetailItemWOIcon(
                          title: 'Jam Pulang Seharusnya',
                          subtitle: absenDetail!.absenPsn,
                          isLast: false,
                          img: false,
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
  }
}

class AbsensiRekapSection extends StatelessWidget {
  const AbsensiRekapSection({
    super.key,
    required this.itemMenu,
    required this.size,
    required this.date,
    required this.dateName,
  });

  final List itemMenu;
  final Size size;
  final bool date;
  final String dateName;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        date
            ? Text(
                //Edit: Ambil Data Dari Web
                dateName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              )
            : Container(),
        const SizedBox(
          height: 10,
        ),
        Center(
          child: Wrap(
            spacing: 20,
            children: List.generate(itemMenu.length, (index) {
              return Container(
                width: (size.width / 4) - 5,
                height: 90,
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
                    Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: itemMenu[index]['color1'],
                      ),
                      child: Center(
                        child: Text(
                          '${itemMenu[index]['icon']}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
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
            }),
          ),
        ),
      ],
    );
  }
}

class AbsensiBottomSection extends StatefulWidget {
  final int absThn;
  final int absBln;

  final int changeOptions;

  const AbsensiBottomSection({
    super.key,
    required this.absThn,
    required this.absBln,
    required this.changeOptions,
  });

  @override
  State<AbsensiBottomSection> createState() => _AbsensiBottomSectionState();
}

class _AbsensiBottomSectionState extends State<AbsensiBottomSection> {
  late int _absThn;
  late int _absBln;
  late int _changeOptions;

  final TextEditingController _absThnTE = TextEditingController();
  final TextEditingController _absBlnTE = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _changeOptions = widget.changeOptions;
      _absThn = widget.absThn;
      _absBln = widget.absBln;
      _absThnTE.text = widget.absThn.toString();
      _absBlnTE.text = monthConver(_absBln);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              const SizedBox(
                height: 10,
              ),
              Center(
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                    iconColor: Colors.black,
                    foregroundColor: Colors.transparent,
                    backgroundColor: Colors.transparent,
                    overlayColor: Colors.transparent,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  label: const Text(
                    'LIHAT DATA',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  icon: const Icon(
                    Icons.arrow_back,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _absThnTE,
                onTap: () {
                  Navigator.pop(context);
                  showBottomModal(
                    context,
                    AbsensiBottomAbsThnSection(
                      absBln: _absBln,
                      absThn: _absThn,
                      changeOptions: _changeOptions,
                    ),
                    300,
                  );
                },
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'TAHUN',
                  hintText: 'Masukan Tahun',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _absBlnTE,
                onTap: () {
                  Navigator.pop(context);
                  showBottomModal(
                    context,
                    AbsensiBottomAbsBlnSection(
                      absBln: _absBln,
                      absThn: _absThn,
                      changeOptions: _changeOptions,
                    ),
                    300,
                  );
                },
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'BULAN',
                  hintText: 'Masukan Bulan',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    DefaultCostumWidthButton(
                      text: 'LIHAT',
                      press: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AbsenlistScreen(
                            //Edit: Ambil Tahun, Bulan
                            absThn: _absThn,
                            absBln: _absBln,
                            changeOptions: _changeOptions,
                          ),
                        ),
                      ),
                      width: size.width / 3,
                      color: mBluePu,
                      splashColor: mBluePu,
                      colorText: Colors.white,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    DefaultCostumWidthButton(
                      text: 'BATAL',
                      press: () {
                        Navigator.pop(context);
                      },
                      width: size.width / 3,
                      color: Colors.grey,
                      splashColor: Colors.grey.shade600,
                      colorText: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AbsensiBottomAbsThnSection extends StatefulWidget {
  final int absThn;
  final int absBln;
  final int changeOptions;
  const AbsensiBottomAbsThnSection(
      {super.key,
      required this.absThn,
      required this.absBln,
      required this.changeOptions});

  @override
  State<AbsensiBottomAbsThnSection> createState() =>
      _AbsensiBottomAbsThnSectionState();
}

class _AbsensiBottomAbsThnSectionState
    extends State<AbsensiBottomAbsThnSection> {
  late int _absThn;
  late int _absBln;

  late int _changeOptions;

  bool _isLoading = false;

  List<AbsenGetYear>? absenGetYear;

  AbsenService get serviceAbsen => GetIt.I<AbsenService>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _absThn = widget.absThn;
      _absBln = widget.absBln;
      _changeOptions = widget.changeOptions;
      _isLoading = true;
    });

    serviceAbsen.getYear().then((value) async {
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
        absenGetYear = value.data;
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
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: _isLoading
          ? const Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: CircularProgressIndicator(
                    color: mBluePu,
                  ),
                ),
              ],
            )
          : Column(
              children: <Widget>[
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      iconColor: Colors.black,
                      foregroundColor: Colors.transparent,
                      backgroundColor: Colors.transparent,
                      overlayColor: Colors.transparent,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      showBottomModal(
                        context,
                        AbsensiBottomSection(
                          absBln: _absBln,
                          absThn: _absThn,
                          changeOptions: _changeOptions,
                        ),
                        420,
                      );
                    },
                    label: const Text(
                      'LIHAT TAHUN DATA',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    icon: const Icon(
                      Icons.arrow_back,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 200,
                  child: absenGetYear == null
                      ? const Text(
                          'Belum Ada Data Absen',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        )
                      : ListView(
                          children: List.generate(
                            //Edit: Ambil Data Dari Web
                            absenGetYear!.length,
                            (index) {
                              return Column(
                                children: <Widget>[
                                  ListTile(
                                    //Edit: Ambil Data Dari Web
                                    onTap: () {
                                      Navigator.pop(context);
                                      showBottomModal(
                                        context,
                                        AbsensiBottomSection(
                                          absBln: _absBln,
                                          absThn: absenGetYear![index].year,
                                          changeOptions: _changeOptions,
                                        ),
                                        420,
                                      );
                                    },
                                    minLeadingWidth: 0,
                                    title: Text(
                                      absenGetYear![index].year.toString(),
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 15),
                                    ),
                                  ),
                                  const Divider(),
                                ],
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
    );
  }
}

class AbsensiBottomAbsBlnSection extends StatefulWidget {
  final int absThn;
  final int absBln;

  final int changeOptions;

  const AbsensiBottomAbsBlnSection({
    super.key,
    required this.absThn,
    required this.absBln,
    required this.changeOptions,
  });

  @override
  State<AbsensiBottomAbsBlnSection> createState() =>
      _AbsensiBottomAbsBlnSectionState();
}

class _AbsensiBottomAbsBlnSectionState
    extends State<AbsensiBottomAbsBlnSection> {
  late int _absThn;
  late int _absBln;
  late int _changeOptions;

  bool _isLoading = false;

  List<AbsenGetMonth>? absenGetMonth;

  AbsenService get serviceAbsen => GetIt.I<AbsenService>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _absThn = widget.absThn;
      _absBln = widget.absBln;
      _changeOptions = widget.changeOptions;
    });
    serviceAbsen.getMonth(widget.absThn.toString()).then((value) async {
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
        absenGetMonth = value.data;
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
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: _isLoading
          ? const Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: CircularProgressIndicator(
                    color: mBluePu,
                  ),
                ),
              ],
            )
          : Column(
              children: <Widget>[
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      iconColor: Colors.black,
                      foregroundColor: Colors.transparent,
                      backgroundColor: Colors.transparent,
                      overlayColor: Colors.transparent,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      showBottomModal(
                        context,
                        AbsensiBottomSection(
                          absBln: _absBln,
                          absThn: _absThn,
                          changeOptions: _changeOptions,
                        ),
                        420,
                      );
                    },
                    label: const Text(
                      'LIHAT BULAN DATA',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    icon: const Icon(
                      Icons.arrow_back,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 200,
                  child: absenGetMonth == null
                      ? const Text(
                          'Belum Ada Data Absen',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        )
                      : ListView(
                          children: List.generate(
                            //Edit: Ambil Data Dari Web
                            absenGetMonth!.length,
                            (index) {
                              return Column(
                                children: <Widget>[
                                  ListTile(
                                    //Edit: Ambil Data Dari Web
                                    onTap: () {
                                      Navigator.pop(context);
                                      showBottomModal(
                                        context,
                                        AbsensiBottomSection(
                                          absBln: int.parse(
                                              absenGetMonth![index].val),
                                          absThn: _absThn,
                                          changeOptions: _changeOptions,
                                        ),
                                        420,
                                      );
                                    },
                                    minLeadingWidth: 0,
                                    title: Text(
                                      absenGetMonth![index].text.toUpperCase(),
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 15),
                                    ),
                                  ),
                                  const Divider(),
                                ],
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
    );
  }
}

class AbsensiSection extends StatefulWidget {
  final String month;
  final String year;
  const AbsensiSection({
    super.key,
    required this.month,
    required this.year,
  });

  @override
  State<AbsensiSection> createState() => _AbsensiSectionState();
}

class _AbsensiSectionState extends State<AbsensiSection> {
  AbsenService get serviceAbsen => GetIt.I<AbsenService>();

  bool _isLoading = false;

  List<AbsenHome>? absenMonth;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _isLoading = true;
    });
    serviceAbsen.getAbsenMonth(widget.month, widget.year).then((value) async {
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
      absenMonth = value.data;

      setState(() {
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
        height: (size.height / 100) * 50,
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
            : absenMonth!.isEmpty
                ? const Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Belum Ada Data Absen',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  )
                : ListView(
                    children: List.generate(
                      absenMonth!.length,
                      (index) {
                        return AbsensiItem(
                          tanggalMasuk: absenMonth![index].absenTgl,
                          status: absenMonth![index].absenStatus,
                          jamMasuk: absenMonth![index].absenMsk,
                          jamKeluar: absenMonth![index].absenPlg,
                          totalJam: absenMonth![index].absenLok,
                          lmbtcpt: absenMonth![index].absenKet,
                          id: absenMonth![index].absenId,
                        );
                      },
                    ),
                  ),
      ),
    );
  }
}
