import 'package:example/src/BuildScannerArea.dart';
import 'package:flutter/material.dart';

class Twoscreen extends StatefulWidget {
  const Twoscreen({super.key});

  @override
  State<Twoscreen> createState() => _TwoscreenState();
}

class _TwoscreenState extends State<Twoscreen> {
  String code = "";
  @override
  void initState() {
    super.initState();
  }

  Widget scanBarcodeNormal() {
    return BuildScannerArea(
      title: 'title',
      subtitle: 'subtitle',
      primaryColor: Colors.black,
      backgroundColor: Colors.transparent,
      onResult: (value) {
        code = value;
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Expanded(flex: 1, child: scanBarcodeNormal()),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,

                color: Colors.redAccent,
              ),
            ),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,

                color: const Color.fromARGB(255, 0, 0, 0),
                child: Center(
                  child: Text(
                    code,
                    style: TextStyle(color: Colors.white, fontSize: 26),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
