// test/string_calculator_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:string_calculator_kata/string_calculator.dart';

void main() {
  late StringCalculator calculator;

  setUp(() {
    calculator = StringCalculator();
  });

  group('String Calculator - Basic Functionality', () {
    test('returns 0 for empty string', () {
      // Arrange
      const String input = '';

      // Act
      final int result = calculator.add(input);

      // Assert
      expect(result, equals(0));
    });

    test('returns the number itself for single number', () {
      // Arrange
      const String input = '1';

      // Act
      final int result = calculator.add(input);

      // Assert
      expect(result, equals(1));
    });

    test('returns sum for two comma-separated numbers', () {
      // Arrange
      const String input = '1,5';

      // Act
      final int result = calculator.add(input);

      // Assert
      expect(result, equals(6));
    });
  });

  group('String Calculator - Multiple Numbers', () {
    test('handles multiple comma-separated numbers', () {
      // Arrange
      const String input = '1,2,3,4,5';

      // Act
      final int result = calculator.add(input);

      // Assert
      expect(result, equals(15));
    });

    test('handles large numbers', () {
      // Arrange
      const String input = '100,200,300';

      // Act
      final int result = calculator.add(input);

      // Assert
      expect(result, equals(600));
    });
  });

  group('String Calculator - Newline Delimiter', () {
    test('handles newline between numbers', () {
      // Arrange
      const String input = '1\n2,3';

      // Act
      final int result = calculator.add(input);

      // Assert
      expect(result, equals(6));
    });

    test('handles only newlines as delimiters', () {
      // Arrange
      const String input = '1\n2\n3';

      // Act
      final int result = calculator.add(input);

      // Assert
      expect(result, equals(6));
    });

    test('handles mixed newlines and commas', () {
      // Arrange
      const String input = '1\n2,3\n4,5';

      // Act
      final int result = calculator.add(input);

      // Assert
      expect(result, equals(15));
    });
  });

  group('String Calculator - Custom Delimiters', () {
    test('handles semicolon as custom delimiter', () {
      // Arrange
      const String input = '//;\n1;2';

      // Act
      final int result = calculator.add(input);

      // Assert
      expect(result, equals(3));
    });

    test('handles pipe as custom delimiter', () {
      // Arrange
      const String input = '//|\n1|2|3';

      // Act
      final int result = calculator.add(input);

      // Assert
      expect(result, equals(6));
    });

    test('handles custom delimiter with multiple numbers', () {
      // Arrange
      const String input = '//:\n1:2:3:4:5';

      // Act
      final int result = calculator.add(input);

      // Assert
      expect(result, equals(15));
    });

    test('handles asterisk as custom delimiter', () {
      // Arrange
      const String input = '//*\n1*2*3';

      // Act
      final int result = calculator.add(input);

      // Assert
      expect(result, equals(6));
    });
  });

  group('String Calculator - Negative Numbers', () {
    test('throws exception for single negative number', () {
      // Arrange
      const String input = '-1';

      // Act & Assert
      expect(
        () => calculator.add(input),
        throwsA(
          isA<NegativeNumberException>().having(
            (e) => e.toString(),
            'error message',
            equals('negative numbers not allowed -1'),
          ),
        ),
      );
    });

    test('throws exception for multiple negative numbers', () {
      // Arrange
      const String input = '1,-2,-3,4';

      // Act & Assert
      expect(
        () => calculator.add(input),
        throwsA(
          isA<NegativeNumberException>().having(
            (e) => e.toString(),
            'error message',
            equals('negative numbers not allowed -2,-3'),
          ),
        ),
      );
    });

    test('throws exception showing all negative numbers', () {
      // Arrange
      const String input = '-1,-2,-3';

      // Act & Assert
      expect(
        () => calculator.add(input),
        throwsA(
          isA<NegativeNumberException>().having(
            (e) => e.toString(),
            'error message',
            equals('negative numbers not allowed -1,-2,-3'),
          ),
        ),
      );
    });

    test('throws exception with custom delimiter and negative numbers', () {
      // Arrange
      const String input = '//;\n1;-2;3';

      // Act & Assert
      expect(
        () => calculator.add(input),
        throwsA(
          isA<NegativeNumberException>().having(
            (e) => e.toString(),
            'error message',
            contains('negative numbers not allowed -2'),
          ),
        ),
      );
    });
  });

  group('String Calculator - Edge Cases', () {
    test('handles spaces in numbers', () {
      // Arrange
      const String input = '1, 2, 3';

      // Act
      final int result = calculator.add(input);

      // Assert
      expect(result, equals(6));
    });

    test('handles zero values', () {
      // Arrange
      const String input = '0,0,1';

      // Act
      final int result = calculator.add(input);

      // Assert
      expect(result, equals(1));
    });
  });
}
