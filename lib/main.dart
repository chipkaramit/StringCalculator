// lib/main.dart

import 'package:flutter/material.dart';
import 'string_calculator.dart';

void main() {
  runApp(const StringCalculatorApp());
}

class StringCalculatorApp extends StatelessWidget {
  const StringCalculatorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'String Calculator TDD Kata',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({Key? key}) : super(key: key);

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final TextEditingController _inputController = TextEditingController();
  final StringCalculator _calculator = StringCalculator();
  
  String _result = '';
  String _errorMessage = '';
  bool _hasError = false;

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _calculate() {
    setState(() {
      _errorMessage = '';
      _hasError = false;
      _result = '';
    });

    try {
      final int sum = _calculator.add(_inputController.text);
      setState(() {
        _result = sum.toString();
      });
    } on NegativeNumberException catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = e.toString();
      });
    } on FormatException catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Invalid input format: ${e.message}';
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = 'An error occurred: $e';
      });
    }
  }

  void _clear() {
    setState(() {
      _inputController.clear();
      _result = '';
      _errorMessage = '';
      _hasError = false;
    });
  }

  Widget _buildExampleCard(String title, String input, String output) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Input: "$input"',
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
              ),
            ),
            Text(
              'Output: $output',
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('String Calculator TDD Kata'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Input Section
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Enter Numbers',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _inputController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'e.g., 1,2,3 or //;\\n1;2;3',
                          border: const OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _calculate,
                              icon: const Icon(Icons.calculate),
                              label: const Text('Calculate'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(16),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            onPressed: _clear,
                            icon: const Icon(Icons.clear),
                            label: const Text('Clear'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(16),
                              backgroundColor: Colors.grey[300],
                              foregroundColor: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Result Section
              if (_result.isNotEmpty || _hasError)
                Card(
                  elevation: 4,
                  color: _hasError ? Colors.red[50] : Colors.green[50],
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _hasError ? 'Error' : 'Result',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _hasError ? Colors.red[900] : Colors.green[900],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _hasError ? _errorMessage : _result,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'monospace',
                            color: _hasError ? Colors.red[700] : Colors.green[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 24),

              // Examples Section
              const Text(
                'Examples',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              
              _buildExampleCard(
                'Empty String',
                '',
                '0',
              ),
              
              _buildExampleCard(
                'Single Number',
                '1',
                '1',
              ),
              
              _buildExampleCard(
                'Two Numbers',
                '1,5',
                '6',
              ),
              
              _buildExampleCard(
                'Multiple Numbers',
                '1,2,3,4,5',
                '15',
              ),
              
              _buildExampleCard(
                'Newline Delimiter',
                '1\\n2,3',
                '6',
              ),
              
              _buildExampleCard(
                'Custom Delimiter',
                '//;\\n1;2',
                '3',
              ),
              
              Card(
                elevation: 2,
                color: Colors.orange[50],
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Negative Numbers',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Input: "1,-2,-3"',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        'Error: negative numbers not allowed -2,-3',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
