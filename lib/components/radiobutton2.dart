import 'package:flutter/material.dart';
import 'textstyles.dart';

class appointment extends StatefulWidget {
  final String? selectedOption;
  final Function(String) onChanged;

  appointment({
    this.selectedOption,
    required this.onChanged,
  });

  @override
  State<appointment> createState() => _appointmentState();
}

class _appointmentState extends State<appointment> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 12.0,
                right: 8,
                top: 7,
                bottom: 10,
              ),
              child: Text(
                'Select Appointment type',
                style: AppWidget.specsFieldstyle(),
              ),
            ),
          ),
          RadioListTile(
            title: Text('Online Appointment'),
            value: 'online consultation',
            groupValue: widget.selectedOption,
            onChanged: (value) {
              widget.onChanged(value.toString());
            },
          ),
          RadioListTile(
            title: Text('Physical Appointment'),
            value: 'physical consultation',
            groupValue: widget.selectedOption,
            onChanged: (value) {
              widget.onChanged(value.toString());
            },
          ),
        ],
      ),
    );
  }
}
