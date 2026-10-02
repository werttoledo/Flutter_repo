import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/reservation_provider.dart';

class PaymentGatewayScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ReservationProvider>(context);
    final total = provider.getTotal();

    return Scaffold(
      appBar: AppBar(title: Text('Pasarela de Pago')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.credit_card, size: 100, color: Color(0xFF0033A0)),
            SizedBox(height: 20),
            Text('Método de pago', style: Theme.of(context).textTheme.headlineSmall),
            RadioListTile(
              title: Text('Nequi / Daviplata'),
              value: 'nequi',
              groupValue: 'nequi',
              onChanged: (value) {},
              activeColor: Colors.yellow,
            ),
            SizedBox(height: 20),
            Text('Total a pagar: \$${total.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                provider.clearCart();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Pago exitoso')),
                );
                Navigator.popUntil(context, ModalRoute.withName('/collaborator'));
              },
              child: Text('Confirmar pago'),
            ),
          ],
        ),
      ),
    );
  }
}