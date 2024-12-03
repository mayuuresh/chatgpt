import 'package:chatgpt/constant/constants.dart';
import 'package:chatgpt/providers/models_provider.dart';
import 'package:chatgpt/screens/chat_screens.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) { return ModelsProvider(); }),
      ],
      child: MaterialApp(
        title: 'Hello World App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor:scaffoldBackgroundColor,
          
          appBarTheme: AppBarTheme(
            color: cardcolor,
          ),
        ),
        home: const ChatScreen(),
      ),
    );
  }
}
