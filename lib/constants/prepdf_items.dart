import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:presensi/constants/var_constant.dart';

class PrePdf extends StatefulWidget {
  final String pdf;
  final String name;
  const PrePdf({super.key, required this.pdf, required this.name});

  @override
  State<PrePdf> createState() => _PrePdfState();
}

class _PrePdfState extends State<PrePdf> {
  String? pdf;
  String? name;

  String urlPDFPath = "";
  bool exists = true;
  int _totalPages = 0;
  int _currentPage = 0;
  bool pdfReady = false;
  PDFViewController? _pdfViewController;
  bool loaded = false;

  Future<File> getFileFromUrl(String url, {name}) async {
    var fileName = widget.name;
    Uri newApiUrl = Uri.parse(url);

    if (name != null) {
      fileName = name;
    }
    try {
      var data = await http.get(newApiUrl);
      var bytes = data.bodyBytes;
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/$fileName.pdf");

      File urlFile = await file.writeAsBytes(bytes);
      return urlFile;
    } catch (e) {
      throw Exception("Error opening url file");
    }
  }

  @override
  void initState() {
    setState(() {
      pdf = '$apiServerF/storage/uploads/${widget.pdf}';
      name = widget.name;
    });
    getFileFromUrl(pdf!).then(
      (value) => {
        setState(() {
          urlPDFPath = value.path;
          loaded = true;
          exists = true;
        })
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          name!,
          style: const TextStyle(color: Colors.grey),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () async {
                var dir = await getDownloadPath();

                WidgetsFlutterBinding.ensureInitialized();
                await FlutterDownloader.initialize();
                await FlutterDownloader.enqueue(
                    url: pdf!, savedDir: "$dir/${name!}.pdf");
              },
              child: const Icon(
                Icons.download,
                size: 26.0,
                color: Colors.black,
              ),
            ),
          ),
        ],
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.grey),
        titleSpacing: 0.0,
      ),
      body: loaded
          ? PDFView(
              filePath: urlPDFPath,
              autoSpacing: true,
              enableSwipe: true,
              pageSnap: true,
              swipeHorizontal: true,
              nightMode: false,
              onError: (e) {
                //Show some error message or UI
              },
              onRender: (pages) {
                setState(() {
                  _totalPages = pages!;
                  pdfReady = true;
                });
              },
              onViewCreated: (PDFViewController vc) {
                setState(() {
                  _pdfViewController = vc;
                });
              },
              onPageChanged: (int? page, int? total) {
                setState(() {
                  _currentPage = page!;
                });
              },
              onPageError: (page, e) {},
            )
          : exists
              ? const Text(
                  "Loading..",
                  style: TextStyle(fontSize: 20),
                )
              : const Text(
                  "PDF Not Available",
                  style: TextStyle(fontSize: 20),
                ),
    );
  }

  Future<String?> getDownloadPath() async {
    Directory? directory;
    try {
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = Directory('/storage/emulated/0/Download');
        // Put file in global download folder, if for an unknown reason it didn't exist, we fallback
        // ignore: avoid_slow_async_io
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      }
    } catch (err) {
      print("Cannot get download folder path");
    }
    return directory?.path;
  }
}
