import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:presensi/constants/var_constant.dart';
import 'package:http/http.dart' as http;
import 'package:presensi/models/absen_model.dart';
import 'package:presensi/models/api_response.dart';
import 'package:presensi/services/file_services.dart';

class AbsenService {
  Future<APIResponse> createAbsen(
      String long, String lat, String tipe, String path) async {
    Uri newApiUrl = Uri.parse('$apiServerN/absen/insert');
    final token = await FileUtilsUser.getToken();

    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final send = http.MultipartRequest('POST', newApiUrl);

    send.fields["long"] = long;
    send.fields["lat"] = lat;
    send.fields["tipe"] = tipe;

    send.files.add(await http.MultipartFile.fromPath(
      'pic',
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
        final jsonData = json.decode(response.body)['message'];
        return APIResponse(
          error: true,
          errorMessage: jsonData,
          status: streamedResponse.statusCode,
        );
      }
    } catch (e) {
      return APIResponse(
          error: true, errorMessage: e.toString(), color: Colors.red);
    }
  }

  Future<APIResponse> changeAbsen(
    String id,
    String long,
    String lat,
    String path,
  ) async {
    Uri newApiUrl = Uri.parse('$apiServerN/absen/update');
    final token = await FileUtilsUser.getToken();

    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final send = http.MultipartRequest('POST', newApiUrl);

    send.fields["id"] = id;
    send.fields["long"] = long;
    send.fields["lat"] = lat;

    send.files.add(await http.MultipartFile.fromPath(
      'pic',
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

  //Fix
  Future<APIResponse<List<AbsenHome>>> getAbsenHome() async {
    Uri newApiUrl = Uri.parse('$apiServerN/absen/last');
    final token = await FileUtilsUser.getToken();
    return http.get(newApiUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    }).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body)['data'];

        final absen = <AbsenHome>[];
        for (var item in jsonData) {
          absen.add(AbsenHome.fromJson(item));
        }
        return APIResponse<List<AbsenHome>>(
            data: absen, status: data.statusCode);
      } else {
        final jsonData = json.decode(data.body)['message'];
        return APIResponse<List<AbsenHome>>(
          error: true,
          errorMessage: jsonData,
        );
      }
    }).catchError((_) => APIResponse<List<AbsenHome>>(
          error: true,
          errorMessage: 'Terjadi Kesalahan',
          status: 500,
        ));
  }

  Future<APIResponse<AbsenDetail>> getAbsenDetail(String id) async {
    final token = await FileUtilsUser.getToken();
    Uri newApiUrl = Uri.parse('$apiServerN/absen/detail/$id');
    return http.get(newApiUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    }).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body)['data'];
        return APIResponse<AbsenDetail>(
          data: AbsenDetail.fromJson(jsonData),
          status: data.statusCode,
        );
      } else {
        final jsonData = json.decode(data.body)['message'];
        return APIResponse<AbsenDetail>(
          error: true,
          errorMessage: jsonData,
        );
      }
    }).catchError((_) => APIResponse<AbsenDetail>(
        error: true, errorMessage: 'Terjadi Kesalahan'));
  }

  Future<APIResponse<AbsenDetail>> getAbsenDetailDate() async {
    final token = await FileUtilsUser.getToken();
    Uri newApiUrl = Uri.parse('$apiServerN/absen/detailDate');
    return http.get(newApiUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    }).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body)['data'];
        return APIResponse<AbsenDetail>(
          data: AbsenDetail.fromJson(jsonData),
          status: data.statusCode,
        );
      } else {
        final jsonData = json.decode(data.body)['message'];
        return APIResponse<AbsenDetail>(
          error: true,
          errorMessage: jsonData,
        );
      }
    }).catchError((_) => APIResponse<AbsenDetail>(
        error: true, errorMessage: 'Terjadi Kesalahan'));
  }

  Future<APIResponse<AbsenRekap>> getRekap(String? month, String? year) async {
    final token = await FileUtilsUser.getToken();
    String extra = '';
    if (month != null && year != null) {
      extra = '/$month/$year';
    }
    Uri newApiUrl = Uri.parse('$apiServerN/absen/rekap$extra');
    return http.get(newApiUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    }).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body)['data'];
        return APIResponse<AbsenRekap>(
          data: AbsenRekap.fromJson(jsonData),
          status: data.statusCode,
        );
      } else {
        final jsonData = json.decode(data.body)['data'];
        return APIResponse<AbsenRekap>(
          error: true,
          errorMessage: 'Terjadi Kesalahan',
          data: AbsenRekap.fromJson(jsonData),
        );
      }
    }).catchError((_) => APIResponse<AbsenRekap>(
        error: true, errorMessage: 'Terjadi Kesalahan'));
  }

  Future<APIResponse<List<AbsenGetYear>>> getYear() async {
    final token = await FileUtilsUser.getToken();
    Uri newApiUrl = Uri.parse('$apiServerN/absen/getYear');
    return http.get(newApiUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    }).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body)['data'];
        final year = <AbsenGetYear>[];
        for (var item in jsonData) {
          year.add(AbsenGetYear.fromJson(item));
        }
        return APIResponse<List<AbsenGetYear>>(
            data: year, status: data.statusCode);
      } else {
        final jsonData = json.decode(data.body)['message'];
        return APIResponse<List<AbsenGetYear>>(
          error: true,
          errorMessage: jsonData,
        );
      }
    }).catchError((_) => APIResponse<List<AbsenGetYear>>(
        error: true, errorMessage: 'Terjadi Kesalahan'));
  }

  Future<APIResponse<List<AbsenGetMonth>>> getMonth(String year) async {
    final token = await FileUtilsUser.getToken();
    Uri newApiUrl = Uri.parse('$apiServerN/absen/getMonth/$year');
    return http.get(newApiUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    }).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body)['data'];
        final month = <AbsenGetMonth>[];
        for (var item in jsonData) {
          month.add(AbsenGetMonth.fromJson(item));
        }
        return APIResponse<List<AbsenGetMonth>>(
            data: month, status: data.statusCode);
      } else {
        final jsonData = json.decode(data.body)['message'];
        return APIResponse<List<AbsenGetMonth>>(
          error: true,
          errorMessage: jsonData,
        );
      }
    }).catchError((_) => APIResponse<List<AbsenGetMonth>>(
        error: true, errorMessage: 'Terjadi Kesalahan'));
  }

  Future<APIResponse<List<AbsenHome>>> getAbsenMonth(
      String month, String year) async {
    final token = await FileUtilsUser.getToken();
    Uri newApiUrl = Uri.parse('$apiServerN/absen/month/$month/$year');
    return http.get(newApiUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    }).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body)['data'];

        final absenHome = <AbsenHome>[];
        for (var item in jsonData) {
          absenHome.add(AbsenHome.fromJson(item));
        }
        return APIResponse<List<AbsenHome>>(
            data: absenHome, status: data.statusCode);
      } else {
        final jsonData = json.decode(data.body)['message'];
        return APIResponse<List<AbsenHome>>(
          error: true,
          errorMessage: jsonData,
        );
      }
    }).catchError((_) => APIResponse<List<AbsenHome>>(
        error: true, errorMessage: 'Terjadi Kesalahan'));
  }
}
