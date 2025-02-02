import 'package:flutter/material.dart';

class APIResponse<T> {
  T? data;
  bool error;
  String? errorMessage;
  int? status;
  Color? color;
  APIResponse({
    this.data,
    this.errorMessage,
    this.error = false,
    this.status = 500,
    this.color = Colors.green,
  });
}
