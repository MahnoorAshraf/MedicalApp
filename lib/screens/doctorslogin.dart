import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../routes/routenames.dart';
import '../providers/loginprovider.dart';
import '../components/button.dart';



class login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LoginForm(),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool loading = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

 
void login(String email, String password) async {
  if (email.isEmpty || password.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Please enter the missing information'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
    return;
  }

  setState(() {
    loading = true;
  });

  try {
    Response response = await post(
      Uri.parse('https://itjoblinks.com/public/api/applogin'),
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      print(data);
      print('Logged in successfully');

      // Store the token in shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);

      // Use the stored token value
      Provider.of<LoginState>(context, listen: false).setToken(data['token']);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logged in Successfully'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      // Navigate to AppointmentList after successful login
      Navigator.pushNamed(context, Routenames.AppointmentList);
    } else {
      // Handle login failure
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login failed. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
      print('login Failed');
    }
  } catch (e) {
    print(e.toString());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('An error occurred. Please try again.'),
        backgroundColor: Colors.red,
      ),
    );
  } finally {
    setState(() {
      loading = false;
    });
  }
}

  @override
  Widget build(BuildContext context) {
     final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: SingleChildScrollView(
          child: Column(children: [
                Container(
          decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(150))),
          height: screenHeight * 0.22,
          width: screenWidth * 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 18.0, left: 14, bottom: 10),
                child: SafeArea(
                  child: Text(
                    'Welcome Back!',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 14, bottom: 10),
                child: Text(
                  'Log In',
                  style: GoogleFonts.poppins(fontSize: 34, color: Colors.white),
                ),
              ),
            ],
          ),
                ),
                Padding(
          padding: const EdgeInsets.only(left:8.0,top: 14),
          child: Image.asset("lib/assets/logo.png",
          height: screenHeight * 0.1,
          width: screenWidth * 0.5,
          ),
                ),
                
                Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 17),
              child: Text(
                'Email address',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height:10),
            Container(
                                        padding:
                                            EdgeInsets.only(left: 10, top: 3),
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 20),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Color.fromARGB(255, 160, 160, 147),
                                          ),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextFormField(
                                            controller: emailController,
                                            obscureText: false,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: 'Email',
                                              prefixIcon: Icon(Icons.email),
                                            ),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Please enter email';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                  
            Padding(
              padding: const EdgeInsets.only(top: 12.0, left: 17),
              child: Text(
                'Password',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
             SizedBox(height:10),
             Container(
                                        padding:
                                            EdgeInsets.only(left: 10, top: 3),
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 20),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Color.fromARGB(255, 160, 160, 147),
                                          ),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextFormField(
                                            controller: passwordController,
                                            obscureText: true,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: 'Password',
                                              prefixIcon: Icon(Icons.lock),
                                            ),
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Please Enter Password';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                  
           SizedBox(height: 50),
                                  Center(
                                    child: Container(
                                      margin: EdgeInsets.symmetric(horizontal: 20),
                                      child: Containers(
                                        clr: Colors.blue,
                                        loading: loading,
                                        txt: 'Login',
                                        onTap: () {
                                          login(
                                            emailController.text.toString(),
                                            passwordController.text.toString(),
                                          );
                                        },
                                      ),
                                    
                                         ),
                                  )])]),
        )); 
                                    
         
          
         
        
    
  }
}
