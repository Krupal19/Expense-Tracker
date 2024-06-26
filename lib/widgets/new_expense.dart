import 'package:expense_trackere/models/expense.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter/cupertino.dart';

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

  void _showDialog() {
    if (Platform.isIOS) {
      showCupertinoDialog(
          context: context,
          builder: (ctx) => CupertinoAlertDialog(
                title: const Text('Invalid input'),
                content: const Text(
                    'Please make sure a valid title, amount, date and category was entered.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                    },
                    child: const Text('Okay'),
                  ),
                ],
              ));
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid input'),
          content: const Text(
              'Please make sure a valid title, amount, date and category was entered.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
    }
  }

  void _submitExpenseDate() {
    final enteredAmount = double.tryParse(_amountController.text);
    //tryParse('Hello') => null, tryParse('1.12') =. 1.12
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      _showDialog();
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
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(builder: (ctx, constraints) {
      final width = constraints.maxWidth;
      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
            child: Column(
              children: [
                if (width >= 600)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _titleController,
                          maxLength: 50,
                          decoration: const InputDecoration(
                            label: Text('Title'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            prefixText: '\$ ',
                            label: Text('Amount'),
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  TextField(
                    controller: _titleController,
                    maxLength: 50,
                    decoration: const InputDecoration(
                      label: Text('Title'),
                    ),
                  ),
                if (width >= 600)
                  Row(children: [
                    DropdownButton(
                      value: _selectedCategory,
                      items: Category.values
                          .map(
                            (category) => DropdownMenuItem(
                              value: category,
                              child: Text(
                                category.name.toUpperCase(),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }
                        setState(() {
                          _selectedCategory = value;
                        });
                      },
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            _selectedDate == null
                                ? 'No date selected'
                                : formatter.format(_selectedDate!),
                          ),
                          IconButton(
                            onPressed: _presentDatePicker,
                            icon: const Icon(
                              Icons.calendar_month,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ])
                else
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            prefixText: '\$ ',
                            label: Text('Amount'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              _selectedDate == null
                                  ? 'No date selected'
                                  : formatter.format(_selectedDate!),
                            ),
                            IconButton(
                              onPressed: _presentDatePicker,
                              icon: const Icon(
                                Icons.calendar_month,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 16),
                if (width >= 600)
                  Row(children: [
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: _submitExpenseDate,
                      child: const Text('Save Expense'),
                    ),
                  ])
                else
                  Row(
                    children: [
                      DropdownButton(
                        value: _selectedCategory,
                        items: Category.values
                            .map(
                              (category) => DropdownMenuItem(
                                value: category,
                                child: Text(
                                  category.name.toUpperCase(),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          setState(() {
                            _selectedCategory = value;
                          });
                        },
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: _submitExpenseDate,
                        child: const Text('Save Expense'),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

// Don't check below code
/*
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
Expanded(
child: TextField(
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
),
const SizedBox(width: 24),
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
],
)
else
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
);*/
