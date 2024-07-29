import 'dart:async';
import 'dart:convert';
import 'package:clientwork/components/radiobutton.dart';
import 'package:clientwork/components/radiobutton2.dart';
import 'package:clientwork/routes/routenames.dart';
import 'package:clientwork/screens/form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../components/button.dart';
import '../components/textstyles.dart';


class paymentmethod extends StatefulWidget {
  final Map<String, dynamic> doctorDetails;
  const paymentmethod({Key? key, required this.doctorDetails})
      : super(key: key);
  State<paymentmethod> createState() => _PaymentMethodState();
}
class Doctor {
  final int id;

  Doctor({
    required this.id,
  });

  factory Doctor.fromId(int id) {
    return Doctor(
      id: id,
    );
  }
}

class _PaymentMethodState extends State<paymentmethod> {
  String firstName = '';
  String lastName = '';
  String email = '';
  String phone = '';
  String consultationReason = '';

  // Callback function to update form field values
  void updateFormFieldValues({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String consultationReason,
  }) {
    setState(() {
      this.firstName = firstName;
      this.lastName = lastName;
      this.email = email;
      this.phone = phone;
      this.consultationReason = consultationReason;
    });
  }
  DateTime? selectedDate;
  Doctor? doctor;
   int? doctorId;
Timer? _debounce;
 Future<int> fetchDoctorIdFromApi() async {
  final response = await http.get(Uri.parse('https://itjoblinks.com/public/api/doctors/list'));

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = jsonDecode(response.body);

    if (responseData['status'] == 'success') {
      final List<dynamic> doctorData = responseData['data'];
      
      // Assuming you have some way to determine the selected doctor, 
      // let's say it's stored in widget.doctorDetails['selectedDoctorId']
      final selectedDoctorId = widget.doctorDetails['selectedDoctorId'];

      // Find the selected doctor in the list of doctors
      final selectedDoctor = doctorData.firstWhere((doctor) => doctor['id'] == selectedDoctorId, orElse: () => null);

      if (selectedDoctor != null) {
        return selectedDoctor['id'] as int;
      } else {
        throw Exception('Selected doctor not found in the list');
      }
    } else {
      throw Exception('Failed to fetch doctor data: ${responseData['message']}');
    }
  } else {
    throw Exception('Failed to load doctor data from API');
  }
}
Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      // Check if picked date is not null
      setState(() {
        selectedDate = picked;
      });

      // Now that selectedDate is updated, you can check if it's a weekday or a weekend.
      bool isWeekday = picked.weekday >= 1 && picked.weekday <= 5;
      bool isWeekend = picked.weekday == 6 || picked.weekday == 7;

      print('Selected Date: $picked');
      print('Is Weekday: $isWeekday');
      print('Is Weekend: $isWeekend');
    } else {
      print('No date selected.');
    }
  }
 String selectedAppointmentType = '';
  String selectedOption = '';
  
  final GlobalKey<FieldsState> fieldsKey = GlobalKey<FieldsState>();
   void handleOptionChange(String option) {
    setState(() {
      selectedOption = option;
    });
  }
  void handleAppointmentTypeChange(String? newAppointmentType) {
  setState(() {
    selectedAppointmentType = newAppointmentType!;
  });
}
   Future<void> submitForm() async {
    try {
      if (doctorId == null) {
        throw Exception('No doctor is selected');
      }

      print('Selected Doctor ID: $doctorId');

      // Pass the selected doctor ID to sendDataToServer method
      fieldsKey.currentState?.sendDataToServer(doctorId!);
    } catch (e) {
      print('Error: $e');
    }
  }
  final TextEditingController firstNameController = TextEditingController();
final TextEditingController lastNameController = TextEditingController();
final TextEditingController emailController = TextEditingController();
final TextEditingController phoneController = TextEditingController();
final TextEditingController consultationController = TextEditingController();





  Map<String, dynamic>? paymentIntentData;
    
  @override
  void initState() {
    super.initState();
    // Set the doctor ID from the passed doctor details
    doctorId = widget.doctorDetails['doctor_id'];
    selectedDate = DateTime.now();
    print('Selected Doctor ID: $doctorId');
  }
    void _onFormSubmit() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(seconds: 1), () {
      fieldsKey.currentState?.sendDataToServer(doctorId!);
    });
  }
  Widget build(BuildContext context) {
     
    return Scaffold(
      appBar: AppBar(
    backgroundColor: Colors.blue,
    title: Text('Book Appointment',style: TextStyle(color: Colors.white),),
    centerTitle: true, // Adjust as needed
    leading: GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Icon(
        Icons.arrow_back_ios, // iOS back arrow icon
        color: Colors.white, // Adjust as needed
      ),
    ),),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, right: 8, top: 20, bottom: 10),
                child: Text(
                  'Fill the following Form',
                  style: AppWidget.BTextFieldstyle(),
                ),
              ),
            
