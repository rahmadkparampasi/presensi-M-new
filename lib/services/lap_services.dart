import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:presensi/constants/var_constant.dart';
import 'package:http/http.dart' as http;
import 'package:presensi/models/api_response.dart';
import 'package:presensi/models/lap_model.dart';
import 'package:presensi/services/file_services.dart';

class LapServices {
  Future<APIResponse<List<Laporan>>> getLaporan() async {
    Uri newApiUrl = Uri.parse('$apiServerN/lap/profil');
    final token = await FileUtilsUser.getToken();
    return http.get(newApiUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    }).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body)['data'];

        final absen = <Laporan>[];
        for (var item in jsonData) {
          absen.add(Laporan.fromJson(item));
        }
        return APIResponse<List<Laporan>>(data: absen, status: data.statusCode);
      } else {
        final jsonData = json.decode(data.body)['message'];
        return APIResponse<List<Laporan>>(
          error: true,
          errorMessage: jsonData,
        );
      }
    }).catchError((_) => APIResponse<List<Laporan>>(
          error: true,
          errorMessage: 'Terjadi Kesalahan',
          status: 500,
        ));
  }

  Future<APIResponse<List<Year>>> getYear() async {
    Uri newApiUrl = Uri.parse('$apiServerN/lap/year');
    final token = await FileUtilsUser.getToken();
    return http.get(newApiUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    }).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body)['data'];

        final absen = <Year>[];
        for (var item in jsonData) {
          absen.add(Year.fromJson(item));
        }
        return APIResponse<List<Year>>(data: absen, status: data.statusCode);
      } else {
        final jsonData = json.decode(data.body)['message'];
        return APIResponse<List<Year>>(
          error: true,
          errorMessage: jsonData,
        );
      }
    }).catchError((_) => APIResponse<List<Year>>(
          error: true,
          errorMessage: 'Terjadi Kesalahan',
          status: 500,
        ));
  }

  Future<APIResponse<List<Month>>> getMonth() async {
    Uri newApiUrl = Uri.parse('$apiServerN/lap/month');
    final token = await FileUtilsUser.getToken();
    return http.get(newApiUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    }).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body)['data'];

        final absen = <Month>[];
        for (var item in jsonData) {
          absen.add(Month.fromJson(item));
        }
        return APIResponse<List<Month>>(data: absen, status: data.statusCode);
      } else {
        final jsonData = json.decode(data.body)['message'];
        return APIResponse<List<Month>>(
          error: true,
          errorMessage: jsonData,
        );
      }
    }).catchError((_) => APIResponse<List<Month>>(
          error: true,
          errorMessage: 'Terjadi Kesalahan',
          status: 500,
        ));
  }

  Future<APIResponse> createLap(
    String bln,
    String thn,
    String path,
  ) async {
    Uri newApiUrl = Uri.parse('$apiServerN/lap/insert');
    final token = await FileUtilsUser.getToken();

    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final send = http.MultipartRequest('POST', newApiUrl);

    send.fields["lap_bln"] = bln;
    send.fields["lap_thn"] = thn;

    send.files.add(await http.MultipartFile.fromPath(
      'lap_fl',
      path,
    ));
    send.headers.addAll(headers);
    try {
      final streamedResponse = await send.send();

      final response = await http.Response.fromStream(streamedResponse);

      if (streamedResponse.statusCode == 200) {
        return APIResponse(
          status: streamedResponse.statusCode,
        );
      } else {
        final jsonData = json.decode(response.body);

        return APIResponse(
          error: true,
          errorMessage: 'Terjadi Kesalahan',
          data: jsonData['message'],
          status: streamedResponse.statusCode,
        );
      }
    } catch (e) {
      return APIResponse(
          error: true, errorMessage: e.toString(), color: Colors.red);
    }
  }

  Future<APIResponse> updateLap(
    String id,
    String c,
    String path,
  ) async {
    Uri newApiUrl = Uri.parse('$apiServerN/lap/update');
    final token = await FileUtilsUser.getToken();

    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final send = http.MultipartRequest('POST', newApiUrl);

    send.fields["lap_id"] = id;
    send.fields["lap_c"] = c;

    send.files.add(await http.MultipartFile.fromPath(
      'lap_fl',
      path,
    ));
    send.headers.addAll(headers);
    try {
      final streamedResponse = await send.send();

      final response = await http.Response.fromStream(streamedResponse);

      if (streamedResponse.statusCode == 200) {
        return APIResponse(
          status: streamedResponse.statusCode,
        );
      } else {
        final jsonData = json.decode(response.body);

        return APIResponse(
          error: true,
          errorMessage: 'Terjadi Kesalahan',
          data: jsonData['message'],
          status: streamedResponse.statusCode,
        );
      }
    } catch (e) {
      return APIResponse(
          error: true, errorMessage: e.toString(), color: Colors.red);
    }
  }
}
