import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction_entry.dart';
import '../viewmodels/transaction_view_model.dart';
import 'add_transaction_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({required this.viewModel, required this.initialBalance, super.key});

  final TransactionViewModel viewModel;
  final double initialBalance;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _query = '';
  TransactionType? _filterType;

  @override
  void initState() {
    super.initState();
    widget.viewModel.load();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.viewModel,
      builder: (context, _) {
        final filtered = widget.viewModel.transactions.where((entry) {
          if (_filterType != null && entry.type != _filterType) return false;
          if (_query.isNotEmpty &&
              !(entry.comment ?? '').toLowerCase().contains(_query.toLowerCase())) {
            return false;
          }
          return true;
        }).toList();

        final balance = widget.viewModel.currentBalance(widget.initialBalance);

        return Scaffold(
          appBar: AppBar(title: const Text('Expense Tracker')),
          floatingActionButton: FloatingActionButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => AddTransactionScreen(onSubmit: widget.viewModel.add),
              ),
            ),
            child: const Icon(Icons.add),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Card(
                  child: ListTile(
                    title: const Text('Current Balance'),
                    subtitle: Text(balance.toStringAsFixed(2)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Search by comment',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) => setState(() => _query = value),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilterChip(
                    label: const Text('Credit'),
                    selected: _filterType == TransactionType.credit,
                    onSelected: (selected) =>
                        setState(() => _filterType = selected ? TransactionType.credit : null),
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text('Debit'),
                    selected: _filterType == TransactionType.debit,
                    onSelected: (selected) =>
                        setState(() => _filterType = selected ? TransactionType.debit : null),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: filtered.isEmpty
                    ? const Center(child: Text('No transactions found.'))
                    : ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final item = filtered[index];
                          final sign = item.type == TransactionType.credit ? '+' : '-';
                          return Dismissible(
                            key: ValueKey(item.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: const Icon(Icons.delete, color: Colors.white),
                            ),
                            confirmDismiss: (_) => showDialog<bool>(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text('Delete transaction?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    child: const Text('Cancel'),
                                  ),
                                  FilledButton(
                                    onPressed: () => Navigator.pop(context, true),
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            ),
                            onDismissed: (_) => widget.viewModel.delete(item.id),
                            child: ListTile(
                              title: Text('$sign ${item.amount.toStringAsFixed(2)}'),
                              subtitle: Text(
                                '${DateFormat.yMMMd().add_jm().format(item.createdAt)}\n${item.comment ?? ''}',
                              ),
                              isThreeLine: true,
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
