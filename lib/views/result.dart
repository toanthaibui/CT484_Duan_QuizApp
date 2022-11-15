import 'package:flutter/material.dart';
import 'package:quiz_app/widgets/widgets.dart';

class Result extends StatefulWidget {
  final int correct, incorrect, total;
  Result({required this.correct, required this.incorrect, required this.total});

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              "${widget.correct}/${widget.total}",
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              "Bạn trả lời đúng ${widget.correct} câu và sai ${widget.incorrect} câu",
              style: TextStyle(fontSize: 15, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 14,
            ),
            GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: blueButton(
                    context: context,
                    label: "Quay về trang chủ",
                    buttonWidth: MediaQuery.of(context).size.width / 2))
          ]),
        ),
      ),
    );
  }
}
