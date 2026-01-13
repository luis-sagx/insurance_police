import 'package:flutter/material.dart';
import '../../controller/insurance_controller.dart';
import '../../model/propietario.dart';

class PropietarioPage extends StatefulWidget {
  const PropietarioPage({super.key});

  @override
  State<PropietarioPage> createState() => _PropietarioPageState();
}

class _PropietarioPageState extends State<PropietarioPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _controller = InsuranceController();

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final propietario = Propietario(
        nombreCompleto: _nameController.text,
        edad: int.parse(_ageController.text),
      );

      final success = await _controller.createPropietario(propietario);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success ? 'Propietario creado' : 'Error al crear'),
          ),
        );
        if (success) {
          _nameController.clear();
          _ageController.clear();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Propietario')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre Completo'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Requerido' : null,
              ),
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(labelText: 'Edad'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _submit, child: const Text('Guardar')),
            ],
          ),
        ),
      ),
    );
  }
}
