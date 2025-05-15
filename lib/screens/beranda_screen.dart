import 'dart:async';

import 'package:intl/intl.dart';
import 'package:presensi/screens/comps/beranda_comps.dart';
import 'package:presensi/screens/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:presensi/constants/color_constant.dart';
import 'package:presensi/constants/style_contant.dart';
import 'package:presensi/models/absen_model.dart';
import 'package:presensi/services/absen_services.dart';

class BerandaScreen extends StatefulWidget {
  const BerandaScreen({super.key});

  @override
  State<BerandaScreen> createState() => _BerandaScreenState();
}

class _BerandaScreenState extends State<BerandaScreen> {
  AbsenService get serviceAbsen => GetIt.I<AbsenService>();

  List<AbsenHome>? absenHome;

  bool _isLoading = false;
  bool _isError = false;

  String errorMessage = 'Terjadi Masalah, Silahkan Muat Kembali';

  int? _day;
  int? _month;
  int? _year;
  int? _weekDay;
  String? _dayName;
  String? _monthName;

  int? _hour;
  int? _min;
  int? _sec;

  String? month;
  String? year;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _day = DateTime.now().day;
    _weekDay = DateTime.now().weekday;
    _month = DateTime.now().month;
    _year = DateTime.now().year;
    _dayName = getDay(_weekDay!);
    _monthName = getMonth(_month!);

    _hour = DateTime.now().hour;
    _min = DateTime.now().minute;
    _sec = DateTime.now().second;
    final DateTime now = DateTime.now();
    final monthDate = DateFormat('MM');
    final yearDate = DateFormat('yyyy');
    month = monthDate.format(now);
    year = yearDate.format(now);
    Timer.periodic(const Duration(seconds: 1), (Timer t) => getDate());

