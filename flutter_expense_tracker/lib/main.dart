import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';
import 'services/transaction_repository.dart';
import 'viewmodels/transaction_view_model.dart';

void main() {
  runApp(const ExpenseTrackerApp());
}

class ExpenseTrackerApp extends StatefulWidget {
  const ExpenseTrackerApp({super.key});

  @override
  State<ExpenseTrackerApp> createState() => _ExpenseTrackerAppState();
}

class _ExpenseTrackerAppState extends State<ExpenseTrackerApp> {
  String? _sheetUrl;
  double? _initialBalance;
  late final TransactionViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = TransactionViewModel(repository: InMemoryTransactionRepository());
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.teal),
      home: _sheetUrl == null || _initialBalance == null
          ? OnboardingScreen(
              onCompleted: (sheetUrl, initialBalance) {
                setState(() {
                  _sheetUrl = sheetUrl;
                  _initialBalance = initialBalance;
                });
              },
            )
          : HomeScreen(
              viewModel: _viewModel,
              initialBalance: _initialBalance!,
            ),
    );
  }
}
