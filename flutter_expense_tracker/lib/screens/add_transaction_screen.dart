import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/transaction_entry.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({required this.onSubmit, super.key});

  final Future<void> Function(TransactionEntry entry) onSubmit;

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _amountController = TextEditingController();
  final _commentController = TextEditingController();
  final _personController = TextEditingController();
  TransactionType _type = TransactionType.debit;
  DateTime _selected = DateTime.now();

  @override
  void dispose() {
    _amountController.dispose();
    _commentController.dispose();
    _personController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDate: _selected,
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selected),
    );
    if (time == null) return;

    setState(() {
      _selected = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<void> _submit() async {
    final amount = double.tryParse(_amountController.text.trim());
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid amount greater than 0.')),
      );
      return;
    }

    final now = DateTime.now();
    final entry = TransactionEntry(
      id: const Uuid().v4(),
      amount: double.parse(amount.toStringAsFixed(2)),
      type: _type,
      createdAt: _selected,
      updatedAt: now,
      comment: _commentController.text.trim().isEmpty
          ? null
          : _commentController.text.trim(),
      personName: _personController.text.trim().isEmpty
          ? null
          : _personController.text.trim(),
    );

    await widget.onSubmit(entry);
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Transaction')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Amount (BDT)'),
          ),
          const SizedBox(height: 12),
          SegmentedButton<TransactionType>(
            segments: const [
              ButtonSegment(
                value: TransactionType.credit,
                label: Text('Credit'),
              ),
              ButtonSegment(
                value: TransactionType.debit,
                label: Text('Debit'),
              ),
            ],
            selected: {_type},
            onSelectionChanged: (selection) {
              setState(() => _type = selection.first);
            },
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _commentController,
            decoration: const InputDecoration(labelText: 'Comment (optional)'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _personController,
            decoration: const InputDecoration(labelText: 'Person name (optional)'),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: _pickDateTime,
            child: Text('Date/Time: $_selected'),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _submit,
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
