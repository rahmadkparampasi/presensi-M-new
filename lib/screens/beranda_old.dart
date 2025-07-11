import 'dart:async';

import 'package:presensi/constants/var_constant.dart';
import 'package:presensi/screens/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:presensi/constants/color_constant.dart';
import 'package:presensi/constants/style_contant.dart';
import 'package:presensi/models/absen_model.dart';
import 'package:presensi/services/absen_services.dart';
import 'package:url_launcher/url_launcher.dart';

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
    Timer.periodic(const Duration(seconds: 1), (Timer t) => getDate());
  }

  getDate() {
    setState(() {
      _day = DateTime.now().day;
      _weekDay = DateTime.now().weekday;
      _month = DateTime.now().month;
      _year = DateTime.now().year;
      _dayName = getDay(_weekDay!);
      _monthName = getMonth(_month!);

      _hour = DateTime.now().hour;
      _min = DateTime.now().minute;
      _sec = DateTime.now().second;
    });
  }

  final columns = ['Tanggal', 'Ket', 'Status', 'Aksi'];

  @override
  Widget build(BuildContext context) {
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
                : Center(
                    child: Column(
                      children: <Widget>[
                        const Text(
                          'Data Presensi',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Divider(),
                        const SizedBox(
                          height: 5,
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
                                padding:
                                    const EdgeInsets.only(left: 8, right: 8),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: DataTable(
                                      columns: getColumns(columns),
                                      rows: getRows(absenHome)),
                                ),
                              ),
                      ],
                    ),
                  ),
        const SizedBox(
          height: 10,
        ),
        Container(
          padding: const EdgeInsets.only(right: 40, left: 40),
          width: 100,
          height: 50,
          child: ElevatedButton(
            onPressed: () async {
              String type = apiServerN.substring(0, apiServerN.indexOf(':'));
              String result = apiServerN.substring(0, apiServerN.indexOf('//'));
              String nResult = '$result//';
              String resultN =
                  apiServerN.substring(nResult.length, apiServerN.length);

              final Uri launcUri = Uri(scheme: type, path: resultN);
              if (await canLaunchUrl(launcUri)) {
                await launchUrl(
                  launcUri,
                  mode: LaunchMode.externalApplication,
                );
              } else {
                throw "Could not launch $apiServerN";
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: mBluePu,
              fixedSize: const Size(200, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 3,
            ),
            child: const Text(
              'BUKA WEBSITE',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        ),
        SizedBox(
          height: absenHome == null
              ? 280
              : absenHome!.length > 5
                  ? 50
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
