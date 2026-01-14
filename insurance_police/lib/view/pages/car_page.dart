import 'package:flutter/material.dart';
import '../../controller/insurance_controller.dart';
import '../../model/automovil.dart';
import '../../model/poliza.dart';
import '../widgets/custom_button.dart';
import '../../utils/themes/schema_color.dart';

class CarPage extends StatefulWidget {
  const CarPage({super.key});

  @override
  State<CarPage> createState() => _CarPageState();
}

class _CarPageState extends State<CarPage> {
  final _controller = InsuranceController();
  List<Automovil> _automoviles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final automoviles = await _controller.getAutomoviles();
    if (mounted) {
      setState(() {
        _automoviles = automoviles;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registros de Autos')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _automoviles.isEmpty
          ? const Center(child: Text('No hay registros encontrados'))
          : ListView.builder(
              itemCount: _automoviles.length,
              itemBuilder: (context, index) {
                final auto = _automoviles[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        'Modelo: ${auto.modelo}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: SchemaColor.primaryColor,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.person,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 4),
                                Text(auto.propietarioNombreC ?? "N/A"),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.attach_money,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  auto.valor.toStringAsFixed(2),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      trailing: Container(
                        decoration: BoxDecoration(
                          color: SchemaColor.secondaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_forward_ios, size: 18),
                          onPressed: () => _showPolizaDetails(auto.id!),
                          color: SchemaColor.secondaryColor,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _showPolizaDetails(int automovilId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return FutureBuilder<Poliza?>(
          // Use the updated method that now calls the correct endpoint
          future: _controller.getPolizaByAutomovil(automovilId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              );
            } else if (snapshot.hasError || !snapshot.hasData) {
              return const SizedBox(
                height: 200,
                child: Center(
                  child: Text('Error al cargar detalles de la póliza'),
                ),
              );
            }

            final poliza = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.description, color: SchemaColor.primaryColor),
                      SizedBox(width: 10),
                      Text(
                        'Detalles de la Póliza',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: SchemaColor.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 30),
                  _buildDetailRow(
                    'Costo Total',
                    '\$${poliza.costoTotal.toStringAsFixed(2)}',
                    isHighlight: true,
                  ),
                  _buildDetailRow('Propietario', poliza.propietario),
                  _buildDetailRow(
                    'Rango de Edad',
                    '${InsuranceController.getAgeCategory(poliza.edadPropietario)} ',
                  ),
                  _buildDetailRow('Modelo Auto', poliza.modeloAuto),
                  _buildDetailRow(
                    'Valor Auto',
                    '\$${poliza.valorSeguroAuto.toStringAsFixed(2)}',
                  ),
                  const SizedBox(height: 30),
                  CustomButton(
                    text: 'Recalcular Seguro',
                    onPressed: () async {
                      Navigator.pop(context);
                      await _recalculate(automovilId);
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    bool isHighlight = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: isHighlight
                  ? SchemaColor.secondaryColor
                  : SchemaColor.darkTextColor,
              fontSize: 16,
              fontWeight: isHighlight ? FontWeight.bold : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _recalculate(int automovilId) async {
    final success = await _controller.recalculate(automovilId);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Seguro recalculado con éxito'
                : 'Error al recalcular seguro',
          ),
        ),
      );
      if (success) {
        // Refresh detail view? For simplicity we just show message
      }
    }
  }
}
