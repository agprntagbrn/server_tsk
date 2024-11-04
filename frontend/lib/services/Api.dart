import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Api {
  static const baseUrl = "http://localhost:3000/api";

  static const Map<String, String> _headers = {
    "Content-Type": "application/json",
  };

  static Future<Map<String, dynamic>> addPerson(Map<String, dynamic> pdata) async {
    try {
      final url = Uri.parse('$baseUrl/add_person');
      final res = await http.post(
        url,
        headers: _headers,
        body: jsonEncode(pdata),
      ).timeout(const Duration(seconds: 30));

      return _handleResponse(res);
    } catch (e) {
      _handleError(e);
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> getPerson() async {
    try {
      final url = Uri.parse('$baseUrl/get_person');
      final res = await http.get(
        url,
        headers: _headers,
      ).timeout(const Duration(seconds: 30));

      return _handleResponse(res);
    } catch (e) {
      _handleError(e);
      return {'success': false, 'persons': []};
    }
  }

  static Future<Map<String, dynamic>> updatePerson(
      int id, Map<String, dynamic> updatedData) async {
    if (id <= 0) {
      _handleError('Invalid ID provided: $id');
      return {'success': false, 'message': 'Invalid ID'};
    }
    
    try {
      final url = Uri.parse('$baseUrl/update_person/$id');
      final res = await http.put(
        url,
        headers: _headers,
        body: jsonEncode(updatedData),
      ).timeout(const Duration(seconds: 30));

      return _handleResponse(res);
    } catch (e) {
      _handleError(e);
      return {'success': false, 'message': e.toString()};
    }
  }

  static Map<String, dynamic> _handleResponse(http.Response response) {
    try {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(response.body);
        return {'success': true, 'data': data};
      } else {
        return {
          'success': false,
          'message': response.reasonPhrase ?? 'Unknown error',
          'statusCode': response.statusCode
        };
      }
    } catch (e) {
      _handleError(e);
      return {
        'success': false,
        'message': 'Failed to process response',
        'statusCode': response.statusCode
      };
    }
  }

  static void _handleError(dynamic error) {
    debugPrint('API Error: ${error.toString()}');
  }
}
