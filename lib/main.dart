import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:statemanagement/providers/cartprovider.dart';
import 'package:statemanagement/providers/productsprovider.dart';
import 'package:statemanagement/screens/viewproducts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const StateApp());
}

class StateApp extends StatelessWidget {
  const StateApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF001B79),
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Products(),
        ),
        ChangeNotifierProvider(
          create: (_) => CartItems(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: colorScheme,
          appBarTheme: AppBarTheme(
            backgroundColor: colorScheme.onPrimaryContainer,
            foregroundColor: colorScheme.onPrimary,
            elevation: 4,
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: ViewProductsScreen(),
      ),
    );
  }
}
