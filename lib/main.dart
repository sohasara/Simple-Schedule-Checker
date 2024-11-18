import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TimeOfDay? _meeting1Start;
  TimeOfDay? _meeting1End;
  TimeOfDay? _meeting2Start;
  TimeOfDay? _meeting2End;

  String _resultMessage = '';

  /// Method to check for conflicts
  void _checkConflict() {
    if (_meeting1Start == null ||
        _meeting1End == null ||
        _meeting2Start == null ||
        _meeting2End == null) {
      setState(() {
        _resultMessage = 'Please select all times.';
      });
      return;
    }

    // Convert TimeOfDay to DateTime
    final now = DateTime.now();
    final meeting1Start = DateTime(
      now.year,
      now.month,
      now.day,
      _meeting1Start!.hour,
      _meeting1Start!.minute,
    );
    final meeting1End = DateTime(
      now.year,
      now.month,
      now.day,
      _meeting1End!.hour,
      _meeting1End!.minute,
    );

    final meeting2Start = DateTime(
      now.year,
      now.month,
      now.day,
      _meeting2Start!.hour,
      _meeting2Start!.minute,
    );
    final meeting2End = DateTime(
      now.year,
      now.month,
      now.day,
      _meeting2End!.hour,
      _meeting2End!.minute,
    );

    // Adjust for overnight meetings
    final adjustedMeeting2End = meeting2End.isBefore(meeting2Start)
        ? meeting2End.add(const Duration(days: 1))
        : meeting2End;

    // Check for conflicts
    bool conflict = meeting1Start.isBefore(adjustedMeeting2End) &&
        meeting1End.isAfter(meeting2Start);

    setState(() {
      _resultMessage =
          conflict ? 'Meetings conflict!' : 'No conflict, you are good to go!';
    });
  }

  /// Method to pick time
  Future<TimeOfDay?> _pickTime(BuildContext context) async {
    return await showTimePicker(context: context, initialTime: TimeOfDay.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meeting Scheduler')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Set Meeting 1 Time:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () async {
                    _meeting1Start = await _pickTime(context);
                    setState(() {});
                  },
                  child: Text(
                    'Start: ${_meeting1Start?.format(context) ?? 'Select'}',
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    _meeting1End = await _pickTime(context);
                    setState(() {});
                  },
                  child: Text(
                    'End: ${_meeting1End?.format(context) ?? 'Select'}',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Set Meeting 2 Time:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () async {
                    _meeting2Start = await _pickTime(context);
                    setState(() {});
                  },
                  child: Text(
                    'Start: ${_meeting2Start?.format(context) ?? 'Select'}',
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    _meeting2End = await _pickTime(context);
                    setState(() {});
                  },
                  child: Text(
                    'End: ${_meeting2End?.format(context) ?? 'Select'}',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkConflict,
              child: const Text('Check Conflict'),
            ),
            const SizedBox(height: 20),
            Text(
              _resultMessage,
              style: TextStyle(
                fontSize: 18,
                color: _resultMessage.contains('conflict')
                    ? Colors.red
                    : Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
