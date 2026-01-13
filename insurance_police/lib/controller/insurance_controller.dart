import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/propietario.dart';
import '../model/automovil.dart';
import '../model/poliza.dart';

class InsuranceController {
  final String baseUrl = 'http://10.40.6.234:9090/bdd_dto/api';

  Future<bool> createPropietario(Propietario propietario) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/propietarios'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(propietario.toJson()),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error creating propietario: $e');
      return false;
    }
  }

  Future<bool> createAutomovil(Automovil automovil) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/automoviles'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(automovil.toJson()),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error creating automovil: $e');
      return false;
    }
  }

  Future<Poliza?> getPolizaByAutomovil(int automovilId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/seguros/automovil/$automovilId'),
      );
      if (response.statusCode == 200) {
        return Poliza.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      print('Error getting poliza: $e');
    }
    return null;
  }

  Future<bool> recalculate(int automovilId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/seguros/recalcular/$automovilId'),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error recalculating: $e');
      return false;
    }
  }
}
