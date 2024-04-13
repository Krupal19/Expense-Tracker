import 'package:expense_trackere/models/expense.dart';
import 'package:expense_trackere/widgets/chart/chart.dart';
import 'package:expense_trackere/widgets/expenses_list/expenses_list.dart';
import 'package:expense_trackere/widgets/new_expense.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpense = [
    Expense(
      title: "Flutter Course",
      amount: 19.99,
      date: DateTime.now(),
      category: Category.work,
    ),
    Expense(
      title: "Cinema",
      amount: 15.69,
      date: DateTime.now(),
      category: Category.leisure,
    ),
  ];

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => NewExpense(
        onAddExpense: _addExpense,
      ),
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpense.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpense.indexOf(expense);
    setState(() {
      _registeredExpense.remove(expense);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text(
          'Expense deleted.',
          style: TextStyle(color: Colors.white),
        ),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredExpense.insert(expenseIndex, expense);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center(
      child: Text(
        'No Expenses found. Start adding some!',
        style: TextStyle(fontSize: 18),
        textAlign: TextAlign.center,
      ),
    );

    if (_registeredExpense.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpense,
        onRemoveExpense: _removeExpense,
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          'Expenses Tracker',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            color: Colors.white,
            iconSize: 25,
            tooltip: "Add Expenses",
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Chart(expenses: _registeredExpense),
            Expanded(
              child: mainContent,
            )
          ],
        ),
      ),
    );
  }
}
