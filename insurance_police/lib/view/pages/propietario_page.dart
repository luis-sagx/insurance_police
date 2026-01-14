import 'package:flutter/material.dart';
import '../../controller/insurance_controller.dart';
import '../../model/propietario.dart';

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
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(
                        prop.nombreCompleto.isNotEmpty
                            ? prop.nombreCompleto[0].toUpperCase()
                            : '?',
                      ),
                    ),
                    title: Text(prop.nombreCompleto),
                    subtitle: Text('Edad: ${prop.edad} años'),
                    trailing: Text('ID: ${prop.id}'),
                  ),
                );
              },
            ),
    );
  }
}
