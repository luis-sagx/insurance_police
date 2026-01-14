import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/propietario.dart';
import '../model/automovil.dart';
import '../model/poliza.dart';

class InsuranceController {
  final String baseUrl = 'http://192.168.100.5:9090/bdd_dto/api';

  Future<Propietario?> createPropietario(Propietario propietario) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/propietarios'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(propietario.toJson()),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Propietario.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      print('Error creating propietario: $e');
    }
    return null;
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

  Future<List<Automovil>> getAutomoviles() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/automoviles'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Automovil.fromJson(json)).toList();
      }
    } catch (e) {
      print('Error getting automoviles: $e');
    }
    return [];
  }

  Future<List<Propietario>> getPropietarios() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/propietarios'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Propietario.fromJson(json)).toList();
      }
    } catch (e) {
      print('Error getting propietarios: $e');
    }
    return [];
  }

  // Create Poliza directly (using the /poliza endpoint)
  Future<Poliza?> createPoliza(Map<String, dynamic> polizaData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/poliza'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(polizaData),
      );
      if (response.statusCode == 200) {
        return Poliza.fromJson(jsonDecode(response.body));
      } else {
        print(
          'Error creating poliza: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Error creating poliza: $e');
    }
    return null;
  }

  Future<Poliza?> getPolizaByAutomovil(int automovilId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/poliza/automovil/$automovilId'),
      );
      if (response.statusCode == 200) {
        return Poliza.fromJson(jsonDecode(response.body));
      } else {
        print('Error getting poliza, status: ${response.statusCode}');
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
