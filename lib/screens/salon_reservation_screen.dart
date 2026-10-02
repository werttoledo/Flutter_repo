import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import '../providers/reservation_provider.dart';

class SalonReservationScreen extends StatefulWidget {
  @override
  _SalonReservationScreenState createState() => _SalonReservationScreenState();
}

class _SalonReservationScreenState extends State<SalonReservationScreen> {
  DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reserva de Salones')),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 8)],
            ),
            child: TableCalendar(
              firstDay: DateTime.utc(2023, 1, 1),
              lastDay: DateTime.utc(2025, 12, 31),
              focusedDay: _selectedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                });
              },
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(color: Colors.yellow, shape: BoxShape.circle),
                todayDecoration: BoxDecoration(color: Color(0xFF0033A0), shape: BoxShape.circle),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text('SALONES DISPONIBLES', style: Theme.of(context).textTheme.headlineSmall),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: [
                _buildSalonTile(context, 'B301'),
                _buildSalonTile(context, 'A102'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSalonTile(BuildContext context, String salon) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(salon, style: TextStyle(fontWeight: FontWeight.bold)),
        trailing: ElevatedButton(
          child: Text('Reservar'),
          onPressed: () {
            Provider.of<ReservationProvider>(context, listen: false)
                .addReservation(salon, 'salon', _selectedDay, 1);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('$salon reservado con éxito')),
            );
          },
        ),
      ),
    );
  }
}