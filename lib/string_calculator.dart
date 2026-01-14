// lib/string_calculator.dart

/// Exception thrown when negative numbers are provided to the calculator
class NegativeNumberException implements Exception {
  final List<int> negativeNumbers;

  NegativeNumberException(this.negativeNumbers);

  @override
  String toString() {
    return 'negative numbers not allowed ${negativeNumbers.join(',')}';
  }
}

/// A String Calculator that performs addition on comma-separated numbers
/// 
/// Supports:
/// - Empty strings
/// - Single and multiple numbers
/// - Custom delimiters
/// - Newlines as delimiters
/// - Validates against negative numbers
class StringCalculator {
  static const String _defaultDelimiter = ',';
  static const String _delimiterPrefix = '//';
  static const String _newLine = '\n';

  /// Adds numbers from a string input
  /// 
  /// [numbers] - A string containing numbers separated by delimiters
  /// 
  /// Returns the sum of all numbers in the string
  /// 
  /// Throws [NegativeNumberException] if negative numbers are present
  /// 
  /// Examples:
  /// ```dart
  /// add("") // returns 0
  /// add("1") // returns 1
  /// add("1,2") // returns 3
  /// add("1\n2,3") // returns 6
  /// add("//;\n1;2") // returns 3
  /// ```
  int add(String numbers) {
    if (numbers.isEmpty) {
      return 0;
    }

    final ParsedInput parsed = _parseInput(numbers);
    final List<int> numberList = _extractNumbers(parsed);
    
    _validateNumbers(numberList);
    
    return _sum(numberList);
  }

  /// Parses the input string to extract delimiter and number string
  ParsedInput _parseInput(String input) {
    if (input.startsWith(_delimiterPrefix)) {
      final int delimiterEndIndex = input.indexOf(_newLine);
      final String delimiter = input.substring(
        _delimiterPrefix.length,
        delimiterEndIndex,
      );
      final String numberString = input.substring(delimiterEndIndex + 1);
      
      return ParsedInput(delimiter, numberString);
    }

    return ParsedInput(_defaultDelimiter, input);
  }

  /// Extracts individual numbers from the parsed input
  List<int> _extractNumbers(ParsedInput parsed) {
    String normalizedInput = parsed.numberString
        .replaceAll(_newLine, parsed.delimiter);

    return normalizedInput
        .split(parsed.delimiter)
        .where((s) => s.isNotEmpty)
        .map((s) => int.parse(s.trim()))
        .toList();
  }

  /// Validates that no negative numbers are present
  void _validateNumbers(List<int> numbers) {
    final List<int> negatives = numbers.where((n) => n < 0).toList();
    
    if (negatives.isNotEmpty) {
      throw NegativeNumberException(negatives);
    }
  }

  /// Calculates the sum of numbers
  int _sum(List<int> numbers) {
    return numbers.fold(0, (sum, number) => sum + number);
  }
}

/// Data class to hold parsed input information
class ParsedInput {
  final String delimiter;
  final String numberString;

  ParsedInput(this.delimiter, this.numberString);
}
