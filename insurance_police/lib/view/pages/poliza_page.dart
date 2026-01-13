import 'package:flutter/material.dart';
import '../../controller/insurance_controller.dart';
import '../../model/poliza.dart';

class PolizaPage extends StatefulWidget {
  const PolizaPage({super.key});

  @override
  State<PolizaPage> createState() => _PolizaPageState();
}

class _PolizaPageState extends State<PolizaPage> {
  final _searchController = TextEditingController();
  final _controller = InsuranceController();
  Poliza? _poliza;
  bool _loading = false;

  Future<void> _search() async {
    setState(() => _loading = true);
    final id = int.tryParse(_searchController.text);
    if (id != null) {
      final result = await _controller.getPolizaByAutomovil(id);
      setState(() {
        _poliza = result;
        _loading = false;
      });
    } else {
      setState(() => _loading = false);
    }
  }

  Future<void> _recalculate() async {
    setState(() => _loading = true);
    final id = int.tryParse(_searchController.text);
    if (id != null) {
      final success = await _controller.recalculate(id);
      if (success) {
        _search(); // Refresh
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Recalculado con éxito')),
          );
        }
      } else {
        setState(() => _loading = false);
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Error al recalcular')));
        }
      }
    } else {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Consultar Póliza')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'ID Automóvil',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(onPressed: _search, child: const Text('Buscar')),
              ],
            ),
            const SizedBox(height: 20),
            if (_loading) const CircularProgressIndicator(),
            if (_poliza != null && !_loading) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Propietario: ${_poliza!.propietario}'),
                      Text('Edad: ${_poliza!.edadPropietario}'),
                      Text('Modelo Auto: ${_poliza!.modeloAuto}'),
                      Text('Accidentes: ${_poliza!.accidentes}'),
                      const Divider(),
                      Text(
                        'Valor Seguro: \$${_poliza!.valorSeguroAuto}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _recalculate,
                child: const Text('Recalcular Seguro'),
              ),
            ] else if (!_loading && _searchController.text.isNotEmpty)
              const Text('No se encontró información o busque para ver.'),
          ],
        ),
      ),
    );
  }
}
