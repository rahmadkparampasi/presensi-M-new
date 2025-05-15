import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:presensi/constants/var_constant.dart';
import 'package:presensi/models/api_response.dart';
import 'package:presensi/models/survei_model.dart';
import 'package:presensi/services/file_services.dart';
import 'package:http/http.dart' as http;

class SurveiServices {
  Future<APIResponse<List<Survei>>> getSurvei() async {
    Uri newApiUrl = Uri.parse('$apiServerN/survei/profil');
    final token = await FileUtilsUser.getToken();
    return http.get(newApiUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    }).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body)['data'];

        final absen = <Survei>[];
        for (var item in jsonData) {
          absen.add(Survei.fromJson(item));
        }
        return APIResponse<List<Survei>>(data: absen, status: data.statusCode);
      } else {
        final jsonData = json.decode(data.body)['message'];
        return APIResponse<List<Survei>>(
          error: true,
          errorMessage: jsonData,
        );
      }
    }).catchError((_) => APIResponse<List<Survei>>(
          error: true,
          errorMessage: 'Terjadi Kesalahan',
          status: 500,
        ));
  }

  Future<APIResponse<List<SurveiD>>> getDetail(String id) async {
    Uri newApiUrl = Uri.parse('$apiServerN/survei/profilA/$id');
    final token = await FileUtilsUser.getToken();
    return http.get(newApiUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    }).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body)['data'];

        final absen = <SurveiD>[];
        for (var item in jsonData) {
          absen.add(SurveiD.fromJson(item));
        }
        return APIResponse<List<SurveiD>>(data: absen, status: data.statusCode);
      } else {
        final jsonData = json.decode(data.body)['message'];
        return APIResponse<List<SurveiD>>(
          error: true,
          errorMessage: jsonData,
        );
      }
    }).catchError((_) => APIResponse<List<SurveiD>>(
          error: true,
          errorMessage: 'Terjadi Kesalahan',
          status: 500,
        ));
  }
}
