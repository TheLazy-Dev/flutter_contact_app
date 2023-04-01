import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class DialerScreen extends StatelessWidget {
  const DialerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Dialer(),
    );
  }
}

class Dialer extends StatefulWidget {
  const Dialer({super.key});

  @override
  State<Dialer> createState() => _DialerState();
}

class _DialerState extends State<Dialer> {
  String _display = '';

  void _onPressed(String value) {
    setState(() {
      _display += value;
    });
  }

  void _onClear() {
    setState(() {
      _display = '';
    });
  }

  void _onCall() {
    launchUrl(Uri.parse('tel://${_display}'));
  }

  void _removeRecentValue() {
    setState(() {
      _display.isNotEmpty
          ? _display = _display.substring(0, _display.length - 1)
          : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 100.h,
              width: MediaQuery.of(context).size.width,
              color: const Color(0xff5324fd),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                _display,
                style: TextStyle(
                    fontSize: _display.length < 11 ? 45.sp : 25.sp,
                    color: Colors.white),
              ),
            ),
          ],
        ),
        SizedBox(
          height: _display.length < 11 ? 60.sp : 44.sp,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildButton('1'),
            _buildButton('2'),
            _buildButton('3'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildButton('4'),
            _buildButton('5'),
            _buildButton('6'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildButton('7'),
            _buildButton('8'),
            _buildButton('9'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildButton('0'),
            _buildButton('<'),
          ],
        ),
        SizedBox(height: 30.sp),
        InkWell(
          onTap: () {
            _onCall();
            // Callback function for button press
          },
          child: Container(
            width: 75,
            height: 75,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green,
            ),
            child: const Icon(
              Icons.phone,
              size: 45,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildButton(
    String label,
  ) {
    return Visibility(
      visible: !(label == '<' && _display.isEmpty),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onLongPress: () {
            label == '<' ? _onClear() : null;
          },
          onTap: () {
            label == '<' ? _removeRecentValue() : _onPressed(label);
          },
          child: Container(
            width: 70,
            height: 70,
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(
                    2.0,
                    8.0,
                  ),
                  blurRadius: 8.0,
                  spreadRadius: 0.6,
                ),
                BoxShadow(
                  color: Colors.white,
                  offset: Offset(0.0, 0.0),
                  blurRadius: 0.0,
                  spreadRadius: 0.0,
                ),
              ],
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topRight,
                stops: [4],
                colors: [Color.fromARGB(255, 55, 55, 55)],
              ),
            ),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                    fontSize: 25.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String eval(String expression) {
    try {
      // Use the built-in 'dart:math' library to evaluate the expression.
      return '${evaluator(expression)}';
    } catch (e) {
      return 'Error';
    }
  }

  num evaluator(String expression) {
    var fn = expression.replaceAll(RegExp('[^0-9./*+\\-]'), '');
    return num.parse(fn);
  }
}
