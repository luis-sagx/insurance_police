import 'package:flutter/material.dart';
import '../../controller/insurance_controller.dart';
import '../../model/automovil.dart';
import '../../model/poliza.dart';

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
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(
                      'Modelo: ${auto.modelo} - \$${auto.valor.toStringAsFixed(2)}',
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Propietario ID: ${auto.propietarioId} (${auto.propietarioNombreC ?? "N/A"})',
                        ),
                        Text('Accidentes: ${auto.accidentes}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.info_outline),
                      onPressed: () => _showPolizaDetails(auto.id!),
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
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Detalles de la Póliza',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('Costo Total'),
                    subtitle: Text(
                      '\$${poliza.costoTotal.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  ListTile(
                    title: const Text('Propietario'),
                    subtitle: Text(poliza.propietario),
                  ),
                  ListTile(
                    title: const Text('Edad Propietario'),
                    subtitle: Text('${poliza.edadPropietario} años'),
                  ),
                  ListTile(
                    title: const Text('Modelo Auto'),
                    subtitle: Text(poliza.modeloAuto),
                  ),
                  ListTile(
                    title: const Text('Valor Auto'),
                    subtitle: Text('\$${poliza.valorSeguroAuto}'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      await _recalculate(automovilId);
                    },
                    child: const Text('Recalcular Seguro'),
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
