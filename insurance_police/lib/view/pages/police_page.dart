import 'package:flutter/material.dart';
import '../../controller/insurance_controller.dart';
import '../../model/poliza.dart';

class PolicePage extends StatefulWidget {
  const PolicePage({super.key});

  @override
  State<PolicePage> createState() => _PolicePageState();
}

enum AgeRange { young, adult, senior }

enum CarModel { A, B, C }

class _PolicePageState extends State<PolicePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _valorController = TextEditingController();
  final _accidentesController = TextEditingController();
  final _controller = InsuranceController();

  AgeRange? _selectedAgeRange; // young (18-23), adult (24-55), senior (>55)
  CarModel? _selectedModel;

  bool _isLoading = false;
  Poliza? _polizaGenerada;

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

      // Prepare payload for /api/poliza
      final polizaRequest = {
        "propietario": _nameController.text,
        "valorSeguroAuto": double.parse(_valorController.text),
        "modeloAuto": _getModelString(_selectedModel!),
        "accidentes": int.parse(_accidentesController.text),
        "edadPropietario": _getAgeFromRange(_selectedAgeRange!),
      };

      final polizaResponse = await _controller.createPoliza(polizaRequest);

      setState(() {
        _isLoading = false;
        _polizaGenerada = polizaResponse;
      });

      if (polizaResponse != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cotización generada con éxito')),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error al generar cotización')),
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
      _polizaGenerada = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva Póliza')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Datos del Propietario',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
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
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
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
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Requerido';
                        final doubleValue = double.tryParse(value);
                        if (doubleValue == null)
                          return 'Ingrese un número válido';
                        if (doubleValue < 0)
                          return 'El valor no puede ser negativo';
                        if (doubleValue > 1000000)
                          return 'El valor máximo es 1,000,000';
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _accidentesController,
                      decoration: const InputDecoration(
                        labelText: 'Número de Accidentes',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Requerido';
                        final intValue = int.tryParse(value);
                        if (intValue == null) return 'Ingrese un entero válido';
                        if (intValue < 0) return 'No puede ser negativo';
                        if (intValue > 100) return 'Número demasiado alto';
                        return null;
                      },
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
              if (_polizaGenerada != null) ...[
                const SizedBox(height: 20),
                const Divider(thickness: 2),
                const Text(
                  'Resultado de Cotización',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                Card(
                  margin: const EdgeInsets.only(top: 10),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Propietario: ${_polizaGenerada!.propietario}'),
                        Text(
                          'Edad: ${InsuranceController.getAgeCategory(_polizaGenerada!.edadPropietario)}',
                        ),
                        const Divider(),
                        Text('Modelo Auto: ${_polizaGenerada!.modeloAuto}'),
                        Text(
                          'Valor Auto: \$${_polizaGenerada!.valorSeguroAuto.toStringAsFixed(2)}',
                        ),
                        Text('Accidentes: ${_polizaGenerada!.accidentes}'),
                        const Divider(),
                        Text(
                          'Costo Total Póliza: \$${_polizaGenerada!.costoTotal.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                TextButton(
                  onPressed: _resetForm,
                  child: const Text('Nueva Cotización'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