    serviceAbsen.getAbsenHome().then((value) async {
      setState(() {
        absenHome = value.data;
        _isLoading = false;
        if (value.data == null) {
        } else {
          _isError = false;
        }

        if (value.error) {
          errorMessage = value.errorMessage!;
        } else {}
      });
    });
  }

  getDate() {
    setState(() {
      _isLoading = true;
      _day = DateTime.now().day;
      _weekDay = DateTime.now().weekday;
      _month = DateTime.now().month;
      _year = DateTime.now().year;
      _dayName = getDay(_weekDay!);
      _monthName = getMonth(_month!);

      _hour = DateTime.now().hour;
      _min = DateTime.now().minute;
      _sec = DateTime.now().second;
      _isLoading = false;
    });
  }

  final columns = ['Tanggal', 'Ket', 'Status', 'Aksi'];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ListView(
      physics: const ClampingScrollPhysics(),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 24),
          child: Text(
            'Halo, Selamat Datang Di Aplikasi Absensi 👋',
            style: mTitleStyle,
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.only(left: 16, right: 16),
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: mBackgroundColor,
                  borderRadius: BorderRadius.circular(8),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/m_def_fav.png'),
                    fit: BoxFit.fill,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0, 1.0), //(x,y)
                      blurRadius: 6.0,
                    )
                  ],
                ),
                width: MediaQuery.of(context).size.width,
                height: 90,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          margin: const EdgeInsets.only(left: 5, right: 16),
          padding: const EdgeInsets.only(left: 16, bottom: 24),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '$_dayName, $_day $_monthName $_year',
                    textAlign: TextAlign.center,
                    style: mDateStyle,
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '$_hour : $_min : $_sec',
                    textAlign: TextAlign.center,
                    style: mTimeStyle,
                  ),
                ],
              ),
            ],
          ),
        ),
        _isLoading
            ? const Center(
                child: Column(
                  children: <Widget>[
                    CircularProgressIndicator(
                      color: mBluePu,
                    )
                  ],
                ),
              )
            : _isError
                ? Center(
                    child: Column(
                      children: <Widget>[
                        Text(
                          errorMessage,
                        )
                      ],
                    ),
                  )
                : MenuSection(
                    changeOptions: 0,
                    month: month!,
                    year: year!,
                  ),
        SizedBox(
          height: 20,
        ),
        Center(
          child: Column(
            children: <Widget>[
              const Text(
                'Data Presensi Terakhir',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              absenHome == null
                  ? const Column(
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Belum Ada Data Presensi',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    )
                  : Container(
                      height: absenHome!.length > 3 ? size.height / 3 : 200,
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: ListView(
                        children: List.generate(absenHome!.length, (index) {
                          return AbsensiItem(
                            id: absenHome![index].absenId,
                            tanggalMasuk: absenHome![index].absenTgl,
                            status: absenHome![index].absenStatus,
                            jamMasuk: absenHome![index].absenMsk,
                            jamKeluar: absenHome![index].absenPlg,
                            totalJam: absenHome![index].absenLok,
                            lmbtcpt: absenHome![index].absenKet,
                          );
                        }),
                      ),
                    ),
            ],
          ),
        ),
        SizedBox(
          height: absenHome == null
              ? 100
              : absenHome!.length > 3
                  ? 20
                  : 250,
        ),
        const Center(
          child: SizedBox(
            height: 80,
            child: Column(
              children: <Widget>[
                Text('KEMENTRIAN PUPR'),
                Text('Direktorat Jendral Sumber Daya Air'),
                Text('Balai Wilayah Sungai Sulawesi III'),
              ],
            ),
          ),
        )
      ],
    );
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map(
        (String column) => DataColumn(
            label: Text(
          column,
          style: const TextStyle(fontWeight: FontWeight.bold),
        )),
      )
      .toList();

  List<DataRow> getRows(List<AbsenHome>? absenHome) =>
      absenHome!.map((AbsenHome absen) {
        final cells = [
          Text(absen.absenTgl),
          Text(absen.absenKet),
          Text(absen.absenStatus),
          SizedBox(
            width: 40,
            child: ButtonDTP(
              child: IconButton(
                color: mBluePu,
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(
                      id: absen.absenId,
                      changeOptions: 0,
                    ),
                  ),
                ),
                iconSize: 20,
                icon: const Icon(
                  Icons.remove_red_eye_outlined,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ];
        return DataRow(cells: getCells(cells));
      }).toList();

  List<DataCell> getCells(List<dynamic> cells) =>
      cells.map((data) => DataCell(data)).toList();
}

String? getDay(int weekDay) {
  String t = "";
  switch (weekDay) {
    case 1:
      {
        t = "Senin";
        break;
      }
    case 2:
      {
        t = "Selasa";
        break;
      }
    case 3:
      {
        t = "Rabu";
        break;
      }
    case 4:
      {
        t = "Kamis";
        break;
      }
    case 5:
      {
        t = "Jumat";
        break;
      }
    case 6:
      {
        t = "Sabtu";
        break;
      }
    case 7:
      {
        t = "Minggu";
        break;
      }
  }
  return t;
}

String? getMonth(int month) {
  String t = "";
  switch (month) {
    case 1:
      {
        t = "Jan";
        break;
      }
    case 2:
      {
        t = "Feb";
        break;
      }
    case 3:
      {
        t = "Mar";
        break;
      }
    case 4:
      {
        t = "Apr";
        break;
      }
    case 5:
      {
        t = "Mei";
        break;
      }
    case 6:
      {
        t = "Jun";
        break;
      }
    case 7:
      {
        t = "Jul";
        break;
      }
    case 8:
      {
        t = "Agu";
        break;
      }
    case 9:
      {
        t = "Sep";
        break;
      }
    case 10:
      {
        t = "Okt";
        break;
      }
    case 11:
      {
        t = "Nov";
        break;
      }
    case 12:
      {
        t = "Des";
        break;
      }
  }
  return t;
}
