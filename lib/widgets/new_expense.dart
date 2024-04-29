import 'package:expense_trackere/models/expense.dart';
import 'package:flutter/material.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;

  Category _selectedCategory = Category.leisure;

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickDate = await showDatePicker(
      context: context,
      firstDate: firstDate,
      lastDate: now,
    );
    setState(() {
      _selectedDate = pickDate;
    });
  }

  void _submitExpenseDate() {
    final enteredAmount = double.tryParse(_amountController.text);
    //tryParse('Hello') => null, tryParse('1.12') =. 1.12
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text(
            "Invalid Input",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 26),
          ),
          content: const Text(
              "Please make sure a valid title, amount, date and category was entered."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Okay"),
            ),
          ],
        ),
      );
      return;
    }
    widget.onAddExpense(
      Expense(
          title: _titleController.text,
          amount: enteredAmount,
          date: _selectedDate!,
          category: _selectedCategory),
    );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constraints) {
      final width = constraints.maxWidth;
      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            // padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 12),
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (width >= 600)
                  Row(
                    children: [
                      TextField(
                        controller: _titleController,
                        autofocus: false,
                        maxLength: 50,
                        decoration: const InputDecoration(
                          labelText: "Title",
                          focusColor: Colors.deepPurpleAccent,
                          border: OutlineInputBorder(
                            gapPadding: 5,
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                    ],
                  )
                else
                const Divider(
                  thickness: 3,
                  indent: 150,
                  endIndent: 150,
                  color: Color(0xFF8A99A2),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          prefix: Text(
                            "\u20B9 ",
                            style: TextStyle(
                              color: Colors.deepPurpleAccent,
                            ),
                          ),
                          labelText: "Amount",
                          border: OutlineInputBorder(
                            gapPadding: 5,
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(_selectedDate == null
                              ? "No date selected:"
                              : formatter.format(_selectedDate!)),
                          IconButton(
                            onPressed: _presentDatePicker,
                            icon: const Icon(Icons.calendar_month),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.white24, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.white24, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                  ),
                  value: _selectedCategory,
                  borderRadius: BorderRadius.circular(12),
                  autofocus: false,
                  items: Category.values
                      .map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(category.name.toString()),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value!;
                    });
                  },
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _submitExpenseDate();
                        },
                        child: const Text("Save Expense"),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
