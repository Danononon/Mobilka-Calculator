import 'package:calculator/button_values.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String number1 = "";
  String operand = "";
  String number2 = "";

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.all(16),
                child: Text(
                  "$number1$operand$number2".isEmpty
                      ? "0"
                      : "$number1$operand$number2",
                  style: const TextStyle(
                    fontSize: 70,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ),
            Wrap(
              children: Btn.buttonValues
                  .map(
                    (value) => SizedBox(
                        width: screenSize.width / 4,
                        height: screenSize.width / 5,
                        child: buildButton(value)),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  // #######
  Widget buildButton(value) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        color: getBtnColor(value),
        clipBehavior: Clip.hardEdge,
        shape: CircleBorder(
          side: BorderSide(
            color: Colors.white24,
          ),
        ),
        child: InkWell(
          onTap: () => onBtnTap(value),
          child: Center(
            child: Text(
              value,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
          ),
        ),
      ),
    );
  }

// ####################
  void onBtnTap(String value) {
    if (value == Btn.del) {
      delete();
      return;
    }

    if (value == Btn.clr) {
      clearAll();
      return;
    }

    if (value == Btn.calculate) {
      calculate();
      return;
    }

    if (value == Btn.square) {
      square();
      return;
    }

    if (value == Btn.sqrt) {
      calcSqrt();
      return;
    }

    if (number2.isNotEmpty &&
        (value == Btn.add ||
            value == Btn.divide ||
            value == Btn.multiply ||
            value == Btn.subtract)) {
      calculate();
      operand = value;
      number2 = "";
      setState(() {});
      return;
    }

    appendValue(value);
  }

// ####################
  void delete() {
    if (number2.isNotEmpty) {
      if (number2 == "0.") {
        number2 = number2.substring(0, number2.length - 2);
      } else {
        number2 = number2.substring(0, number2.length - 1);
      }
    } else if (operand.isNotEmpty) {
      operand = "";
    } else if (number1.isNotEmpty) {
      if (number1 == "0.") {
        number1 = number1.substring(0, number1.length - 2);
      } else {
        number1 = number1.substring(0, number1.length - 1);
      }
    }

    setState(() {});
  }

// #####################
  void clearAll() {
    setState(() {
      number1 = "";
      operand = "";
      number2 = "";
    });
  }

// ####################
  void calculate() {
    if (number1.isEmpty || operand.isEmpty || number2.isEmpty) return;

    double num1 = double.parse(number1);
    double num2 = double.parse(number2);

    NumberFormat formatter = NumberFormat('#.##########');

    if (operand == Btn.multiply) {
      number1 = formatter.format(num1 * num2);
    } else if (operand == Btn.add) {
      number1 = formatter.format(num1 + num2);
    } else if (operand == Btn.divide) {
      if ((num1 / num2).isNaN || (num1 / num2).isInfinite) {
        return;
      } else {
        number1 = formatter.format(num1 / num2);
      }
    } else if (operand == Btn.subtract) {
      number1 = formatter.format(num1 - num2);
    }

    operand = "";
    number2 = "";

    setState(() {});
  }

  void square() {
    NumberFormat formatter = NumberFormat('#.###########');
    if (number1.isEmpty ||
        ((!number1.contains(RegExp('[1-9]'))) && number2.isEmpty)) clearAll();
    double num1 = double.parse(number1);
    if (number2.isEmpty) {
      number1 = formatter.format(num1 * num1).toString();
    } else {
      double num2 = double.parse(number2);
      calculate();
      num1 = double.parse(number1);
      number1 = formatter.format(num1 * num1).toString();
    }
    

    operand = "";
    number2 = "";

    setState(() {});
  }

  void calcSqrt() {
    NumberFormat formatter = NumberFormat('#.##########');
    if (number1.isEmpty ||
        ((!number1.contains(RegExp('[1-9]'))) && number2.isEmpty)) clearAll();
    double num1 = double.parse(number1);
    if (number2.isEmpty) {
      if (num1 < 0)
        return;
      else {
        number1 = formatter.format(sqrt(num1)).toString();
      }
    } else {
      double num2 = double.parse(number2);
      calculate();
      num1 = double.parse(number1);
      if (num1 < 0)
        return;
      else {
        number1 = formatter.format(sqrt(num1)).toString();
      }
    }

    operand = "";
    number2 = "";

    setState(() {});
  }

// #####################
  void appendValue(String value) {
    if ((number1.length + number2.length + operand.length) > 10) return;
    if (number1.isEmpty && value == Btn.subtract) {
      number1 = value;
    } else if (number1 == Btn.subtract && value == Btn.dot) {
      number1 += "0.";
    } else {
      if (number1 == Btn.subtract && int.tryParse(value) == null) return;
      if (number1.isEmpty && int.tryParse(value) == null && value != Btn.dot)
        return;
      if (value != Btn.dot && int.tryParse(value) == null) {
        if (operand.isNotEmpty && number2.isNotEmpty) {}
        operand = value;
      } else if (number1.isEmpty || operand.isEmpty) {
        if (value == Btn.dot && number1.contains(Btn.dot)) return;
        if (value == Btn.dot && (number1.isEmpty || number1 == Btn.n0) ||
            (value == Btn.n0 && number1.isEmpty)) {
          value = "0.";
        }
        number1 += value;
      } else if (number2.isEmpty || operand.isNotEmpty) {
        if (value == Btn.dot && number2.contains(Btn.dot)) return;
        if ((value == Btn.dot && (number2.isEmpty || number2 == Btn.n0)) ||
            (value == Btn.n0 && number2.isEmpty)) {
          value = "0.";
        }
        number2 += value;
      }
    }

    setState(() {});
  }

// ####################
  Color getBtnColor(value) {
    return [Btn.del, Btn.clr].contains(value)
        ? const Color.fromARGB(255, 164, 164, 164)
        : [
            Btn.square,
            Btn.multiply,
            Btn.add,
            Btn.subtract,
            Btn.divide,
            Btn.calculate,
            Btn.sqrt,
          ].contains(value)
            ? Colors.orange
            : const Color.fromARGB(255, 50, 50, 50);
  }
}
