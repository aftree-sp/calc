/// 计算器逻辑
class Calculator {
  String _display = '0';
  String _expression = '';
  double? _previousValue;
  String? _operator;
  bool _shouldResetDisplay = false;
  String _lastOperator = '';
  double? _lastOperand;

  String get display => _display;
  String get expression => _expression;

  /// 输入数字
  void inputDigit(String digit) {
    if (_shouldResetDisplay) {
      _display = digit;
      _shouldResetDisplay = false;
    } else {
      if (_display == '0' && digit != '.') {
        _display = digit;
      } else {
        _display += digit;
      }
    }
  }

  /// 输入小数点
  void inputDot() {
    if (_shouldResetDisplay) {
      _display = '0.';
      _shouldResetDisplay = false;
      return;
    }
    if (!_display.contains('.')) {
      _display += '.';
    }
  }

  /// 选择运算符
  void inputOperator(String op) {
    final currentValue = double.tryParse(_display) ?? 0;

    if (_previousValue != null && _operator != null && !_shouldResetDisplay) {
      // 连续运算：先计算之前的
      final result = _calculate(_previousValue!, currentValue, _operator!);
      _display = _formatResult(result);
      _previousValue = result;
    } else {
      _previousValue = currentValue;
    }

    _operator = op;
    _lastOperator = op;
    _expression = '${_formatResult(_previousValue!)} ${_opSymbol(op)}';
    _shouldResetDisplay = true;
  }

  /// 等号
  void inputEquals() {
    final currentValue = double.tryParse(_display) ?? 0;

    if (_operator != null && _previousValue != null) {
      final result = _calculate(_previousValue!, currentValue, _operator!);
      _expression =
          '${_formatResult(_previousValue!)} ${_opSymbol(_operator!)} ${_formatResult(currentValue)} =';
      _display = _formatResult(result);
      _lastOperand = currentValue;
      _previousValue = null;
      _operator = null;
      _shouldResetDisplay = true;
    } else if (_lastOperator.isNotEmpty && _lastOperand != null) {
      // 重复按等号：重复上次运算
      final result = _calculate(currentValue, _lastOperand!, _lastOperator);
      _expression =
          '${_formatResult(currentValue)} ${_opSymbol(_lastOperator)} ${_formatResult(_lastOperand!)} =';
      _display = _formatResult(result);
      _shouldResetDisplay = true;
    }
  }

  /// 清除当前输入 (C)
  void clear() {
    _display = '0';
    _shouldResetDisplay = false;
  }

  /// 全部清除 (AC)
  void allClear() {
    _display = '0';
    _expression = '';
    _previousValue = null;
    _operator = null;
    _shouldResetDisplay = false;
    _lastOperator = '';
    _lastOperand = null;
  }

  /// 正负切换
  void toggleSign() {
    if (_display == '0') return;
    if (_display.startsWith('-')) {
      _display = _display.substring(1);
    } else {
      _display = '-$_display';
    }
  }

  /// 百分比
  void percentage() {
    final value = double.tryParse(_display) ?? 0;
    _display = _formatResult(value / 100);
  }

  /// 退格
  void backspace() {
    if (_shouldResetDisplay) return;
    if (_display.length <= 1 || (_display.length == 2 && _display.startsWith('-'))) {
      _display = '0';
    } else {
      _display = _display.substring(0, _display.length - 1);
    }
  }

  double _calculate(double a, double b, String op) {
    switch (op) {
      case '+':
        return a + b;
      case '-':
        return a - b;
      case '×':
        return a * b;
      case '÷':
        return b == 0 ? double.infinity : a / b;
      default:
        return b;
    }
  }

  String _formatResult(double value) {
    if (value.isInfinite) return 'Error';
    if (value.isNaN) return 'Error';

    // 如果是整数，不显示小数点
    if (value == value.truncateToDouble() && value.abs() < 1e15) {
      return value.toInt().toString();
    }

    // 最多保留 10 位有效数字
    final result = value.toStringAsFixed(10);
    // 去掉尾部的 0
    var trimmed = result.replaceAll(RegExp(r'0+$'), '');
    if (trimmed.endsWith('.')) {
      trimmed = trimmed.substring(0, trimmed.length - 1);
    }
    return trimmed;
  }

  String _opSymbol(String op) {
    return op; // 已经是符号形式
  }
}
