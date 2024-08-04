import 'package:flutter/material.dart';

import '../pages/login_page.dart';
import '../thems/theme.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});
    
  // Этот виджет является корнем вашего приложения.
  @override
  Widget build(BuildContext context) {    
    return MaterialApp(
      title: 'Flutter Demo',
      theme: DoDidDoneTheme.lightTheme,
      home:const LoginPage(),
    );
  }
}  
  

