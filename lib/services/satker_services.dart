import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:presensi/constants/var_constant.dart';
import 'package:presensi/models/api_response.dart';
import 'package:presensi/models/satker_model.dart';
import 'package:http/http.dart' as http;

class SatkerServices {
  Future<APIResponse<List<Satker>>> getSatker() {
    Uri newApiUrl = Uri.parse('$apiServerN/satker');
    return http
        .get(newApiUrl, headers: {'Accept': 'application/json'}).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body)['data'];
        final satker = <Satker>[];
        for (var item in jsonData) {
          satker.add(Satker.fromJson(item));
        }
        return APIResponse<List<Satker>>(data: satker);
      } else {
        final jsonData = json.decode(data.body)['message'];
        return APIResponse<List<Satker>>(
            error: true, errorMessage: jsonData, color: Colors.red);
      }
    }).catchError(
      (_) => APIResponse<List<Satker>>(
        error: true,
        errorMessage: 'Terjadi Kesalahan',
        color: Colors.red,
      ),
    );
  }
}
