import 'package:flutter/material.dart';
import '../../controller/insurance_controller.dart';
import '../../model/automovil.dart';
import '../../model/propietario.dart';

class AutomovilPage extends StatefulWidget {
  const AutomovilPage({super.key});

  @override
  State<AutomovilPage> createState() => _AutomovilPageState();
}

enum AgeRange { young, adult, senior }

enum CarModel { A, B, C }

class _AutomovilPageState extends State<AutomovilPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _valorController = TextEditingController();
  final _accidentesController = TextEditingController();
  final _controller = InsuranceController();

  AgeRange? _selectedAgeRange; // young: 18-23, adult: 24-55, senior: >55
  CarModel? _selectedModel;

  bool _isLoading = false;

  int _getAgeFromRange(AgeRange range) {
    switch (range) {
      case AgeRange.young:
        return 20; // Represents 18-23
      case AgeRange.adult:
        return 35; // Represents 24-55
      case AgeRange.senior:
        return 60; // Represents >55
    }
  }

  String _getModelString(CarModel model) {
    return model.name; // "A", "B", "C"
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate() &&
        _selectedAgeRange != null &&
        _selectedModel != null) {
      setState(() => _isLoading = true);

      // 1. Create Propietario
      final propietario = Propietario(
        nombreCompleto: _nameController.text,
        edad: _getAgeFromRange(_selectedAgeRange!),
      );

      final createdPropietario = await _controller.createPropietario(
        propietario,
      );

      if (mounted) {
        if (createdPropietario != null && createdPropietario.id != null) {
          // 2. Create Automovil linked to Propietario
          final auto = Automovil(
            modelo: _getModelString(_selectedModel!),
            valor: double.parse(_valorController.text),
            accidentes: int.parse(_accidentesController.text),
            propietarioId: createdPropietario.id!,
            propietarioNombreC: createdPropietario.nombreCompleto,
          );

          final success = await _controller.createAutomovil(auto);

          if (mounted) {
            setState(() => _isLoading = false);
            if (success) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Póliza Registrada Con Éxito')),
              );
              _resetForm();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Error al registrar automóvil')),
              );
            }
          }
        } else {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error al registrar propietario')),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Complete todos los campos')),
      );
    }
  }

  void _resetForm() {
    _nameController.clear();
    _valorController.clear();
    _accidentesController.clear();
    setState(() {
      _selectedAgeRange = null;
      _selectedModel = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva Póliza')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Datos del Propietario',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre Completo',
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Requerido' : null,
                ),
                const SizedBox(height: 10),
                const Text('Edad:'),
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

                const Divider(),
                const Text(
                  'Datos del Vehículo',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text('Modelo:'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: RadioListTile<CarModel>(
                        title: const Text('A'),
                        value: CarModel.A,
                        groupValue: _selectedModel,
                        onChanged: (value) =>
                            setState(() => _selectedModel = value),
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<CarModel>(
                        title: const Text('B'),
                        value: CarModel.B,
                        groupValue: _selectedModel,
                        onChanged: (value) =>
                            setState(() => _selectedModel = value),
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<CarModel>(
                        title: const Text('C'),
                        value: CarModel.C,
                        groupValue: _selectedModel,
                        onChanged: (value) =>
                            setState(() => _selectedModel = value),
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  controller: _valorController,
                  decoration: const InputDecoration(
                    labelText: 'Valor del Vehículo (\$)',
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Requerido' : null,
                ),
                TextFormField(
                  controller: _accidentesController,
                  decoration: const InputDecoration(
                    labelText: 'Número de Accidentes',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Requerido' : null,
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text(
                          'Registrar y Cotizar',
                          style: TextStyle(fontSize: 16),
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
