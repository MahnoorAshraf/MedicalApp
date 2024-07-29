import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DateSelectField extends StatefulWidget {
  final void Function(DateTime) onSelect;
  DateSelectField({required this.onSelect});
  @override
  _DateSelectFieldState createState() => _DateSelectFieldState();
}

class _DateSelectFieldState extends State<DateSelectField> {
  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      widget.onSelect(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8, left: 15, right: 15),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black, width: 1),
        ),
        child: TextFormField(
          readOnly: true,
          controller: TextEditingController(
            text: selectedDate != null
                ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                : 'Select a Date',
          ),
          onTap: () {
            _selectDate(context);
          },
          decoration: InputDecoration(
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}

class TimeSelectField extends StatefulWidget {
  final void Function(TimeOfDay) onSelect;
  TimeSelectField({required this.onSelect});

  @override
  _TimeSelectFieldState createState() => _TimeSelectFieldState();
}

class _TimeSelectFieldState extends State<TimeSelectField> {
  TimeOfDay? selectedTime;

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
      widget.onSelect(picked); // Pass selected time to parent widget
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8, left: 15, right: 15),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black, width: 1),
        ),
        child: TextFormField(
          readOnly: true,
          controller: TextEditingController(
            text: selectedTime != null
                ? selectedTime!.format(context)
                : 'Select a Time',
          ),
          onTap: () {
            _selectTime(context);
          },
          decoration: InputDecoration(
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}

class fields extends StatefulWidget {
  final String? selectedConsultationType;
  final int doctorId;

  final String? selectedAppointmentType;
  final DateTime? selectedDate;
  final Map<String, dynamic> doctorDetails;

  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController consultationController;
  final void Function({
    required String consultationReason,
    required String email,
    required String firstName,
    required String lastName,
    required String phone,
  }) updateFormFieldValues;
  fields({
    Key? key,
    required this.doctorDetails,
    this.selectedConsultationType,
    this.selectedAppointmentType,
    required this.doctorId,
    this.selectedDate,
        
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.phoneController,
    required this.consultationController, required this.updateFormFieldValues,
  }) : super(key: key);

  

  @override
  State<fields> createState() => FieldsState();
}

class FieldsState extends State<fields> {
  DateTime? selectedDate;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TimeOfDay? selectedTime;
  String? selectedConsultationType;
  String? selectedAppointmentType;
 bool _isSubmitting = false;
 Timer? _debounce;
  @override
  void initState() {
    super.initState();
    int doctorId = widget.doctorId;
    // selectedConsultationType = widget.selectedConsultationType;
    selectedDate = widget.selectedDate;
    selectedOption = widget.selectedConsultationType ?? '';
    selectedAppointmentType = widget.selectedAppointmentType ?? '';
 
  }

  Future<void> sendDataToServer(int doctorId) async {
     if (_isSubmitting) return;
    setState(() {
      _isSubmitting = true;
    });
    if (!_formKey.currentState!.validate()) {
      print("Form validation failed");
      setState(() {
        _isSubmitting = false;
      });
      return;
    
    }
var apiUrl = "https://itjoblinks.com/public/api/doctors/appointments";
    String formattedDate = selectedDate != null
        ? '${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}'
        : '';
    String formattedTime = selectedTime != null
        ? '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}'
        : '';
    Map<String, dynamic> mapData = {
      'f_name': widget.firstNameController.text,
      'l_name': widget.lastNameController.text,
      'email': widget.emailController.text,
      'phone': widget.phoneController.text,
      'reason': widget.consultationController.text,
      'doctor_id': doctorId,
      'date': widget.selectedDate.toString(),
      'cons_type': widget.selectedConsultationType,
      'time': formattedTime,
      'type_of_appointment': widget.selectedAppointmentType,
    };
    print("Json Data: $mapData");
    try {
      http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(mapData),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print('Data: $data');
      } else {
        print('Error: ${response.statusCode}');
        print('Response body: ${response.body}');
        // Handle error
      }
    } catch (e) {
      print('Exception caught: $e');
      // Handle exception
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }
 void _onFormSubmit() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(seconds: 1), () {
      sendDataToServer(widget.doctorId);
    });
  }
  String selectedOption = '';

  @override
  Widget build(BuildContext context) {
    return Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: _formKey,
        child: Column(children: [
           CustomTextFormField(
            controller: widget.firstNameController,
             keyboardType: TextInputType.name,
            hintText: 'First Name',
            
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please Enter name';
              }
              return null;
            },
          ),
        
        CustomTextFormField(
            controller: widget.lastNameController,
             keyboardType: TextInputType.name,
            hintText: 'Last Name',
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please Enter name';
              }
              return null;
            },
          ),
          CustomTextFormField(
            controller: widget.emailController,
             keyboardType: TextInputType.emailAddress,
            hintText: 'Email',
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please Enter Email';
              }
              return null;
            },
          ),
          CustomTextFormField(
            controller: widget.phoneController,
             keyboardType: TextInputType.phone,
            hintText: 'Phone no.',
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please Enter number';
              }
              return null;
            },
          ),
          CustomTextFormField(
            controller: widget.consultationController,
             keyboardType: TextInputType.text,
            hintText: 'Reason of Consultation',
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please Enter Reason';
              }
              return null;
            },
          ),
          TimeSelectField(
            onSelect: (TimeOfDay time) {
              setState(() {
                selectedTime = time;
              });
            },
          ),
        ],
      ),
    );
  }
   validate() {}

}

 
class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?) validator;
  final TextInputType keyboardType;

  const CustomTextFormField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.validator,
    this.keyboardType = TextInputType.text, // Default to TextInputType.text
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black, width: 1),
        ),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
          ),
          validator: validator,
          keyboardType: keyboardType,
        ),
      ),
    );
  }
}