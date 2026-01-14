test('returns 0 for empty string', () {
  final calculator = StringCalculator();
  expect(calculator.add(''), equals(0));
});
