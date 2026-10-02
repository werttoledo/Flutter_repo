import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/reservation_provider.dart';

class EquipmentRentalScreen extends StatefulWidget {
  @override
  _EquipmentRentalScreenState createState() => _EquipmentRentalScreenState();
}

class _EquipmentRentalScreenState extends State<EquipmentRentalScreen> {
  int laptopHours = 0;
  int cameraHours = 0;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ReservationProvider>(context);
    final cart = provider.cart;

    return Scaffold(
      appBar: AppBar(title: Text('Alquiler de Equipos Universitarios')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(child: Text('Todos'), onPressed: () {}),
                ElevatedButton(child: Text('Tecnología'), onPressed: () {}),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: [
                _buildEquipmentTile(context, 'Laptop HP EliteBook', 2500, (hours) => setState(() => laptopHours = hours)),
                _buildEquipmentTile(context, 'Cámara Canon', 1000, (hours) => setState(() => cameraHours = hours)),
              ],
            ),
          ),
          if (cart.isNotEmpty)
            Padding(
              padding: EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/payment'),
                child: Text('Proceder al Pago (\$${provider.getTotal()})'),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEquipmentTile(BuildContext context, String equipment, int pricePerHour, Function(int) updateHours) {
    int hours = equipment.contains('Laptop') ? laptopHours : cameraHours;
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text('$equipment - \$$pricePerHour/hora', style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.remove, color: Color(0xFF0033A0)),
                  onPressed: hours > 0 ? () => updateHours(hours - 1) : null,
                ),
                Text('$hours', style: TextStyle(fontSize: 16)),
                IconButton(
                  icon: Icon(Icons.add, color: Color(0xFF0033A0)),
                  onPressed: () => updateHours(hours + 1),
                ),
              ],
            ),
            ElevatedButton(
              child: Text(hours > 0 ? 'Agregar al Carrito' : 'Quitar del Carrito'),
              onPressed: () {
                if (hours > 0) {
                  Provider.of<ReservationProvider>(context, listen: false)
                      .addToCart(equipment, 'equipment', DateTime.now(), hours);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}