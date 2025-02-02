import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:presensi/constants/var_constant.dart';
import 'package:presensi/models/api_response.dart';
import 'package:http/http.dart' as http;
import 'package:presensi/models/setpd_model.dart';
import 'package:presensi/services/file_services.dart';

class SetpdServices {
  Future<APIResponse<List<Setpd>>> getPd() async {
    Uri newApiUrl = Uri.parse('$apiServerN/setpd');
    final token = await FileUtilsUser.getToken();
    return http.get(newApiUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    }).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body)['data'];
        final satker = <Setpd>[];
        for (var item in jsonData) {
          satker.add(Setpd.fromJson(item));
        }
        return APIResponse<List<Setpd>>(data: satker);
      } else {
        final jsonData = json.decode(data.body)['message'];
        return APIResponse<List<Setpd>>(
            error: true, errorMessage: jsonData, color: Colors.red);
      }
    }).catchError(
      (_) => APIResponse<List<Setpd>>(
        error: true,
        errorMessage: 'Terjadi Kesalahan',
        color: Colors.red,
      ),
    );
  }
}
