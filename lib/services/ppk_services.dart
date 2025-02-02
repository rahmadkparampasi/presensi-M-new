import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:presensi/constants/var_constant.dart';
import 'package:presensi/models/api_response.dart';
import 'package:presensi/models/ppk_model.dart';
import 'package:http/http.dart' as http;

class PpkServices {
  Future<APIResponse<List<Ppk>>> getPpk(String satker) {
    Uri newApiUrl = Uri.parse('$apiServerN/ppk/$satker');
    return http
        .get(newApiUrl, headers: {'Accept': 'application/json'}).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body)['data'];
        final satker = <Ppk>[];
        for (var item in jsonData) {
          satker.add(Ppk.fromJson(item));
        }
        return APIResponse<List<Ppk>>(data: satker);
      } else {
        final jsonData = json.decode(data.body)['message'];
        return APIResponse<List<Ppk>>(
            error: true, errorMessage: jsonData, color: Colors.red);
      }
    }).catchError(
      (_) => APIResponse<List<Ppk>>(
        error: true,
        errorMessage: 'Terjadi Kesalahan',
        color: Colors.red,
      ),
    );
  }
}
