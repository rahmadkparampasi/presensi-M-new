import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:presensi/constants/var_constant.dart';
import 'package:presensi/models/api_response.dart';
import 'package:http/http.dart' as http;
import 'package:presensi/models/sisp_model.dart';
import 'package:presensi/services/file_services.dart';

class SispServices {
  Future<APIResponse> daftar(SispDaftar daftar) {
    Uri newApiUrl = Uri.parse('$apiServerN/registerM');
    return http.post(newApiUrl,
        body: daftar.toJson(),
        headers: {'Accept': 'application/json'}).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body)['message'];

        return APIResponse(
            errorMessage: jsonData, error: false, color: Colors.green);
      } else {
        final jsonData = json.decode(data.body)['message'];
        return APIResponse(
            error: true, errorMessage: jsonData, color: Colors.red);
      }
    }).catchError(
      (_) => APIResponse(
        error: true,
        errorMessage: 'Terjadi Kesalahan',
        color: Colors.red,
      ),
    );
  }

  Future<APIResponse<FeedBackMasuk>> masuk(CekLogin masuk) {
    Uri newApiUrl = Uri.parse('$apiServerN/masuk');
    return http.post(newApiUrl, body: masuk.toJson(), headers: {
      'Accept': 'application/json',
    }).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        return APIResponse<FeedBackMasuk>(
          data: FeedBackMasuk.fromJson(jsonData),
          status: data.statusCode,
        );
      } else {
        final jsonData = json.decode(data.body);
        return APIResponse<FeedBackMasuk>(
          error: true,
          errorMessage: jsonData['message'],
          status: data.statusCode,
          color: Colors.red,
        );
      }
    }).catchError((data) => APIResponse<FeedBackMasuk>(
        error: true, errorMessage: data.toString(), color: Colors.red));
  }

  Future<APIResponse<Sisp>> getSisp() async {
    final token = await FileUtilsUser.getToken();
    Uri newApiUrl = Uri.parse('$apiServerN/sisp/detail');
    return http.get(newApiUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    }).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body)['data'];
        return APIResponse<Sisp>(
          data: Sisp.fromJson(jsonData),
          status: data.statusCode,
        );
      } else {
        final jsonData = json.decode(data.body)['message'];
        return APIResponse<Sisp>(
          error: true,
          errorMessage: jsonData,
        );
      }
    }).catchError((e) => APIResponse<Sisp>(
        error: true, errorMessage: e.toString(), color: Colors.red));
  }

  Future<APIResponse> changePic(String path) async {
    Uri newApiUrl = Uri.parse('$apiServerN/sisp/updatePic');
    final token = await FileUtilsUser.getToken();

    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final send = http.MultipartRequest('POST', newApiUrl);

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

  Future<APIResponse> changeSisp(SispUpdate sisp) async {
    final token = await FileUtilsUser.getToken();
    Uri newApiUrl = Uri.parse('$apiServerN/sisp/update');
    return http.post(newApiUrl, body: sisp.toJson(), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    }).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body)['message'];

        return APIResponse(
            errorMessage: jsonData, error: false, color: Colors.green);
      } else {
        final jsonData = json.decode(data.body)['message'];
        return APIResponse(
            error: true, errorMessage: jsonData, color: Colors.red);
      }
    }).catchError((data) => APIResponse(
        error: true, errorMessage: data.toString(), color: Colors.red));
  }
}
