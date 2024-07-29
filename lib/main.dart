
import 'package:clientwork/providers/homeprovider.dart';
import 'package:clientwork/providers/loginprovider.dart';
import 'package:clientwork/routes/routenames.dart';
import 'package:clientwork/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = "pk_test_51P2inqGMXRPnvuk38yWrJCei7IhAtB6kbWVJmQQekRIvQFE5Fya2JU8x0rO3WDvi77Gyb53CK4NgKZS4cXusslOE00FztRkxTh";
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  
  const MyApp({super.key});
  static final navigatorKey = GlobalKey<NavigatorState>();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) =>SelectedIndexProvider()),
            ChangeNotifierProvider(create: (_) =>LoginState()),



        ],
        child:MaterialApp(
           navigatorKey: navigatorKey,
     debugShowCheckedModeBanner: false,
     initialRoute: Routenames.splashscreen,
      onGenerateRoute: Routes.generateRoute
    ));}}
     