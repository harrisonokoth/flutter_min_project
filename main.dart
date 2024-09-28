import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Send Money',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SendMoneyPage(),
    );
  }
}

class SendMoneyPage extends StatefulWidget {
  const SendMoneyPage({super.key});

  @override
  _SendMoneyPageState createState() => _SendMoneyPageState();
}

class _SendMoneyPageState extends State<SendMoneyPage> {
  final _formKey = GlobalKey<FormState>();
  String? recipientName;
  double? amount;
  String? paymentMethod;
  bool isFavorite = false;

  final List<String> paymentMethods = ['Credit Card', 'Debit Card', 'PayPal', 'M-PESA'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Money'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Recipient Name TextField
              TextFormField(
                decoration: const InputDecoration(labelText: 'Recipient Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a recipient name.';
                  }
                  return null;
                },
                onChanged: (value) {
                  recipientName = value;
                },
              ),
              const SizedBox(height: 16),

              // Amount TextField
              TextFormField(
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty || double.tryParse(value) == null || double.parse(value) <= 0) {
                    return 'Please enter a positive amount.';
                  }
                  return null;
                },
                onChanged: (value) {
                  amount = double.tryParse(value);
                },
              ),
              const SizedBox(height: 16),

              // Payment Method DropdownButton
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Payment Method'),
                value: paymentMethod,
                items: paymentMethods.map((String method) {
                  return DropdownMenuItem<String>(
                    value: method,
                    child: Text(method),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    paymentMethod = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a payment method.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Favorite Switch
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Mark as Favorite'),
                  Switch(
                    value: isFavorite,
                    onChanged: (value) {
                      setState(() {
                        isFavorite = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Send Money Button
              CustomButton(
                label: 'Send Money',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Simulate processing the transaction
                    _processTransaction(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to process the transaction
  void _processTransaction(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Transaction Details'),
          content: Text(
            'Recipient: $recipientName\n'
            'Amount: \$${amount?.toStringAsFixed(2)}\n'
            'Payment Method: $paymentMethod\n'
            'Favorite: ${isFavorite ? 'Yes' : 'No'}',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // Optionally, we can reset the form after the transaction
                _formKey.currentState!.reset();
                setState(() {
                  recipientName = null;
                  amount = null;
                  paymentMethod = null;
                  isFavorite = false;
                });
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );

    // Simulate a delay for transaction processing (e.g., API call)
    Future.delayed(const Duration(seconds: 2), () {
      // Handle successful transaction (e.g., logging, updating state, etc.)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transaction Processed Successfully!')),
      );
    });
  }
}

// Custom Button Widget
class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const CustomButton({required this.label, required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        backgroundColor: Colors.blue,
        textStyle: const TextStyle(fontSize: 18),
      ),
      child: Text(label),
    );
  }
}
