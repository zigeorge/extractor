import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({required this.onCompleted, super.key});

  final void Function(String sheetUrl, double initialBalance) onCompleted;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _sheetController = TextEditingController();
  final _balanceController = TextEditingController();

  @override
  void dispose() {
    _sheetController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  void _submit() {
    final url = _sheetController.text.trim();
    final balance = double.tryParse(_balanceController.text.trim());

    if (url.isEmpty || !url.startsWith('http')) {
      _showError('Please provide a valid Google Sheet URL.');
      return;
    }

    if (balance == null) {
      _showError('Please provide a valid initial balance.');
      return;
    }

    widget.onCompleted(url, double.parse(balance.toStringAsFixed(2)));
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Setup Expense Tracker')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _sheetController,
            decoration: const InputDecoration(
              labelText: 'Public Google Sheet URL',
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _balanceController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Initial Balance (BDT)'),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _submit,
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }
}
