import 'package:flutter/material.dart';
import '../../controller/insurance_controller.dart';
import '../../model/poliza.dart';
import '../widgets/custom_input.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_radio.dart';
import '../../utils/themes/schema_color.dart';

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

  Widget _buildModelOption(String label, CarModel model) {
    bool isSelected = _selectedModel == model;
    return GestureDetector(
      onTap: () => setState(() => _selectedModel = model),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? SchemaColor.secondaryColor : Colors.white,
          border: Border.all(
            color: isSelected
                ? SchemaColor.secondaryColor
                : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : SchemaColor.darkTextColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(
                                Icons.person,
                                color: SchemaColor.primaryColor,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Datos del Propietario',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: SchemaColor.primaryColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          CustomInput(
                            controller: _nameController,
                            label: 'Nombre Completo',
                            icon: Icons.person_outline,
                            validator: (value) => value == null || value.isEmpty
                                ? 'Requerido'
                                : null,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Rango de Edad:',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: SchemaColor.darkTextColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                CustomRadio<AgeRange>(
                                  title: 'De 18 a 23 años',
                                  value: AgeRange.young,
                                  groupValue: _selectedAgeRange,
                                  onChanged: (value) =>
                                      setState(() => _selectedAgeRange = value),
                                ),
                                CustomRadio<AgeRange>(
                                  title: 'De 24 a 55 años',
                                  value: AgeRange.adult,
                                  groupValue: _selectedAgeRange,
                                  onChanged: (value) =>
                                      setState(() => _selectedAgeRange = value),
                                ),
                                CustomRadio<AgeRange>(
                                  title: 'Mayor de 55 años',
                                  value: AgeRange.senior,
                                  groupValue: _selectedAgeRange,
                                  onChanged: (value) =>
                                      setState(() => _selectedAgeRange = value),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(
                                Icons.directions_car,
                                color: SchemaColor.primaryColor,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Datos del Vehículo',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: SchemaColor.primaryColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          CustomInput(
                            controller: _valorController,
                            label: 'Valor del Vehículo (\$)',
                            icon: Icons.attach_money,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty)
                                return 'Requerido';
                              final doubleValue = double.tryParse(value);
                              if (doubleValue == null)
                                return 'Ingrese un número válido';
                              if (doubleValue < 0)
                                return 'El valor no puede ser negativo';
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          CustomInput(
                            controller: _accidentesController,
                            label: 'Número de Accidentes',
                            icon: Icons.warning_amber_rounded,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty)
                                return 'Requerido';
                              final intValue = int.tryParse(value);
                              if (intValue == null)
                                return 'Ingrese un entero válido';
                              if (intValue < 0) return 'No puede ser negativo';
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Modelo del Auto:',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: SchemaColor.darkTextColor,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: _buildModelOption('A', CarModel.A),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _buildModelOption('B', CarModel.B),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _buildModelOption('C', CarModel.C),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  CustomButton(
                    text: 'COTIZAR AHORA',
                    onPressed: _submit,
                    isLoading: _isLoading,
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
                  color: SchemaColor.accentColor,
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
    );
  }
}
