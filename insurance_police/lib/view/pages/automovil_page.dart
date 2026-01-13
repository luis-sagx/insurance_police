import 'package:flutter/material.dart';
import '../../controller/insurance_controller.dart';
import '../../model/automovil.dart';

class AutomovilPage extends StatefulWidget {
  const AutomovilPage({super.key});

  @override
  State<AutomovilPage> createState() => _AutomovilPageState();
}

class _AutomovilPageState extends State<AutomovilPage> {
  final _formKey = GlobalKey<FormState>();
  final _modeloController = TextEditingController();
  final _valorController = TextEditingController();
  final _accidentesController = TextEditingController();
  final _propIdController = TextEditingController();
  final _controller = InsuranceController();

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final auto = Automovil(
        modelo: _modeloController.text,
        valor: double.parse(_valorController.text),
        accidentes: int.parse(_accidentesController.text),
        propietarioId: int.parse(_propIdController.text),
      );

      final success = await _controller.createAutomovil(auto);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success ? 'Automovil creado' : 'Error al crear'),
          ),
        );
        if (success) {
          _modeloController.clear();
          _valorController.clear();
          _accidentesController.clear();
          _propIdController.clear();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Automóvil')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _modeloController,
                  decoration: const InputDecoration(labelText: 'Modelo'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Requerido' : null,
                ),
                TextFormField(
                  controller: _valorController,
                  decoration: const InputDecoration(labelText: 'Valor'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Requerido' : null,
                ),
                TextFormField(
                  controller: _accidentesController,
                  decoration: const InputDecoration(labelText: 'Accidentes'),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Requerido' : null,
                ),
                TextFormField(
                  controller: _propIdController,
                  decoration: const InputDecoration(
                    labelText: 'ID Propietario',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Requerido' : null,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submit,
                  child: const Text('Guardar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
