import 'package:flutter/material.dart';
import '../../controller/insurance_controller.dart';
import '../../model/propietario.dart';
import '../../utils/themes/schema_color.dart';

class PropietarioPage extends StatefulWidget {
  const PropietarioPage({super.key});

  @override
  State<PropietarioPage> createState() => _PropietarioPageState();
}

class _PropietarioPageState extends State<PropietarioPage> {
  final _controller = InsuranceController();
  List<Propietario> _propietarios = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final propietarios = await _controller.getPropietarios();
    if (mounted) {
      setState(() {
        _propietarios = propietarios;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registros de Propietarios')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _propietarios.isEmpty
          ? const Center(child: Text('No hay registros encontrados'))
          : ListView.builder(
              itemCount: _propietarios.length,
              itemBuilder: (context, index) {
                final prop = _propietarios[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: SchemaColor.primaryColor,
                        foregroundColor: Colors.white,
                        child: Text(
                          prop.nombreCompleto.isNotEmpty
                              ? prop.nombreCompleto[0].toUpperCase()
                              : '?',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(
                        prop.nombreCompleto,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: SchemaColor.darkTextColor,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Row(
                          children: [
                            const Text(
                              'Rango: ',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              InsuranceController.getAgeCategory(prop.edad),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      trailing: Chip(
                        label: Text('ID: ${prop.id}'),
                        backgroundColor: SchemaColor.secondaryColor.withOpacity(
                          0.1,
                        ),
                        labelStyle: const TextStyle(
                          color: SchemaColor.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
