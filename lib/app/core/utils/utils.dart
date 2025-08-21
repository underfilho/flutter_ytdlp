import 'package:flutter/material.dart';

bool isValidUrl(String url) {
  final uri = Uri.tryParse(url);
  return uri != null && (uri.isScheme("http") || uri.isScheme("https"));
}

void showSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
    duration: Duration(seconds: 2),
  ));
}
