import 'package:flutter_test/flutter_test.dart';
import 'package:calculator/calculator.dart';

void main() {
  group('Calculator Logic', () {
    late Calculator calc;

    setUp(() {
      calc = Calculator();
    });

    test('initial display is 0', () {
      expect(calc.display, '0');
    });

    test('digit input replaces 0', () {
      calc.inputDigit('5');
      expect(calc.display, '5');
    });

    test('digit input appends when non-zero', () {
      calc.inputDigit('1');
      calc.inputDigit('2');
      calc.inputDigit('3');
      expect(calc.display, '123');
    });

    test('dot input works', () {
      calc.inputDigit('3');
      calc.inputDot();
      calc.inputDigit('1');
      expect(calc.display, '3.1');
    });

    test('dot not duplicated', () {
      calc.inputDigit('1');
      calc.inputDot();
      calc.inputDot();
      calc.inputDigit('5');
      expect(calc.display, '1.5');
    });

    test('addition works', () {
      calc.inputDigit('2');
      calc.inputOperator('+');
      calc.inputDigit('3');
      calc.inputEquals();
      expect(calc.display, '5');
    });

    test('subtraction works', () {
      calc.inputDigit('1');
      calc.inputDigit('0');
      calc.inputOperator('-');
      calc.inputDigit('4');
      calc.inputEquals();
      expect(calc.display, '6');
    });

    test('multiplication works', () {
      calc.inputDigit('6');
      calc.inputOperator('×');
      calc.inputDigit('7');
      calc.inputEquals();
      expect(calc.display, '42');
    });

    test('division works', () {
      calc.inputDigit('1');
      calc.inputDigit('5');
      calc.inputOperator('÷');
      calc.inputDigit('3');
      calc.inputEquals();
      expect(calc.display, '5');
    });

    test('division by zero shows Error', () {
      calc.inputDigit('5');
      calc.inputOperator('÷');
      calc.inputDigit('0');
      calc.inputEquals();
      expect(calc.display, 'Error');
    });

    test('clear resets display only', () {
      calc.inputDigit('1');
      calc.inputDigit('2');
      calc.clear();
      expect(calc.display, '0');
    });

    test('all clear resets everything', () {
      calc.inputDigit('1');
      calc.inputOperator('+');
      calc.inputDigit('2');
      calc.inputEquals();
      calc.allClear();
      expect(calc.display, '0');
      expect(calc.expression, '');
    });

    test('toggle sign works', () {
      calc.inputDigit('5');
      calc.toggleSign();
      expect(calc.display, '-5');
      calc.toggleSign();
      expect(calc.display, '5');
    });

    test('percentage works', () {
      calc.inputDigit('5');
      calc.inputDigit('0');
      calc.percentage();
      expect(calc.display, '0.5');
    });

    test('backspace works', () {
      calc.inputDigit('1');
      calc.inputDigit('2');
      calc.inputDigit('3');
      calc.backspace();
      expect(calc.display, '12');
    });

    test('backspace to single digit gives 0', () {
      calc.inputDigit('5');
      calc.backspace();
      expect(calc.display, '0');
    });

    test('continuous operations work', () {
      calc.inputDigit('1');
      calc.inputOperator('+');
      calc.inputDigit('2');
      calc.inputOperator('×');
      // 1+2=3, then ×...
      expect(calc.display, '2');
      expect(calc.expression, '3 ×');
    });

    test('repeated equals repeats last operation', () {
      calc.inputDigit('5');
      calc.inputOperator('+');
      calc.inputDigit('3');
      calc.inputEquals(); // 8
      calc.inputEquals(); // 11
      calc.inputEquals(); // 14
      expect(calc.display, '14');
    });

    test('decimal result formatting', () {
      calc.inputDigit('1');
      calc.inputOperator('÷');
      calc.inputDigit('3');
      calc.inputEquals();
      // 1/3 = 0.3333333333...
      expect(calc.display, startsWith('0.3333333333'));
    });

    test('large number addition', () {
      calc.inputDigit('9');
      calc.inputDigit('9');
      calc.inputDigit('9');
      calc.inputOperator('+');
      calc.inputDigit('1');
      calc.inputEquals();
      expect(calc.display, '1000');
    });

    test('operator button active state reflected in expression', () {
      calc.inputDigit('8');
      calc.inputOperator('+');
      expect(calc.expression, '8 +');
    });
  });
}