fields(
  key: fieldsKey,
  doctorDetails: widget.doctorDetails, 
  selectedConsultationType: selectedOption,
    doctorId: doctorId!,
  selectedDate: selectedDate, 
  selectedAppointmentType: selectedAppointmentType,
  firstNameController: firstNameController,
  lastNameController: lastNameController,
  emailController: emailController,
  phoneController: phoneController,
  consultationController: consultationController,
  updateFormFieldValues: updateFormFieldValues,
),
DateSelectField(onSelect: (DateTime date) {
            
            setState(() {
              selectedDate = date; 
            });
          }),


               
             RadioButtonsExample(
                selectedOption: selectedOption,
                onOptionChanged: handleOptionChange,
              ),
                SizedBox(height: 10),
          appointment(
                selectedOption: selectedAppointmentType,
                onChanged: handleAppointmentTypeChange,
              ),

              SizedBox(height: 10),
            
SizedBox(height: 10),
              Align(
                alignment: Alignment.bottomCenter,
                child: Containers(
                  clr: Colors.blue,
                  txt: 'Pay Fee',
                  onTap: () async {
                    fieldsKey.currentState?.sendDataToServer(doctorId!);
                      // submitForm();
                       _onFormSubmit();
                       fieldsKey.currentState?.sendDataToServer(doctorId!);
                    await makePayment(selectedDate);
                
                    print('Payment successful');
                    
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> makePayment(DateTime? selectedDate) async {
    final String sConsWeekday = '90';
    final String sConsWeekend = '100';
    final String lConsWeekday = '130';
    final String lConsWeekend = '140';

    try {
      print('Success');

   bool isWeekday = false;

if (selectedDate != null) {
  isWeekday = selectedDate.weekday >= 1 && selectedDate.weekday <= 5;
}

String fee = '';

if (selectedOption == 'Standard consultation') {
  if (isWeekday) {
    fee = sConsWeekday;
  } else {
    fee = sConsWeekend;
  }
} 

if (selectedOption == 'Long consultation') {
  if (isWeekday) {
    fee = lConsWeekday;
  } else {
    fee =lConsWeekend;
  }
}

      paymentIntentData = await createPaymentIntent(fee, 'USD');

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentData!['client_secret'],
          merchantDisplayName: 'Client',
          style: ThemeMode.system,
        ),
      );
      displayPaymentSheet();
    } catch (e) {
      print('Error Occurred: $e '); // Print actual error message
      showErrorToast('Error Occurred :('); // Call showErrorToast method
    }
  }

  Future<void> displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      showSuccessToast('Payment Successful');
      Navigator.pushNamed(context, Routenames.bottomnavbar);
    } catch (e) {
      print('Error Occurred: $e'); // Print actual error message
      showErrorToast('Error Occurred :('); // Call showErrorToast method
    }
  }

  Future<Map<String, dynamic>> createPaymentIntent(
    String amount,
    String currency,
  ) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card',
      };
      final response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        body: body,
        headers: {
          'Authorization':
              'Bearer sk_test_51P2inqGMXRPnvuk3S6Xld4ofpCFkyNf1FkE47fgZP4HjrJOBfm16dPvpOQSHLnc042FusG1kevJgpQ1Nfnnjz5NC00DmjD2cpD',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );
      return jsonDecode(response.body.toString());
    } catch (e) {
      print('Error Occurred: $e'); // Print actual error message
      throw Exception(
          'Failed to create payment intent'); // Throw an exception for better error handling
    }
  }

  String calculateAmount(String amount) {
    final cleanedAmount = amount.replaceAll(RegExp(r'[^0-9]'), '');
    final price = int.tryParse(cleanedAmount) ?? 0;
    return (price * 100).toString();
  }

  void showErrorToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void showSuccessToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}