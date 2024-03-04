import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home.dart';
import 'model/api_model.dart';
import 'settings.dart';
import 'wifi_settings.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ApiModel(), // Crie uma instância de ApiModel
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final apiModel = context.read<ApiModel>();

    return FutureBuilder(
      future: apiModel.init(),
      builder: (context, snapshot) {
        debugPrint('>>>> snapshot: $snapshot e ${apiModel.externalUrl}');
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Mostra um loading enquanto a inicialização está ocorrendo
        } else {
          final initialRoute = apiModel.externalUrl.isEmpty ? '/settings' : '/';

          return MaterialApp(
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            initialRoute: initialRoute,
            routes: {
              '/': (context) => Home(),
              '/settings': (context) => Settings(),
              '/wifi-settings': (context) => WifiSettings(),
            },
          );
        }
      },
    );
  }
}
