import 'package:flutter/material.dart';
import 'calculator.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF202124),
      ),
      home: const CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final Calculator _calc = Calculator();

  void _onDigit(String digit) {
    setState(() => _calc.inputDigit(digit));
  }

  void _onDot() {
    setState(() => _calc.inputDot());
  }

  void _onOperator(String op) {
    setState(() => _calc.inputOperator(op));
  }

  void _onEquals() {
    setState(() => _calc.inputEquals());
  }

  void _onClear() {
    setState(() {
      if (_calc.display != '0') {
        _calc.clear();
      } else {
        _calc.allClear();
      }
    });
  }

  void _onToggleSign() {
    setState(() => _calc.toggleSign());
  }

  void _onPercentage() {
    setState(() => _calc.percentage());
  }

  /// 根据显示内容长度自适应字号
  double _getDisplayFontSize(String text) {
    final len = text.length;
    if (len <= 8) return 56;
    if (len <= 11) return 44;
    if (len <= 14) return 36;
    return 28;
  }

  @override
  Widget build(BuildContext context) {
    final isClear = _calc.display == '0';
    final clearLabel = isClear ? 'AC' : 'C';

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ── 显示区 ──
            Expanded(
              child: Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // 表达式
                    SizedBox(
                      height: 28,
                      child: Text(
                        _calc.expression,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // 当前值
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerRight,
                      child: Text(
                        _calc.display,
                        style: TextStyle(
                          fontSize: _getDisplayFontSize(_calc.display),
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                          height: 1.1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── 按键区 ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                children: [
                  // Row 1: AC/+−/%/÷
                  _buildRow([
                    _ButtonConfig(clearLabel, _onClear, type: _ButtonType.function),
                    _ButtonConfig('±', _onToggleSign, type: _ButtonType.function),
                    _ButtonConfig('%', _onPercentage, type: _ButtonType.function),
                    _ButtonConfig('÷', () => _onOperator('÷'),
                        type: _ButtonType.operator, isActive: _calc.expression.endsWith('÷')),
                  ]),
                  const SizedBox(height: 10),
                  // Row 2: 7/8/9/×
                  _buildRow([
                    _ButtonConfig('7', () => _onDigit('7')),
                    _ButtonConfig('8', () => _onDigit('8')),
                    _ButtonConfig('9', () => _onDigit('9')),
                    _ButtonConfig('×', () => _onOperator('×'),
                        type: _ButtonType.operator, isActive: _calc.expression.endsWith('×')),
                  ]),
                  const SizedBox(height: 10),
                  // Row 3: 4/5/6/−
                  _buildRow([
                    _ButtonConfig('4', () => _onDigit('4')),
                    _ButtonConfig('5', () => _onDigit('5')),
                    _ButtonConfig('6', () => _onDigit('6')),
                    _ButtonConfig('−', () => _onOperator('-'),
                        type: _ButtonType.operator, isActive: _calc.expression.endsWith('−')),
                  ]),
                  const SizedBox(height: 10),
                  // Row 4: 1/2/3/+
                  _buildRow([
                    _ButtonConfig('1', () => _onDigit('1')),
                    _ButtonConfig('2', () => _onDigit('2')),
                    _ButtonConfig('3', () => _onDigit('3')),
                    _ButtonConfig('+', () => _onOperator('+'),
                        type: _ButtonType.operator, isActive: _calc.expression.endsWith('+')),
                  ]),
                  const SizedBox(height: 10),
                  // Row 5: 0/./=
                  _buildLastRow([
                    _ButtonConfig('0', () => _onDigit('0'), wide: true),
                    _ButtonConfig('.', _onDot),
                    _ButtonConfig('=', _onEquals, type: _ButtonType.equals),
                  ]),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(List<_ButtonConfig> buttons) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttons.map((b) => _buildButton(b)).toList(),
    );
  }

  Widget _buildLastRow(List<_ButtonConfig> buttons) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttons.map((b) {
        if (b.wide) return _buildWideButton(b);
        return _buildButton(b);
      }).toList(),
    );
  }

  static const double _buttonSize = 74;

  Widget _buildButton(_ButtonConfig config) {
    final color = _getButtonColor(config.type, config.isActive);
    final textColor = _getButtonTextColor(config.type, config.isActive);

    return SizedBox(
      width: _buttonSize,
      height: _buttonSize,
      child: Material(
        color: color,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: config.onTap,
          child: Center(
            child: Text(
              config.label,
              style: TextStyle(
                fontSize: config.type == _ButtonType.operator ? 32 : 28,
                fontWeight: config.type == _ButtonType.function
                    ? FontWeight.w500
                    : FontWeight.w400,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWideButton(_ButtonConfig config) {
    final color = _getButtonColor(config.type, false);
    final textColor = _getButtonTextColor(config.type, false);

    return SizedBox(
      height: _buttonSize,
      width: _buttonSize * 2 + 10, // 两个按钮宽度 + 间距
      child: Material(
        color: color,
        shape: StadiumBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: config.onTap,
          child: Center(
            child: Text(
              config.label,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w400,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getButtonColor(_ButtonType type, bool isActive) {
    switch (type) {
      case _ButtonType.digit:
        return const Color(0xFF3C4043);
      case _ButtonType.function:
        return const Color(0xFF5F6368);
      case _ButtonType.operator:
        return isActive ? Colors.white : const Color(0xFF4285F4);
      case _ButtonType.equals:
        return const Color(0xFF4285F4);
    }
  }

  Color _getButtonTextColor(_ButtonType type, bool isActive) {
    switch (type) {
      case _ButtonType.digit:
        return Colors.white;
      case _ButtonType.function:
        return Colors.white;
      case _ButtonType.operator:
        return isActive ? const Color(0xFF4285F4) : Colors.white;
      case _ButtonType.equals:
        return Colors.white;
    }
  }
}

enum _ButtonType { digit, function, operator, equals }

class _ButtonConfig {
  final String label;
  final VoidCallback onTap;
  final _ButtonType type;
  final bool wide;
  final bool isActive;

  const _ButtonConfig(
    this.label,
    this.onTap, {
    this.type = _ButtonType.digit,
    this.wide = false,
    this.isActive = false,
  });
}
