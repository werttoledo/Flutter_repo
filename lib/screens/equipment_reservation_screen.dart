import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import '../providers/reservation_provider.dart';

class EquipmentReservationScreen extends StatefulWidget {
  @override
  _EquipmentReservationScreenState createState() => _EquipmentReservationScreenState();
}

class _EquipmentReservationScreenState extends State<EquipmentReservationScreen> {
  DateTime _selectedDay = DateTime.now();
  int _selectedHours = 1;
  final List<String> _availableEquipment = [
    'Videobeam 1',
    'SmartBoard 1',
    'Laptop 1',
    'Laptop 2',
    'Cámara 1',
    'Micrófono 1',
  ];

  @override
  void initState() {
    super.initState();
    // Cargar reservas al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ReservationProvider>(context, listen: false).loadReservations();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reserva de Equipos'),
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () => Navigator.pushNamed(context, '/history'),
          ),
        ],
      ),
      body: Consumer<ReservationProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (provider.userId == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Debe iniciar sesión para hacer reservas',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/login'),
                    child: Text('Iniciar Sesión'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Container(
                margin: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 8)],
                ),
                child: TableCalendar(
                  firstDay: DateTime.now(),
                  lastDay: DateTime.utc(2025, 12, 31),
                  focusedDay: _selectedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                    });
                  },
                  calendarStyle: CalendarStyle(
                    selectedDecoration: BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                    todayDecoration: BoxDecoration(color: Colors.blue.withOpacity(0.5), shape: BoxShape.circle),
                    disabledDecoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                  ),
                  calendarBuilders: CalendarBuilders(
                    disabledBuilder: (context, date, _) {
                      return Container(
                        margin: const EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.withOpacity(0.3),
                        ),
                        child: Center(
                          child: Text(
                            '${date.day}',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Text('Horas: '),
                    DropdownButton<int>(
                      value: _selectedHours,
                      items: [1, 2, 3, 4, 5, 6].map((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text('$value ${value == 1 ? 'hora' : 'horas'}'),
                        );
                      }).toList(),
                      onChanged: (int? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedHours = newValue;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('EQUIPOS DISPONIBLES', style: Theme.of(context).textTheme.headlineSmall),
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(16.0),
                  itemCount: _availableEquipment.length,
                  itemBuilder: (context, index) {
                    final equipment = _availableEquipment[index];
                    final isAvailable = provider.isItemAvailable(
                      equipment,
                      _selectedDay,
                      _selectedHours,
                    );
                    return _buildEquipmentTile(
                      context,
                      equipment,
                      isAvailable,
                      provider,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEquipmentTile(
    BuildContext context,
    String equipment,
    bool isAvailable,
    ReservationProvider provider,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(equipment, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isAvailable ? 'Disponible' : 'No disponible',
              style: TextStyle(
                color: isAvailable ? Colors.green : Colors.red,
              ),
            ),
            if (!isAvailable)
              Text(
                'Horario: 8:00 AM - 6:00 PM',
                style: TextStyle(fontSize: 12),
              ),
          ],
        ),
        trailing: ElevatedButton(
          child: Text('Reservar'),
          onPressed: isAvailable
              ? () async {
                  try {
                    await provider.addReservation(
                      equipment,
                      'equipment',
                      _selectedDay,
                      _selectedHours,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('$equipment reservado con éxito'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.toString()),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              : null,
        ),
      ),
    );
  }
}