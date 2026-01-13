import 'package:flutter/material.dart';
import '../../controller/insurance_controller.dart';
import '../../model/propietario.dart';

class PropietarioPage extends StatefulWidget {
  const PropietarioPage({super.key});

  @override
  State<PropietarioPage> createState() => _PropietarioPageState();
}

enum AgeRange { young, adult, senior }

class _PropietarioPageState extends State<PropietarioPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _controller = InsuranceController();

  AgeRange? _selectedAgeRange;

  int _getAgeFromRange(AgeRange range) {
    switch (range) {
      case AgeRange.young:
        return 20;
      case AgeRange.adult:
        return 35;
      case AgeRange.senior:
        return 60;
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate() && _selectedAgeRange != null) {
      final propietario = Propietario(
        nombreCompleto: _nameController.text,
        edad: _getAgeFromRange(_selectedAgeRange!),
      );

      final Propietario? result = await _controller.createPropietario(
        propietario,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result != null
                  ? 'Propietario creado con ID: ${result.id}'
                  : 'Error al crear',
            ),
          ),
        );
        if (result != null) {
          _nameController.clear();
          setState(() => _selectedAgeRange = null);
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Complete todos los campos')),
      );
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre Completo',
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Requerido' : null,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Edad:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                RadioListTile<AgeRange>(
                  title: const Text('18 a 23 años'),
                  value: AgeRange.young,
                  groupValue: _selectedAgeRange,
                  onChanged: (value) =>
                      setState(() => _selectedAgeRange = value),
                ),
                RadioListTile<AgeRange>(
                  title: const Text('24 a 55 años'),
                  value: AgeRange.adult,
                  groupValue: _selectedAgeRange,
                  onChanged: (value) =>
                      setState(() => _selectedAgeRange = value),
                ),
                RadioListTile<AgeRange>(
                  title: const Text('Mayor a 55 años'),
                  value: AgeRange.senior,
                  groupValue: _selectedAgeRange,
                  onChanged: (value) =>
                      setState(() => _selectedAgeRange = value),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submit,
                    child: const Text('Guardar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
