import 'package:flutter/material.dart';
import '../../controller/insurance_controller.dart';
import '../../model/poliza.dart';
import '../../model/automovil.dart';

class PolizaPage extends StatefulWidget {
  const PolizaPage({super.key});

  @override
  State<PolizaPage> createState() => _PolizaPageState();
}

class _PolizaPageState extends State<PolizaPage> {
  final _controller = InsuranceController();
  List<Automovil> _automoviles = [];
  bool _loadingList = true;

  @override
  void initState() {
    super.initState();
    _loadAutomoviles();
  }

  Future<void> _loadAutomoviles() async {
    setState(() => _loadingList = true);
    final autos = await _controller.getAutomoviles();
    if (mounted) {
      setState(() {
        _automoviles = autos;
        _loadingList = false;
      });
    }
  }

  Future<void> _showPolizaDetails(Automovil auto) async {
    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final poliza = await _controller.getPolizaByAutomovil(auto.id!);

    if (mounted) {
      Navigator.pop(context); // Close loading
      if (poliza != null) {
        _showPolizaDialog(poliza, auto.id!);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se encontró póliza para este auto')),
        );
      }
    }
  }

  void _showPolizaDialog(Poliza poliza, int autoId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Póliza: ${poliza.modeloAuto}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Propietario: ${poliza.propietario}'),
            Text('Edad: ${poliza.edadPropietario}'),
            Text('Accidentes: ${poliza.accidentes}'),
            const Divider(),
            Text(
              'Valor Seguro: \$${poliza.valorSeguroAuto.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _recalculate(autoId);
            },
            child: const Text('Recalcular'),
          ),
        ],
      ),
    );
  }

  Future<void> _recalculate(int autoId) async {
    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final success = await _controller.recalculate(autoId);

    if (mounted) {
      Navigator.pop(context); // Close loading
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Recalculado con éxito. Revise la póliza nuevamente.',
            ),
          ),
        );
        // Optionally refresh the list or show the dialog again
        // For now, let's just let the user tap again to see updated values
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Error al recalcular')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccione Automóvil'),
        actions: [
          IconButton(
            onPressed: _loadAutomoviles,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _loadingList
          ? const Center(child: CircularProgressIndicator())
          : _automoviles.isEmpty
          ? const Center(child: Text('No hay automóviles registrados'))
          : ListView.builder(
              itemCount: _automoviles.length,
              itemBuilder: (context, index) {
                final auto = _automoviles[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.directions_car),
                    title: Text(auto.modelo),
                    subtitle: Text(
                      'Propietario: ${auto.propietarioNombreC ?? "Desc"} (ID: ${auto.id})',
                    ),
                    //trailing: const Icon(Icons.arrow_forward_ios),
                    //onTap: () => _showPolizaDetails(auto),
                  ),
                );
              },
            ),
    );
  }
}
