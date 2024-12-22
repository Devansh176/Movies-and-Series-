import 'package:cineflix/history.dart';
import 'package:cineflix/provider/historyProvider.dart';
import 'package:cineflix/provider/themeProvider.dart';
import 'package:cineflix/tabs.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider(),),
        ChangeNotifierProvider(create: (_) => HistoryProvider()..fetchDataFromDb(),),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            themeMode: themeProvider.getTheme() ? ThemeMode.dark : ThemeMode.light,
            darkTheme: ThemeData.dark(),
            theme: ThemeData(brightness: Brightness.dark,),
            debugShowCheckedModeBanner: false,
            home: Tabs(),
          );
        },
      ),
    );
  }
}

