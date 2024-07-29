import 'package:flutter/material.dart';

import 'textstyles.dart';

class RadioButtonsExample extends StatefulWidget {
  final String? selectedOption;
  final Function(String) onOptionChanged;

  RadioButtonsExample({
    this.selectedOption, // Change to String?
    required this.onOptionChanged,
  });

  @override
  State<RadioButtonsExample> createState() => _RadioButtonsExampleState();
}

class _RadioButtonsExampleState extends State<RadioButtonsExample> {
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
                'Select Consultation type',
                style: AppWidget.specsFieldstyle(),
              ),
            ),
          ),
          RadioListTile(
            title: Text('Standard Consultation'),
            value: 'Standard consultation',
            groupValue: widget.selectedOption,
            onChanged: (value) {
              widget.onOptionChanged(value.toString());
            },
          ),
          RadioListTile(
            title: Text('Long Consultation'),
            value: 'Long consultation',
            groupValue: widget.selectedOption,
            onChanged: (value) {
              widget.onOptionChanged(value.toString());
            },
          ),
          
         
        ],
      ),
    );
  }
}
